Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D145FCD34
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiJLV3c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Oct 2022 17:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiJLV3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:29:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2CA120ECC
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:29:08 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-269-WPghBqosPyeNkdeVSYELTw-1; Wed, 12 Oct 2022 22:29:04 +0100
X-MC-Unique: WPghBqosPyeNkdeVSYELTw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 12 Oct
 2022 22:29:02 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Wed, 12 Oct 2022 22:29:02 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joe Perches' <joe@perches.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-actions@lists.infradead.org" 
        <linux-actions@lists.infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "cake@lists.bufferbloat.net" <cake@lists.bufferbloat.net>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH v1 3/5] treewide: use get_random_u32() when possible
Thread-Topic: [PATCH v1 3/5] treewide: use get_random_u32() when possible
Thread-Index: AQHY3m9QJDmwhr5XuUa4Hi/RfD23ja4LRXVg
Date:   Wed, 12 Oct 2022 21:29:02 +0000
Message-ID: <d45bd258e033453b85a137112e7694e1@AcuMS.aculab.com>
References: <20221005214844.2699-1-Jason@zx2c4.com>
         <20221005214844.2699-4-Jason@zx2c4.com>
 <f8ad3ba44d28dec1a5f7626b82c5e9c2aeefa729.camel@perches.com>
In-Reply-To: <f8ad3ba44d28dec1a5f7626b82c5e9c2aeefa729.camel@perches.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches
> Sent: 12 October 2022 20:17
> 
> On Wed, 2022-10-05 at 23:48 +0200, Jason A. Donenfeld wrote:
> > The prandom_u32() function has been a deprecated inline wrapper around
> > get_random_u32() for several releases now, and compiles down to the
> > exact same code. Replace the deprecated wrapper with a direct call to
> > the real function.
> []
> > diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> []
> > @@ -734,7 +734,7 @@ static int send_connect(struct c4iw_ep *ep)
> >  				   &ep->com.remote_addr;
> >  	int ret;
> >  	enum chip_type adapter_type = ep->com.dev->rdev.lldi.adapter_type;
> > -	u32 isn = (prandom_u32() & ~7UL) - 1;
> > +	u32 isn = (get_random_u32() & ~7UL) - 1;
> 
> trivia:
> 
> There are somewhat odd size mismatches here.
> 
> I had to think a tiny bit if random() returned a value from 0 to 7
> and was promoted to a 64 bit value then truncated to 32 bit.
> 
> Perhaps these would be clearer as ~7U and not ~7UL

That makes no difference - the compiler will generate the same code.

The real question is WTF is the code doing?
The '& ~7u' clears the bottom 3 bits.
The '- 1' then sets the bottom 3 bits and decrements the
(random) high bits.

So is the same as get_random_u32() | 7.
But I bet the coder had something else in mind.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

