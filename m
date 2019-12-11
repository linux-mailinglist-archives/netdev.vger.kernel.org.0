Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33FC11AA7A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfLKMH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:07:57 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:59875 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbfLKMH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 07:07:57 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6985870e;
        Wed, 11 Dec 2019 11:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=C9FwO9B7K+es48HT2oaJ5pAFwII=; b=mlqewS
        8jCyNq7cpTXkGZmMD7fBCfMzJuJXaSq0+/BxmgynD9T+UwKqxXM0+vL/H2CkverN
        zx/RCPlsb65oAd8QNz2Fd/+KyqfRjb685Khb7tZbl8E7VMRAt/ryvC4Pv0bUmFdO
        CDfkyRHedn9KKcBX0e+askiuAdlsHfAERXcQxFSXrn3JN7g80q6pmZ4b/SzDYPkL
        MPDLHt4puauKs+SZ6GPYX8/8X1TmHuTI4MU2W02dFKcY7Sp0awK3KFArO8fKAYRu
        sGr0NKe+8k5F5HkHjjkYj6/3hHL2MWEBQN83ObIOoVYATz391UiaUn3YbEpnuoDg
        MbDXPmQsmSZj/dzw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e42bde5c (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 11 Dec 2019 11:12:15 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id i4so18578358otr.3;
        Wed, 11 Dec 2019 04:07:54 -0800 (PST)
X-Gm-Message-State: APjAAAUQze3M7QyH2C6FTA0iadraBGucCf1Hky2tOV0f4kH4/WpbtOHq
        9pHpgHjlgmbK24GOMPuYCE+JrkObil0Wc0ZP87c=
X-Google-Smtp-Source: APXvYqwe0utfbrRMFWhDsp03hIAgIDRCrndnTnAEWTs1Updy6jeM7OtmSLWXLN2ZN7Fx5sXoEWT/x59M2l/SxJHTvzY=
X-Received: by 2002:a9d:4f0f:: with SMTP id d15mr2064176otl.179.1576066074187;
 Wed, 11 Dec 2019 04:07:54 -0800 (PST)
MIME-Version: 1.0
References: <20191211102455.7b55218e@canb.auug.org.au> <20191211092640.107621-1-Jason@zx2c4.com>
 <CAKv+Gu80vONMAuv=2OpSOuZHvVv22quRxeNtbxnSkFBz_DvfbQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu80vONMAuv=2OpSOuZHvVv22quRxeNtbxnSkFBz_DvfbQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 11 Dec 2019 13:07:43 +0100
X-Gmail-Original-Message-ID: <CAHmME9r09=YNw1MmnzoRLA4szJ9zz-uV4Hut4dFZKHDwG8Qp6A@mail.gmail.com>
Message-ID: <CAHmME9r09=YNw1MmnzoRLA4szJ9zz-uV4Hut4dFZKHDwG8Qp6A@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: arm/curve25519 - add arch-specific key
 generation function
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 10:38 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> > The x86_64 glue has a specific key
> > generation implementation, but the Arm one does not. However, it can
> > still receive the NEON speedups by calling the ordinary DH function
> > using the base point.
> >
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> With the first sentence dropped,
>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Herbert - can you pick this up for 5.5-rc2 rather than 5.6?
