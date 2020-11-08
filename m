Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318E02AAABD
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 12:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgKHLnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 06:43:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgKHLnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 06:43:08 -0500
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECC76221FA;
        Sun,  8 Nov 2020 11:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604835786;
        bh=4qcv3PIZoS9Ti9M9OtYV1punEYgw5Sm+kDyvXqo+hQY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cDRAdYzLiZ+IhL2nfUuSHGyRVDqNzeN5Fjmlbav0H0lAVvL8TtfEHblAcT4AQ9r7a
         5k/uNiUCUD/RLIEPkT/eoNdayDgyh4DLf9NojP8NIscEy0H6eZvXrIK/66ZPS5HRLl
         flfTLVRDxH0PYsg+WKGMIFIIZyanbx2eDzEYoTsg=
Received: by mail-oi1-f182.google.com with SMTP id j7so6889614oie.12;
        Sun, 08 Nov 2020 03:43:05 -0800 (PST)
X-Gm-Message-State: AOAM531dXTpDMZP8zJE9VQ7NcxYU/9/QVI94yvjgUt8Ojsqj4vsfo+qR
        mCwlVJIMjzb2z7zPE5uG1t0gH6DJ/D/m+SXOmBg=
X-Google-Smtp-Source: ABdhPJy9Hv8+gtR2q1q9eRdnrQmfMucRJEzdFZAQvvSugW1m7+Tb9RkaOCsD1/ioGJgKBxlUqmoSyklpyawgiwTjzzA=
X-Received: by 2002:a05:6808:602:: with SMTP id y2mr6405737oih.11.1604835785227;
 Sun, 08 Nov 2020 03:43:05 -0800 (PST)
MIME-Version: 1.0
References: <20201106221743.3271965-1-arnd@kernel.org> <20201107160612.2909063a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87tuu05c23.fsf@tynnyri.adurom.net>
In-Reply-To: <87tuu05c23.fsf@tynnyri.adurom.net>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 8 Nov 2020 12:42:49 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3y5WxsibmTzvhv76G+rQ1Zjo_tW0UkXku0VnZdQa-__A@mail.gmail.com>
Message-ID: <CAK8P3a3y5WxsibmTzvhv76G+rQ1Zjo_tW0UkXku0VnZdQa-__A@mail.gmail.com>
Subject: Re: [RFC net-next 00/28] ndo_ioctl rework
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org, linux-hams@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 8, 2020 at 12:21 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>
> So I don't know what to do. Should we try adding a warning like below? :)
>
>   "This ancient driver will be removed from the kernel in 2022, but if
>    it still works send report to <...@...> to avoid the removal."
>
> How do other subsystems handle ancient drivers?

A good way to get everyone's attention would be to collect as many
drivers as possible that are almost certainly unused and move them to
drivers/staging/ with a warning like the above, as I just did for
drivers/wimax. That would make it to the usual news outlets
and lead to the remaining users (if any) noticing it so they can then
ask for the drivers to be moved back -- or decide it's time to let go
if the hardware can easily be replaced.

      Arnd
