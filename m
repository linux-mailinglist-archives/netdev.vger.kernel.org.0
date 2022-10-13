Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054F65FD88E
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiJMLlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 07:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJMLk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 07:40:57 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DE6B4887
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 04:40:54 -0700 (PDT)
Received: (qmail 12515 invoked from network); 13 Oct 2022 11:40:25 -0000
Received: from p200300cf070ada0076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70a:da00:76d4:35ff:feb7:be92]:49034 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <fw@strlen.de>; Thu, 13 Oct 2022 13:40:25 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Graf <tgraf@suug.ch>, kasan-dev@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-um@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        loongarch@lists.linux.dev, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v6 5/7] treewide: use get_random_u32() when possible
Date:   Thu, 13 Oct 2022 13:40:40 +0200
Message-ID: <11986571.xaOnivgMc4@eto.sf-tec.de>
In-Reply-To: <20221013101635.GB11818@breakpoint.cc>
References: <20221010230613.1076905-1-Jason@zx2c4.com> <3026360.ZldQQBzMgz@eto.sf-tec.de> <20221013101635.GB11818@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart22512332.f9tG50R4rC"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart22512332.f9tG50R4rC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Florian Westphal <fw@strlen.de>
Date: Thu, 13 Oct 2022 13:40:40 +0200
Message-ID: <11986571.xaOnivgMc4@eto.sf-tec.de>
In-Reply-To: <20221013101635.GB11818@breakpoint.cc>
MIME-Version: 1.0

Am Donnerstag, 13. Oktober 2022, 12:16:35 CEST schrieb Florian Westphal:
> Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> > Florian, can you comment and maybe fix it?
> 
> Can't comment, do not remember -- this was 5 years ago.
> 
> > Or you wanted to move the variable before the loop and keep the random
> > state between the loops and only reseed when all '1' bits have been
> > consumed.
> Probably.  No clue, best to NOT change it to not block Jasons series and
> then just simplify this and remove all the useless shifts.

Sure. Jason, just in case you are going to do a v7 this could move to u8 then.

--nextPart22512332.f9tG50R4rC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCY0f5OAAKCRBcpIk+abn8
TncNAKCia3h4AG/9IzqybWbLcwE6uVgTqACfRr3dPUK8JMrKIqGzYOiL96isZhg=
=zppL
-----END PGP SIGNATURE-----

--nextPart22512332.f9tG50R4rC--



