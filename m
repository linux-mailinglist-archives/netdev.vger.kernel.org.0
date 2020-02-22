Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC72F168ECD
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 13:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBVMXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 07:23:20 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41085 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726763AbgBVMXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 07:23:19 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id C45594E5
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 07:23:18 -0500 (EST)
Received: from imap21 ([10.202.2.71])
  by compute7.internal (MEProxy); Sat, 22 Feb 2020 07:23:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yawnt.com; h=
        mime-version:message-id:date:from:to:subject:content-type; s=
        fm3; bh=hLytwwhfW5V857QfH4hqKIQdRB5b9ER5LrSuT+Ri3Lk=; b=p1qd+jh4
        WnwBS0bi/EOvu4S/VdwHyqzUB82V5qYcwn83BQCfbue3pi9BCXwUMHaIIRTIEpqg
        RfcbSD79Uvf/b1XGY4d/CLgePI0omrUdcsz23BU1a9/QapPJPSmr7IFSJg1S2gzO
        ovorPohyCPMiNfyiT/lYAiCHNZDxdIbhI1Zo7SP7HgWqsSfKOw7VL5mBv4F4N3+R
        b6Z/uwtFqfHTgtPbvca8djHJ/Z13Ym6uaX4F4Q+XHfQUn3yZ8v4wA/cMLXu4q4Jc
        dnQ2YUy0Y6X53piohc/zD7JCbz8Nsl91YIY/nqvLOVKOLkwbFQR27lGuccrrPxMp
        hMA/LJMwRU21mA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=hLytwwhfW5V857QfH4hqKIQdRB5b9
        ER5LrSuT+Ri3Lk=; b=rUAZ6S1M0K5s00iBM2VeamQzfIGAVzFTIc4BMbsDEPzZn
        YoWeqQi2kYw6ku+Uur3igUzmdA2VwXiLLM5hyOJ5/P1iqV2QaB5gbLLe70xHhgPj
        lo+vepXz9VABTA60laUitTmOuJNFOc5ypFp1hfX2j/FPquzvz8eEEA14wWGDbmIC
        7Y7tA6+spB33zPPF4XM1Qsp8m2bx2a68eQ6Qlto/VHVrLKl1w+k6VbD/dddfu1WQ
        sC3bZAWVPfn00JhUXz0nruWLDsRfxVH5mSp/0NS8XFILVbEXG7sE4Tn9ACzo/Le+
        hFpJigzCEK3nhcfFhLV5sPa7Eu/T6ZVngGgLupu6A==
X-ME-Sender: <xms:Nh1RXr99k1IJj-MvNuDLADR13WEsxofdM6yVWSYYUGXlUJT60LWdrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeigdegtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgesthdtredtre
    ertdenucfhrhhomhepfdfiihgrnhhluhgtrgcuufhtihhvrghnfdcuoehmvgeshigrfihn
    thdrtghomheqnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepmhgvseihrgifnhhtrdgtohhm
X-ME-Proxy: <xmx:Nh1RXv40TPyoGODtbgIs3FHwf0PltYKjYAJvAREVeYzEsooPGHLzhw>
    <xmx:Nh1RXkmGsYv_Z5yKnWJf4qLxpuCj6DaOmCLpPDQJq0e_hFrwxYpOdQ>
    <xmx:Nh1RXiFJAHVTc__NnTxxMwb480vsRhbqVRVNEw_1kLOJdOSiF64UQw>
    <xmx:Nh1RXsXyM7g7XXcR3wAH_Na9LkIZNZVuh2XaszSebiqm4HsZg3iRqA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 34C2C660069; Sat, 22 Feb 2020 07:23:18 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-802-g7a41c81-fmstable-20200203v1
Mime-Version: 1.0
Message-Id: <cfd2e094-2346-4d6d-bc53-0db1ae72b8c3@www.fastmail.com>
Date:   Sat, 22 Feb 2020 12:22:57 +0000
From:   "Gianluca Stivan" <me@yawnt.com>
To:     netdev@vger.kernel.org
Subject: question about ip rule uidrange
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I'm trying to setup routing based on uidrange, and I seem to keep hitting the same issue. My understanding is that if a certain user is running a process, the corresponding table is looked up when the uid is in the uidrange.

$ whoami
yawnt
$ id
uid=1000(yawnt) 
$ ip rule list
0:	from all lookup local
32765:	from all uidrange 1000-1000 lookup custom
32766:	from all lookup main
32767:	from all lookup default
$ ip route list table custom
default via 192.168.1.1 dev wlp4s0 proto dhcp metric 600

With this configuration, there is no internet connection. Traceroute just hangs. On a TCP level, I see SYN being sent, SYN/ACK being received, but then no ACK being sent from my computer.

However, if I change 32675 to "from all lookup custom", then it works.

$ sudo ip rule del uidrange 1000-1000
$ sudo ip rule add lookup custom
$ ip rule list
0:	from all lookup local
32765:	from all lookup custom
32766:	from all lookup main
32767:	from all lookup default
$ curl google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
...

I'm running ArchLinux with iproute2 version 5.5.0. I wonder if I'm doing something wrong or this is a bug?

Thanks in advance!
Best,

Gianluca
