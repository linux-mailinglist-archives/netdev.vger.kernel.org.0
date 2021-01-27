Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ABE30631B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhA0STm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhA0STg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:19:36 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD2BC06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 10:18:55 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id by1so4065425ejc.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 10:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDomsmsITn1D4fc/98SnX4xb8KGIDVrSSeTKDZpqWGc=;
        b=dxGptAy5jrxmXW61hPEpaBM6ebaNeAs6VvSCEZeeDQeX7wL9M3/mUKoOw50tUCCuke
         sgzOSBnaY3FKgVixKFCWMxAGOrTWLxTSrhq0u4ia084MF9exS3U1ATY+v8eOPv49jSIc
         hnVsxl0OQoK2xmbDthsBQvfkV+FAH4wUNaoKcjziZVWSrMeoxJsdPyZQCqQ0VfrmCmX3
         Q7EkMunY51q0I7QEikaDRNg4rsRlpdpWWrJhkDXHDqBDMr45wxnJrRL8uXwBYsOMuCBf
         +B5LzVDswDZ0vRY2fWxFBYR8ZLnG7B1SQYVSefPG/0U3nOJLqJyOpt165QR1nzmv7vdj
         h7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDomsmsITn1D4fc/98SnX4xb8KGIDVrSSeTKDZpqWGc=;
        b=oAqSLvXtmZB1Fj2n+uKcVYnqGemNwP5rppCeFq9NnLCrdE3ec79pSTK5IsRdsy8YnX
         RSMbzNpFdQa4+fWhlMhdDKFDRK45uXIbsPvI+1LIqARt2HhY0WcaBB+Owtan5zPIUbEV
         J8H6W7USjSkYD3P59QoxaJxLZt2ICQOiJtf2WPH/UC8Kjzbd2kMwwbdLEi46b1Uvd51W
         Q12KUpjpHctqeMsCfRPfGfdMEkDgl3Ng9ov5xWH8KAEJ9/492BrVj25W50vSjpTgXI7c
         rCzu3StdhzFFQI1LYdzRcp7RzPevWrJPqThdqLZtcMHVEpwqpAeqapuR0uZsE4vXSmvr
         FQjw==
X-Gm-Message-State: AOAM532jpc65I4SL0m7nnF78H5DVQZKlyfe5teCV7xcYnGUl7k0ws1fG
        EY8j4ZYjl5w8HT6PVyEd680/9Jlzcl5Sp6DojdE=
X-Google-Smtp-Source: ABdhPJw5tKzmJSTpSaG5eubei/uLPH/uPlV44yUZnIG7tMUfpAn8zS+ErdC7ocKP2BvsxpSoe7gTbvjuVVg4AZbD+Zw=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr7600799ejj.464.1611771534462;
 Wed, 27 Jan 2021 10:18:54 -0800 (PST)
MIME-Version: 1.0
References: <20210126210830.2919352-1-helgaas@kernel.org> <20210127181359.3008316-1-helgaas@kernel.org>
In-Reply-To: <20210127181359.3008316-1-helgaas@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 13:18:17 -0500
Message-ID: <CAF=yD-KBynwNmyzSQE996P8PNjeh86sP9UQPOU85Qu2QjPBw+g@mail.gmail.com>
Subject: Re: [PATCH v2] octeontx2-af: Fix 'physical' typos
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 1:14 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> Fix misspellings of "physical".
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks Bjorn. Please remember to explicitly mark [PATCH net-next] too.
