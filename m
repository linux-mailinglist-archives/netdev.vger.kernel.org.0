Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DA247AACD
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 15:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhLTOAp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Dec 2021 09:00:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:35237 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232476AbhLTOAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 09:00:44 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-106-ThBTv8hIOJK8PeJnyhEimg-1; Mon, 20 Dec 2021 14:00:42 +0000
X-MC-Unique: ThBTv8hIOJK8PeJnyhEimg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 20 Dec 2021 14:00:40 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 20 Dec 2021 14:00:40 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joe Perches' <joe@perches.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "ulli.kroll@googlemail.com" <ulli.kroll@googlemail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "gbhat@marvell.com" <gbhat@marvell.com>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andy Lavr <andy.lavr@gmail.com>
Subject: RE: [PATCH 4.19 3/6] mwifiex: Remove unnecessary braces from
 HostCmd_SET_SEQ_NO_BSS_INFO
Thread-Topic: [PATCH 4.19 3/6] mwifiex: Remove unnecessary braces from
 HostCmd_SET_SEQ_NO_BSS_INFO
Thread-Index: AQHX9ZskhY8SD9NuYU2K0YFKH5iuIKw7ZcMg
Date:   Mon, 20 Dec 2021 14:00:40 +0000
Message-ID: <5797d1aff9034476afa6827af2bfbce7@AcuMS.aculab.com>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
         <20211217144119.2538175-4-anders.roxell@linaro.org>
 <bc4a4ba7c07a4077b9790be883fb4205d401804e.camel@perches.com>
In-Reply-To: <bc4a4ba7c07a4077b9790be883fb4205d401804e.camel@perches.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Perches
> Sent: 20 December 2021 12:13
> 
> On Fri, 2021-12-17 at 15:41 +0100, Anders Roxell wrote:
> > From: Nathan Chancellor <natechancellor@gmail.com>
> >
> > commit 6a953dc4dbd1c7057fb765a24f37a5e953c85fb0 upstream.
> >
> > A new warning in clang points out when macro expansion might result in a
> > GNU C statement expression. There is an instance of this in the mwifiex
> > driver:
> >
> > drivers/net/wireless/marvell/mwifiex/cmdevt.c:217:34: warning: '}' and
> > ')' tokens terminating statement expression appear in different macro
> > expansion contexts [-Wcompound-token-split-by-macro]
> >         host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
> >                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> []
> > diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
> []
> > @@ -512,10 +512,10 @@ enum mwifiex_channel_flags {
> >
> >  #define RF_ANTENNA_AUTO                 0xFFFF
> >
> > -#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) {   \
> > -	(((seq) & 0x00ff) |                             \
> > -	 (((num) & 0x000f) << 8)) |                     \
> > -	(((type) & 0x000f) << 12);                  }
> > +#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) \
> > +	((((seq) & 0x00ff) |                        \
> > +	 (((num) & 0x000f) << 8)) |                 \
> > +	(((type) & 0x000f) << 12))
> 
> Perhaps this would be better as a static inline
> 
> static inline u16 HostCmd_SET_SEQ_NO_BSS_INFO(u16 seq, u8 num, u8 type)
> {
> 	return (type & 0x000f) << 12 | (num & 0x000f) << 8 | (seq & 0x00ff);
> }

Just writing in on one line helps readability!
It is also used exactly twice, both with a cpu_to_le16().
I wonder how well the compiler handles that on BE?
The #define is more likely to be handled better.

I've only made a cursory glance at the code, but I get splitting
host_cmd->seq_num into two u8 fields would give better code!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

