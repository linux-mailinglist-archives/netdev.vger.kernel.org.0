Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E0212DF61
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 17:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAAP7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 10:59:37 -0500
Received: from mx.ungleich.ch ([185.203.112.16]:44066 "EHLO smtp.ungleich.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbgAAP7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jan 2020 10:59:37 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jan 2020 10:59:36 EST
Received: from diamond.localdomain (localhost [IPv6:::1])
        by smtp.ungleich.ch (Postfix) with ESMTP id 54BD31FD7E
        for <netdev@vger.kernel.org>; Wed,  1 Jan 2020 16:52:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ungleich.ch; s=mail;
        t=1577893952; bh=zGfrLnshDoIQHp/62s5CO+R2M8F9ZM3UTXWKiOsqA+g=;
        h=From:To:Subject:Date:From;
        b=euTvp7sLRiBo3trDhhNdb1oTHrxOcPgXiF4rAg5XaxY3/EcCs88VR7uw273Ak5tHL
         IePcpP+OeITM5rgJnwvacYQVa4L564fR2vmH5Ad31p12nF8yiO3v/FtZO4YmDYSQuu
         COoznK4JI56dVxtGx8cJQKL2pN/OXsyocC0MRl2WykwrZcesAqwhuP64eNcxo0AeWl
         KtahsTES01NNJX4F61+p0xOUv3QbWQiwtFDUovOH4AFpQEhfRyK1VGvAHjzMNPN/RE
         Nkz3rT97dPdgMjeYrIHlctVPaOZFL0YolyhoYq8RD2ObtOiR5kGaDROmYF1tDNbjYq
         Pz6y3pXSxnICA==
Received: by diamond.localdomain (Postfix, from userid 1000)
        id 4144413E00D0; Wed,  1 Jan 2020 16:52:32 +0100 (CET)
User-agent: mu4e 1.3.5; emacs 26.3
From:   Nico Schottelius <nico.schottelius@ungleich.ch>
To:     netdev@vger.kernel.org
Subject: IPv6 addresses stay tentative (Linux 5.4.6, 5.4.7)
Date:   Wed 01 Jan 2020 04:30:10 PM CET
Maildir: /ungleich/sent
Message-ID: <87mub7tbr3.fsf@ungleich.ch>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


https://roy.marples.name/archives/dhcpcd-discuss/0002774.html

p.s.: I am using accept_ra = 2, because forwarding is also enabled.

Hello,

it seems something in the kernel code changed in regard to setting IPv6
addresses usable (i.e. dad done). Since 5.4.6 IPv6 addresses setup
statically or via autoconf (router advertisements) seem so stay in
"tentative" state forever.

I did not experience this behaviour in 5.3.13 (*) and it seems I am not
the only one affected:

I turned dhcpcd off to test whether it happens without it and indeed the
problem seems to be unrelated to dhcpcd.

Does anyone know about a recent change that may cause this behaviour?

Best regards,

Nico

(*) I cannot boot kernels 5.4.x < 5.4.6, as the wifi card does not show
up with them.

--
Modern, affordable, Swiss Virtual Machines. Visit www.datacenterlight.ch
