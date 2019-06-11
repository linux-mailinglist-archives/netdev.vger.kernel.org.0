Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725013D6CA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404926AbfFKT2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:28:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34636 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404335AbfFKT2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:28:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id p10so1662691pgn.1
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Gqu7ufAp/RSuYdkQrxRWcURv0D9D3LGELTCgEHasOY=;
        b=rYoG/cbPEy8f922Zw2P3KHMRMS5yBgEZnp+ggFiq3VXUwKpnHtoTF7uygPLMgQrldF
         Yi9DFbmB3G8q5Rq2Ioo5FEjc6YZm9F8Knk8NRiS+trndCvcRZUieQV3CeHLry7LK+d/e
         Vs7q0b6unQJKCDbG7OnJAY1/StiUAv3zeW5U2LnQU027Tp0YDX1D4V9ECyAavHN5GTYx
         Lhx1L/pEm8NFjPLPoL81ZgNuIc4ZIs5s+0iaRHeKHCNnlIDeay7MVirz1EcYi7x/xOb4
         PCPhUU4eLvSyfFNv9/Vedc/cDIwpBkhjPsH3AKlXfwwhgXNjDf7zPMJDEjIrxzOGNekh
         nTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Gqu7ufAp/RSuYdkQrxRWcURv0D9D3LGELTCgEHasOY=;
        b=qqqFFnTrzPXivgrjVHzCTQkgWd5FHbD8ao5vvE5mT3k0S0zm3iUzKtNNZ6wQAUC8Oc
         6kt+6V80mzQ9z+RK0Vgf/qrcJ4ZdDmSOPFIhLJ0ODKUMKoIJLUQRGsPKhNkq7gbUEi29
         y7BmZq0+HVXkVhSXgXA4rUS15rVHyjQuBryINr+3faWNvqwmUR2h7LOCmN0I9O1WDGHt
         aCn+DyoZSzzIei4i6dN66q6OsDfPz1YJ21eMG1n8RMLEY9dRwD575ln38oBMbIZ41Vvp
         820miNTkER+1EACsnv5etyOOd9ujb7JiRDeMRV/yC0nhud5WhAwSgfqSIJKyqPZGHE2b
         OJIQ==
X-Gm-Message-State: APjAAAVt9vKLZPU5rD96GDTkKrxOd3XD4i9i5Xk8+xzimENVnRYcAfbo
        6w2QwrrUd7f9M+/B8NULWA+P4urgONc=
X-Google-Smtp-Source: APXvYqzOVT/RDZeOh/aRanWtVrERe9LqZidcHpQeu3BDxcEjTnk3BKnUgqsQEuD+eVgEJT6VArDx7w==
X-Received: by 2002:a63:8dc4:: with SMTP id z187mr21888215pgd.337.1560281287403;
        Tue, 11 Jun 2019 12:28:07 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s1sm3498255pfm.187.2019.06.11.12.28.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 12:28:07 -0700 (PDT)
Date:   Tue, 11 Jun 2019 12:28:00 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next] Makefile: pass -pipe to the compiler
Message-ID: <20190611122800.56d72eba@hermes.lan>
In-Reply-To: <20190611180513.30772-1-mcroce@redhat.com>
References: <20190611180513.30772-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 20:05:13 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> Pass the -pipe option to GCC, to use pipes instead of temp files.
> On a slow AMD G-T40E CPU we get a non negligible 6% improvement
> in build time.
> 
> real    1m15,111s
> user    1m2,521s
> sys     0m12,465s
> 
> real    1m10,861s
> user    1m2,520s
> sys     0m12,901s
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Why bother, on my machine (make -j12).

Before
real	0m6.320s
user	0m30.674s
sys	0m3.649s


After (with -pipe)
real	0m6.158s
user	0m31.197s
sys	0m3.532s


So it is slower. Get a faster disk :-)

Maybe allow "EXTRA_CFLAGS" to be passed to Makefile for those that
have a burning need for this.
