Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0AB19746
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfEJD7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 23:59:31 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35519 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbfEJD7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 23:59:31 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6EEE121448;
        Thu,  9 May 2019 23:59:30 -0400 (EDT)
Received: from imap37 ([10.202.2.87])
  by compute5.internal (MEProxy); Thu, 09 May 2019 23:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tobin.cc; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm3; bh=7JuLeiITaoq/ZdIt1bv+Coe9tJr2OvJ
        fGTrs9RPOvKA=; b=QRaNsKU2yIFWnd/ZcyvstDBPG7JdMj/uZvV58FYXS1/qgZ/
        pFjkIspYzXP0CJ4/47U+xJZMPEZKUS2q1F4bfrTEgfx9ceAZDLGqMq8WVNho4GZR
        2AH336rmuPHe1/EapseaOMx2jk7lQWGdp/Ia8awBScSIaknC7pWAFbuwm6fV5JOY
        oi9NYWd6ZQ0WaUHhI6r+626ZTXR5asnCJofbp8RN7xs5xsiBuVfQjxv7ywvVKVTj
        7+ogtpeyqUQaIazvZCAf3u1HfhQkGlVvFa2y48yPO1+S9Zn84JwJoViRyIB42aZW
        y3D7MqqyojeuNe/xSSw5M7d33wqBLEdAr4KEOPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7JuLei
        ITaoq/ZdIt1bv+Coe9tJr2OvJfGTrs9RPOvKA=; b=fER8xRcxPuMQVq7d781NQf
        7qk5hbsWy87SFgiYTTjqKaiSR80OiLs4BGjRXiYX/lTE4JowdVdrFVHrbjw+m1iy
        GEwzSWoaUGqWmXziyTSBmKcu0HGx4Z6gd2CPPL2iXgNdYVG44AmiyXhrvndfoLEp
        dimkft4Mkv5PKoB4v0K4ynQyAx8W0Y3tahbjxm0iUvwo6q9ihqikIcVmB/stxBcE
        iBIrPDBRV/jelcvZZx2g3C7ZFFRIOHbNod1fuyHUH9p3/6IcJE8wFgeg2Iz1cMYJ
        2mduFcXfHw1bYf1AnBIshWennh/4tFzQ/UygESH9QF4duYmnxlAhXFS/rp4Vec1A
        ==
X-ME-Sender: <xms:IffUXLKs1PxeMlJcyslS9XYcxfU9IyiGrrnME7Q7Aeh0sL99WZUUSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeigddukeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpefofgggkfgjfhffhffvufgtsehttdertder
    redtnecuhfhrohhmpedfvfhosghinhcuvedrucfjrghrughinhhgfdcuoehmvgesthhosg
    hinhdrtggtqeenucfrrghrrghmpehmrghilhhfrhhomhepmhgvsehtohgsihhnrdgttgen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:IffUXFITYSJnV5Km32SOewfsCeQBDQYnDocZ7tHH0yPqvHnnt__Riw>
    <xmx:IffUXBXckfp4QVCM_OTahE55kPgggfzKkRq2ZctN_KktKVX-H2D2Og>
    <xmx:IffUXPjbC_0wfjf34LaWFoccroQRPJmUwzDhx13DLwwY_kUEBYxRUQ>
    <xmx:IvfUXHRW36MRVD_2Gt5PBeloWC8_tNxfCkKrHDAF-W8LUz33EM2rWQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A399FDEC1A; Thu,  9 May 2019 23:59:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.6-449-gfb3fc5a-fmstable-20190430v1
Mime-Version: 1.0
Message-Id: <8446e80f-49e5-4792-900f-49aa61165644@www.fastmail.com>
In-Reply-To: <20190509203501.310a477c@hermes.lan>
References: <20190510025212.10109-1-tobin@kernel.org>
 <20190510025702.GA10709@eros.localdomain>
 <20190509203501.310a477c@hermes.lan>
Date:   Thu, 09 May 2019 23:59:01 -0400
From:   "Tobin C. Harding" <me@tobin.cc>
To:     "Stephen Hemminger" <stephen@networkplumber.org>,
        "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Roopa Prabhu" <roopa@cumulusnetworks.com>,
        "Nikolay Aleksandrov" <nikolay@cumulusnetworks.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        bridge@lists.linux-foundation.org,
        "Network Development" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] bridge: Fix error path for kobject_init_and_add()
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, May 10, 2019, at 13:35, Stephen Hemminger wrote:
> On Fri, 10 May 2019 12:57:02 +1000
> "Tobin C. Harding" <tobin@kernel.org> wrote:
> 
> > On Fri, May 10, 2019 at 12:52:12PM +1000, Tobin C. Harding wrote:
> > 
> > Please ignore - I forgot about netdev procedure and the merge window.
> > My bad.
> > 
> > Will re-send when you are open.
> > 
> > thanks,
> > Tobin.
> 
> That only applies to new features,  bug fixes are allowed all the time.
> Also please dont send networking stuff to the greater linux-kernel mailing list.

Oh cool, thanks.
