Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8598934E284
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhC3Hr1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Mar 2021 03:47:27 -0400
Received: from smtp.asem.it ([151.1.184.197]:55359 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhC3HrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 03:47:03 -0400
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 8.0.0)
        with ESMTP id 51a052f4689e4bc4872633dfdfda5d7a.MSG
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 09:47:01 +0200S
Received: from ASAS044.asem.intra (172.16.16.44) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 30
 Mar 2021 09:46:58 +0200
Received: from ASAS044.asem.intra ([::1]) by ASAS044.asem.intra ([::1]) with
 mapi id 15.01.2176.009; Tue, 30 Mar 2021 09:46:58 +0200
From:   Flavio Suligoi <f.suligoi@asem.it>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Thread-Topic: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Thread-Index: AQHXIZ1I+hIGDbheQ0mjeo1QOr5hoqqa90yAgAE1elA=
Date:   Tue, 30 Mar 2021 07:46:58 +0000
Message-ID: <92353220370542c7acdabbd269269d80@asem.it>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
 <YGHuhbe/+9cjPdFH@smile.fi.intel.com>
In-Reply-To: <YGHuhbe/+9cjPdFH@smile.fi.intel.com>
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
X-SGOP-RefID: str=0001.0A782F25.6062D773.0040,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,
...
> On Thu, Mar 25, 2021 at 07:34:07PM +0200, Andy Shevchenko wrote:
> > The series provides one fix (patch 1) for GPIO to be able to wait for
> > the GPIO driver to appear. This is separated from the conversion to
> > the GPIO descriptors (patch 2) in order to have a possibility for
> > backporting. Patches 3 and 4 fix a minor warnings from Sparse while
> > moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.
> >
> > Tested on Intel Minnowboard (v1).
> 
> Anything should I do here?

it's ok for me

> --
> With Best Regards,
> Andy Shevchenko
> 

Best regards,
Flavio Suligoi
