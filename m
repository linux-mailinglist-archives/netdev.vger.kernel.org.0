Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D4287DF0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgJHV1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730939AbgJHV1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 17:27:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18AC42223F;
        Thu,  8 Oct 2020 21:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602192465;
        bh=md964LDAz9lQFVj2JzGHwkkpPGFtiLjWoXMwswrtC6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zbL2yEH2KQcI+3pbktzM6T4Ka8+EY+hg3hOdhS6FUSgJKup3/1qnfL6BebfezFN71
         UZkhEgj2ktS0YAnqIaVGB/cGLyXM/YB9W1PbpKChvZCfTJ4rejPEKhT0lwe8/XG+fN
         hCfrQsDYo2Z6n7upLI++Ulh8WgCuMMCJryPwGDDY=
Date:   Thu, 8 Oct 2020 14:27:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: add Cellient MPL200 card
Message-ID: <20201008142743.1c2e1c0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87v9fkhcda.fsf@miraculix.mork.no>
References: <cover.1602140720.git.wilken.gottwalt@mailbox.org>
        <f5858ed121df35460ef17591152d606a78aa65db.1602140720.git.wilken.gottwalt@mailbox.org>
        <87d01ti1jb.fsf@miraculix.mork.no>
        <20201008095616.35a21c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v9fkhcda.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 08 Oct 2020 19:10:57 +0200 Bj=C3=B8rn Mork wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>=20
> > I'm guessing that I'm supposed to take this patch into the networking
> > tree, correct? =20
>=20
> Correct.
>=20
> > Is this net or net-next candidate? Bj=C3=B8rn? =20
>=20
> Sorry, should have made that explicit. This is for net + stable

Done, thank you!
