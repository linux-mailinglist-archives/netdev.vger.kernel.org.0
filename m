Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0687A48D0DA
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 04:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiAMDYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 22:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiAMDYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 22:24:24 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC9EC06173F;
        Wed, 12 Jan 2022 19:24:24 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id ay4-20020a05600c1e0400b0034a81a94607so1889752wmb.1;
        Wed, 12 Jan 2022 19:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JSMd2i1J9AcZD7Z3Rw6ULKwjTXX7SBdExO4O6TrXQeM=;
        b=Nwx5hbt1nqbJLYEqQOrmek2+mHZHSkkaw2ys4lY0uxDxDe/urrP4UEXfjJhaRsaDas
         GbeUqwGlKLASaZaSCBa7JO6rkMIowlCaAmEo8S0bk1MdguYwNRtcDrkcHrS6m67UA/Ny
         RZ4AY69E254yQ7FtXIj8wJFDI/WNNTkHd1mgaSmCCipBs0I7XIEjZajBmemZE+BlPFUi
         OJiVlWRySfQvEg+VNiYRcBNaKy/wHTs3qqqvVxoy1Pz7VomzpxJraiM7iIBawTxlu+UW
         z5Hj1H5US9JFV+qVD/HpK4dfrM0CzF+lUgideijb+F8IAGcmqR3X8a+STShjikVc5Gp1
         uKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JSMd2i1J9AcZD7Z3Rw6ULKwjTXX7SBdExO4O6TrXQeM=;
        b=lYsXWlW2HV4ymDzqrNX3QKeaTp+jZRAiGamYLoft+n17q7HTLPUpz8V+Ro6tGxQS+X
         isRCrXF/MLY6qC7S4FpXVqAA6FAZhN4Tr9J5SGQb1HHx3KJei4Kt61iXv0rhsZDEiVQ3
         w8CiryFEosV6I46cL947FG5ZBEtJ9+dp9RQFvDejpJr1dosxXjcLnitAgEzRtOaNF27N
         YVoWpGTIzjrEPa2QVUQT5FeTZSpUuY6rPwfc+2nqUS1A9MqXt1mb8NSCEPAYVA7Ub4Wv
         QZYjbLHkT5zFw63vTyROfxXCXlVJFi10/HmSv5iCKQSaEd4cqRx+c30iytmeqVuEfFe9
         AZuw==
X-Gm-Message-State: AOAM5322IiApIGW6ZnDm3yCguIfK78VX28kBRswAnbDWCESxxaAQlzun
        cEt0MlFgVuViB8KGOOdqpnWR0ISFTCXfOFgybf55/0JL
X-Google-Smtp-Source: ABdhPJwTXGUKA7wZhgTc8YR5+JDazq/sLt8QMWaphJFMMz7CT5KV5ic+NPT04Hi1TDCOp0a7ipRt5he1vz1bXcp48xA=
X-Received: by 2002:a1c:7316:: with SMTP id d22mr9220707wmb.5.1642044262824;
 Wed, 12 Jan 2022 19:24:22 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com>
In-Reply-To: <20220112131204.800307-1-Jason@zx2c4.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 13 Jan 2022 11:24:10 +0800
Message-ID: <CACXcFmkauHRkTdD1zkr9QRCwG-uD8=7q9=Wk0_VFueRy-Oy+Nw@mail.gmail.com>
Subject: Re: [PATCH RFC v1 0/3] remove remaining users of SHA-1
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> There are currently two remaining users of SHA-1 left in the kernel: bpf
> tag generation, and ipv6 address calculation.

I think there are three, since drivers/char/random.c also uses it.
Moreover, there's some inefficiency there (or was last time I
looked) since it produces a 160-bit hash then folds it in half
to give an 80-bit output.

A possible fix would be to use a more modern 512-bit hash.
SHA3 would be the obvious one, but Blake2 would work,
Blake3 might be faster & there are several other possibilities.
Hash context size would then match ChaCha so you could
update the whole CC context at once, maybe even use the
same context for both.

That approach has difficulties, Extracting 512 bits every
time might drain the input pool too quickly & it is overkill
for ChaCha which should be secure with smaller rekeyings.

If you look at IPsec, SSL & other such protocols, many
have now mostly replaced the hash-based HMAC
constructions used in previous generations with things
like Galois field calculations (e.g. AES-GCM) or other
strange math (e,g. poly 1305). These have most of the
desirable properties of hashes & are much faster. As
far as I know, they all give 128-bit outputs.

I think we should replace SHA-1 with GCM. Give
ChaCha 128 bits somewhat more often than current
code gives it 256.
