Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CA74BA1F1
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbiBQNwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 08:52:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbiBQNwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:52:04 -0500
X-Greylist: delayed 138581 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 05:51:46 PST
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9F31A387;
        Thu, 17 Feb 2022 05:51:44 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1645105901; bh=vtJ6U8H7nf3bTf7eNzjna2o/X7u+gytF1V+R6i74hn8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=sNltC89a/8RgZoYCPq45gmft5SXH2RDT4MMxSnToGu5w0wZ3rFSjLJ+3/XYGt0BOi
         7HqGBkzAwcS52jWtl6bOrd11vwFxrD1ZnrZYg67rHkSGMPO0ASD0SF2i9wMxXKdpsj
         Qk98Ofq6B1MPZ+S0V3oMTjnUKeD5ExImx2thvqUyc//DxZDu1H6lYJwMzBuBXXaKbz
         VVTpdjRqDMwqCF2RQoyoSG06w2UIZjIzMNY/Pb3Bom087Ommd1zwM9Gw34t6/Fnv+g
         dd6LH2A8oCefGkHN1KZMSdZ3I1SWkEBWLAiQRJSODBsO4r6s3ahA86OrP6LtTjAlP6
         ZhZIpSZNydnkQ==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, miaoqing@codeaurora.org,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3] ath9k: use hw_random API instead of directly dumping
 into random.c
In-Reply-To: <20220216113323.53332-1-Jason@zx2c4.com>
References: <CAHmME9rkDXbeNbe1uehoVONioy=pa8oBtJEW22Afbp=86A9SUQ@mail.gmail.com>
 <20220216113323.53332-1-Jason@zx2c4.com>
Date:   Thu, 17 Feb 2022 14:51:41 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87y22938k2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hardware random number generators are supposed to use the hw_random
> framework. This commit turns ath9k's kthread-based design into a proper
> hw_random driver.
>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Alright, LGTM. Thank you for the patch!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
