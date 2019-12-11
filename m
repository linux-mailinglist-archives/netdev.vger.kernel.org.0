Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF1C11A796
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfLKJki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:40:38 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:59015 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfLKJki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 04:40:38 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6ae89909;
        Wed, 11 Dec 2019 08:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=xCs05TVRd20sagcCLkJLr7Ih37Y=; b=iCxOAa
        iDv129m8Pn9KewJ2XmScYZ7fUy2vbMJu85DiSN4VanCgVlzLklf3YUtdQrXETtQM
        iofplR/118knt+uulhH5SYhiaF8wiDHL8jNT+hNm8z8lp25uuZ9n/oh4MKusqagM
        lrZDiKPn8ZJ8HNoq97LzwizHY7xGNJ5bUj3tDAdAfA+JmfYAoRkAKzRwaCdFz7zd
        Waa6lTBGEDpNy5m0Hoj0Ca+wcrKmU5E0PUdEOB+sLgCmhklQLbP432pf6v1OtNlU
        onXOFcx1c0WIG0XZ/lF6f0nj7JUrXZR7N8TJW1hcV1BcdZMGxz2FSPzI+bArjGjg
        xTRqIr5Y7flqQVYQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9840ad46 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 11 Dec 2019 08:44:57 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id j22so12646683oij.9;
        Wed, 11 Dec 2019 01:40:35 -0800 (PST)
X-Gm-Message-State: APjAAAXuB9SHdVgwDIaoVyjX7snR+KiU8BBT5QpUZ+qLSvFHET52jVPh
        7/bHItf9K/f6Bmm5s9ru+grrhvkNRdXIZHH3cVg=
X-Google-Smtp-Source: APXvYqyLJolOM0pHmwpzZS4VS9SY01PLdWWlmZdvztdc3o611Q1dZsTEnTnG0YXEt12x7rVC1jDonmBqZl+bwmlLlnA=
X-Received: by 2002:a05:6808:4cc:: with SMTP id a12mr2090157oie.115.1576057234890;
 Wed, 11 Dec 2019 01:40:34 -0800 (PST)
MIME-Version: 1.0
References: <20191211102455.7b55218e@canb.auug.org.au> <20191211092640.107621-1-Jason@zx2c4.com>
 <CAKv+Gu80vONMAuv=2OpSOuZHvVv22quRxeNtbxnSkFBz_DvfbQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu80vONMAuv=2OpSOuZHvVv22quRxeNtbxnSkFBz_DvfbQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 11 Dec 2019 10:40:23 +0100
X-Gmail-Original-Message-ID: <CAHmME9og1LP8J3w-Uqa+i9VvyXA=N80HrgFnvQ6Gs2kh_80NYA@mail.gmail.com>
Message-ID: <CAHmME9og1LP8J3w-Uqa+i9VvyXA=N80HrgFnvQ6Gs2kh_80NYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: arm/curve25519 - add arch-specific key
 generation function
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 10:38 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 11 Dec 2019 at 10:27, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Somehow this was forgotten when Zinc was being split into oddly shaped
> > pieces, resulting in linker errors.
>
> Zinc has no historical significance here

Wow...
