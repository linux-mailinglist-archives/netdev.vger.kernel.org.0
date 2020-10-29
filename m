Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BE129E684
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgJ2Iim convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Oct 2020 04:38:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:27137 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728379AbgJ2IiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:38:10 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-247-dYC2eZsSM0WAyDgWmp-OkA-1; Thu, 29 Oct 2020 08:38:03 +0000
X-MC-Unique: dYC2eZsSM0WAyDgWmp-OkA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 29 Oct 2020 08:38:02 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 29 Oct 2020 08:38:02 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ard Biesheuvel' <ardb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Kees Cook" <keescook@chromium.org>
Subject: RE: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
Thread-Topic: [PATCH] bpf: don't rely on GCC __attribute__((optimize)) to
 disable GCSE
Thread-Index: AQHWrKPSU+gpkC9Xc0CadVq4xP4+/6muQ+gQ
Date:   Thu, 29 Oct 2020 08:38:02 +0000
Message-ID: <445378db7beb4d588b95709251eeb00b@AcuMS.aculab.com>
References: <20201027205723.12514-1-ardb@kernel.org>
In-Reply-To: <20201027205723.12514-1-ardb@kernel.org>
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

From: Ard Biesheuvel
> Sent: 27 October 2020 20:57
> 
> Commit 3193c0836f203 ("bpf: Disable GCC -fgcse optimization for
> ___bpf_prog_run()") introduced a __no_fgcse macro that expands to a
> function scope __attribute__((optimize("-fno-gcse"))), to disable a
> GCC specific optimization that was causing trouble on x86 builds, and
> was not expected to have any positive effect in the first place.

Surely it is possibly to 'adjust' the bpf code so that gcc doesn't
apply (and can't apply) the gcse optimisation?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

