Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E02C23F26D
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 20:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgHGSEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 14:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgHGSEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 14:04:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042592075D;
        Fri,  7 Aug 2020 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596823483;
        bh=RSMl2ntL1d76/kc9CXYy5VSQyaNgn/6MPpZbXP7P/XA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xQI9JWhQeMl9te6tCLjVG1xmKiJmpQPyZq6saJBGt2Xpe6QETkpNJ1fz/Drv4Vzq4
         crvt1UdI/qDBy/SC9igWTltdlstoOHfKHAxzU//IY+wREgETK3e/0gwVDSI8gTaPN/
         iEmyxIu4CY0Wp+dxWE9fVB9z4G9s2YRUF2XXdKGY=
Date:   Fri, 7 Aug 2020 11:04:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rouven Czerwinski <r.czerwinski@pengutronix.de>
Cc:     Pooja Trivedi <poojatrivedi@gmail.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next] net/tls: allow MSG_CMSG_COMPAT in sendmsg
Message-ID: <20200807110441.6df98445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f088c78e335653c8e07d6f304b5995602ee7398f.camel@pengutronix.de>
References: <20200806064906.14421-1-r.czerwinski@pengutronix.de>
        <20200806114657.42f1ce8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b55718ad4e675ed9a9c3eb1c5d952945f8b20c7a.camel@pengutronix.de>
        <f088c78e335653c8e07d6f304b5995602ee7398f.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 07 Aug 2020 14:27:48 +0200 Rouven Czerwinski wrote:
> I just tested on my x86_64 workstation and these specific tests fail
> there too, do they only work on 5.8? They were added in 5.8, but I am
> running 5.7.11 here. It looks like these failures are not
> MSG_CMSG_COMPAT related.
>=20
> Pooja Trivedi do you have an idea?

=F0=9F=98=AF

We need this:

https://lore.kernel.org/netdev/1591392508-14592-1-git-send-email-pooja.triv=
edi@stackpath.com/

Looks like it never ended up getting applied to any tree.

Pooja is that the case? Could you please resend without the RFC tag?
