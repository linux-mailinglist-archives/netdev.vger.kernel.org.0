Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC271BB2E5
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgD1A1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726016AbgD1A1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 20:27:00 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98677C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 17:26:58 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id t8so19559672uap.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 17:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aVm1gpcpFStUCDT+oKx9coiaG2gmHKxfnSyXwD+SiSQ=;
        b=a4hslxXuL4ce61msEBElNdxikXyDLQs7aDv/kdiO2ux4/wiZ51BLcbqNKYFRdB6PZA
         EVbRnRyy0J7VlBFMIV+C3VAmF4MavBSEfir6Wzk5eiB7APVTY2CtmdYdgfNtM/PdOBY7
         6kx7bbRF6kZK3mumQIngza1fVbweWU8irlzhoabuGNHNK6nIOFTXdFhMiQuE+CxEwNey
         4xybzZUeWQw1dZM3AsunF1EpKhN9mPBCfx7E1TAfD0IFkO/CLSAO6IgL4L5mqvEd4N7X
         3Cb6+2x4vvB+u8df43BGjFAldnmMluqrvW5dOf5bnsxbDQSdiEYODbcZF7eu6CIbsKQo
         kVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aVm1gpcpFStUCDT+oKx9coiaG2gmHKxfnSyXwD+SiSQ=;
        b=UxmLNedOZrVPTW594wil13fowGt9PZhS2WjibQcjnwaWG3X9cG3of7rE35FEVsPC3d
         mVUkMv7c3BH2xXqsrHuzRPuh4hYg4D4bWipadOfHXPXWeCisojoTLAbCxpDVYjlEGERi
         CYx6CshbHee2MEKkXI/8qEbRRKjOgLLSJoVnv2/9dq74NLuHrxwiDddEe9YHBKDr5cNo
         FNdksVq8EEbhtgoCdpi1q7xu9jPkQSaQ3/5DpYdz0g+maBkeMae2jpb+BA2/HjSi1cNE
         9q0K4KBJP9Rhvbbg2w2BIZdnCzzQXS93k23GPExnCGGy6AikaWKKr1dZo0TPsI3gksAI
         +LFQ==
X-Gm-Message-State: AGi0Pubme5difti6BZxqx+mfnZGqkflHMdhjvA/RvbL46CxcTvpKzXK7
        AHaYdDBINKcVPOFFc3XADmnMBCXmrfpENnDjgg2efGZuD/4=
X-Google-Smtp-Source: APiQypL+lHJ1K3hpOM0nwpSINXljZgoVMSpJUBp8tOJXvqTx3PtuUHGBvcqbTIp3cD15BJfxix5QVFwPhhqVlsF61cc=
X-Received: by 2002:ab0:4162:: with SMTP id j89mr19390916uad.23.1588033617357;
 Mon, 27 Apr 2020 17:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081549.108375-1-zenczykowski@gmail.com> <20200428000640.GE24002@salvia>
In-Reply-To: <20200428000640.GE24002@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 27 Apr 2020 17:26:44 -0700
Message-ID: <CANP3RGewkX54pqZtironHRCrEYdMF2FZLdKzJz=4GU2CgC=1Mg@mail.gmail.com>
Subject: Re: [PATCH] do not typedef socklen_t on Android
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't know all that much about it.  Mostly it just seems to work.

I'm quoting from: https://en.wikipedia.org/wiki/Bionic_(software) ;-)

Bionic is basically a BSD licensed C library for use with Linux.
This differs from other BSD C libraries which require a BSD kernel,
and from the GNU C Library (glibc) which uses the GNU Lesser General
Public License.

For the most part it's supposed to be drop-in compatible I think,
and the kernel headers (uapi) come from some recent version of Linux.

The license and smaller size are AFAIK the main benefits.

---

Got me curious and:

I'm not actually sure what defines __ANDROID__, maybe __BIONIC__ would
be a better guard?

That seems to be defined in bionic/libc/include/sys/cdefs.h

https://android.googlesource.com/platform/bionic/+/master/libc/include/sys/cdefs.h#43

And the docs here:

https://android.googlesource.com/platform/bionic/+/master/docs/defines.md

do seem to suggest that __BIONIC__ is more equivalent to __GLIBC__
