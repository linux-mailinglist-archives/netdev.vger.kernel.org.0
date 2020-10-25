Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EB7298217
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 15:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416634AbgJYO1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 10:27:52 -0400
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:37856 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416629AbgJYO1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 10:27:45 -0400
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 33BCF20DC5
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 14:27:43 +0000 (UTC)
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.100])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 064F220100
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 14:27:40 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id AB31E3F157;
        Sun, 25 Oct 2020 14:27:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 8452B2A359;
        Sun, 25 Oct 2020 10:27:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1603636054;
        bh=QKWC7K1DaecDN1uRa2cxB9r0kPPPvZdGISVuxri4Qbg=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=bP5cg7lsgyAmFT8tzbEdSLtx28cIOEVBm3CtdGfYWcersE9nUhJj2T590oewvB15X
         EKwIpug3FNi4P5nOMjETw+pBnxSxVrZjCf16JGYOSR0rQQHGdavxsph+5elrKfmejO
         MynssFC+vXezZl7dI6AmOFwTwKIWI/YvgAJILcTo=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1IfFYK13rwf1; Sun, 25 Oct 2020 10:27:33 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Sun, 25 Oct 2020 10:27:32 -0400 (EDT)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 2731840849;
        Sun, 25 Oct 2020 14:27:31 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="nYvqUBgy";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [172.19.0.1] (unknown [64.225.114.122])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 0BD4F400C0;
        Sun, 25 Oct 2020 14:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1603636044; bh=QKWC7K1DaecDN1uRa2cxB9r0kPPPvZdGISVuxri4Qbg=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=nYvqUBgyy/tgJ/iullgI0HsBQn/I5TrzleQBXoFBnomqXq4lBXJIjnBfFWkKpOxWF
         XVNJIzW3rlyyJRhhPwaEfFwCHlvC2FFlA7XSCjxumWxnt69jb/YBoAmlKryr/38MN0
         D8p/ocBibcKYdS/J6QjxgoiLonlapfgNl57HRNxw=
Date:   Sun, 25 Oct 2020 22:27:05 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20201025141825.GB792004@lunn.ch>
References: <20201025085556.2861021-1-icenowy@aosc.io> <20201025141825.GB792004@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [linux-sunxi] Re: [PATCH] net: phy: realtek: omit setting PHY-side delay when "rgmii" specified
To:     andrew@lunn.ch, Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sunxi@googlegroups.com
From:   Icenowy Zheng <icenowy@aosc.io>
Message-ID: <77AAA8B8-2918-4646-BE47-910DDDE38371@aosc.io>
X-Rspamd-Queue-Id: 2731840849
X-Spamd-Result: default: False [1.40 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         R_SPF_SOFTFAIL(0.00)[~all];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[aosc.io:+];
         RCPT_COUNT_TWELVE(0.00)[12];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         FREEMAIL_CC(0.00)[gmail.com,armlinux.org.uk,davemloft.net,kernel.org,realtek.com,siol.net,vger.kernel.org,googlegroups.com];
         SUSPICIOUS_RECIPS(1.50)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



=E4=BA=8E 2020=E5=B9=B410=E6=9C=8825=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=88=
10:18:25, Andrew Lunn <andrew@lunn=2Ech> =E5=86=99=E5=88=B0:
>On Sun, Oct 25, 2020 at 04:55:56PM +0800, Icenowy Zheng wrote:
>> Currently there are many boards that just set "rgmii" as phy-mode in
>the
>> device tree, and leave the hardware [TR]XDLY pins to set PHY delay
>mode=2E
>>=20
>> In order to keep old device tree working, omit setting delay for just
>> "RGMII" without any internal delay suffix, otherwise many devices are
>> broken=2E
>
>Hi Icenowy
>
>We have been here before with the Atheros PHY=2E It did not correctly
>implement one of the delay modes, until somebody really did need that
>mode=2E So the driver was fixed=2E And we then found a number of device
>trees were also buggy=2E It was painful for a while, but all the device
>trees got fixed=2E

1=2E As the PHY chip has hardware configuration for configuring delays,
we should at least have a mode that respects what's set on the hardware=2E
2=2E As I know, at least Fedora ships a device tree with their bootloader,=
 and
the DT will not be updated with kernel=2E This enforces compatibility
with old DTs even if they're broken=2E

Personally I think if someone wants a mode that explicitly disable delays
in the PHY, a new mode may be created now, maybe called "rgmii-noid"=2E

>
>We should do the same here=2E Please submit patches for the device tree
>files=2E
>
>   Andrew
