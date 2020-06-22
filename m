Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F942039A3
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgFVOg3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 10:36:29 -0400
Received: from smtp.asem.it ([151.1.184.197]:57670 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728504AbgFVOg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 10:36:29 -0400
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000333556.MSG 
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:36:27 +0200S
Received: from ASAS044.asem.intra (172.16.16.44) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 22
 Jun 2020 16:36:26 +0200
Received: from ASAS044.asem.intra ([::1]) by ASAS044.asem.intra ([::1]) with
 mapi id 15.01.1979.003; Mon, 22 Jun 2020 16:36:26 +0200
From:   Flavio Suligoi <f.suligoi@asem.it>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] net: wireless: intersil: orinoco: fix spelling
 mistake
Thread-Topic: [PATCH 1/1] net: wireless: intersil: orinoco: fix spelling
 mistake
Thread-Index: AQHWRhxa5hLd24UfYkmM6jKYq99qSqjks8fwgAAEedA=
Date:   Mon, 22 Jun 2020 14:36:25 +0000
Message-ID: <572cf2c6607e4be88c429db11ed4b29b@asem.it>
References: <20200619093102.29487-1-f.suligoi@asem.it>
 <87wo3zfale.fsf@codeaurora.org>
In-Reply-To: <87wo3zfale.fsf@codeaurora.org>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.17.208]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A090214.5EF0C1EA.0075,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

> 
> Flavio Suligoi <f.suligoi@asem.it> writes:
> 
> > Fix typo: "EZUSB_REQUEST_TRIGER" --> "EZUSB_REQUEST_TRIGGER"
> >
> > Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
> > ---
> >  drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> The prefix should be "orinoco_usb: ", but I can fix that.

ok, thank you!

Flavio

> 
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpat
> ches
