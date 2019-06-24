Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8CA51967
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732369AbfFXRRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:17:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40500 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfFXRRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:17:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so7282404pla.7
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 10:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W5Gq+2eu7C9ykEOTkG4/e0ZCq1GlpToVxjnuUB6QS0E=;
        b=e+m3F1Wl/WpzEh7TSomGYCUUyLBG5VXN4NoOP2r5YXQqyGWXol9jVSa5pmO2T/cZSU
         paEaof8Tqq0P8ZksnX34rcXxeVOCqBJr9h8i8m8tXh9uwuAgeFIFwOOoGeidObCh761K
         zx3aXOAtCHkPBAsa/rQI3E3phwlZ8uNVZ/1Wm/kTjV4PeLPkT1waFQvNgfp38x06ovPU
         7ZtMLJBk9h/e2FO7F1xluvYWirqjH8hLVHh0uElRf9mmTxSPl8VjGsGPdDlyBl5ryA06
         7YnsNl2ZXQGZu6SZAIZB1xHaKmaHsGrdGCibxVrrhAYAZfJD3TizhI8tqczemyuMUGjw
         1m1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W5Gq+2eu7C9ykEOTkG4/e0ZCq1GlpToVxjnuUB6QS0E=;
        b=ntNBuslJ3kR1bDrBLUHCr/FRv3QvQZQZG2TTvSc6BKr4NPDimDz2fpY5V/lto3+OS3
         8GE4LrB+NhbDhJCm1wubjiqRWRJ03Gmiz/wTvONSOI3PvZoxL/wfGCHyaQ0m+L3zU9Pe
         QhcFbPt+RLW8M5tUja18wrENrEic9jOBZEeanSUYG9O7/B9zuiolmkXV2xT1S+8qZGdy
         axEg8tMbjtKAOE0CPnFvdzdXdBLQn1Z9jmmL5qqrilzKoRnFbyJz4hWONRK9vCwBu0KP
         bNFfAOyIsbLCvjrsHDZ4VUUDtSVE/CLtVdqd3FPMy9HQ0z8jHEyp+UKzf9SRicjdp3Mp
         bAYw==
X-Gm-Message-State: APjAAAVLxH1bhgltqtScBvOotu6eG/SPVmoGrbww3Ry8SGGWibyKwo+h
        o3ORBQnoCgJaliEzewP7yHF/c9kKm5XtR1iybGGSKQ==
X-Google-Smtp-Source: APXvYqzk3XgqisxGz6B4+5GibM3s9dZptD4wbuZSbb0l20gFK+wQJwpa1ekUEfro5xfkEGkWM6T1z3F6D+5Z2g9zMsM=
X-Received: by 2002:a17:902:4aa3:: with SMTP id x32mr26626062pld.119.1561396634970;
 Mon, 24 Jun 2019 10:17:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190624140109.14775-1-nicolas.dichtel@6wind.com>
 <20190624140109.14775-2-nicolas.dichtel@6wind.com> <CAKwvOdk9yxnO_2yDwuG8ECw2o8kP=w8pvdbCqDuwO4_03rj5gw@mail.gmail.com>
 <20190624.100609.1416082266723674267.davem@davemloft.net>
In-Reply-To: <20190624.100609.1416082266723674267.davem@davemloft.net>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 24 Jun 2019 10:17:03 -0700
Message-ID: <CAKwvOdmd2AooQrpPhBVhcRHGNsMoGFiXSyBA4_aBf7=oVeOx1g@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] ipv6: constify rt6_nexthop()
To:     David Miller <davem@davemloft.net>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netdev@vger.kernel.org, kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 10:06 AM David Miller <davem@davemloft.net> wrote:
>
> From: Nick Desaulniers <ndesaulniers@google.com>
> Date: Mon, 24 Jun 2019 09:45:14 -0700
>
> > https://groups.google.com/forum/#!searchin/clang-built-linux/const%7Csort:date/clang-built-linux/umkS84jS9m8/GAVVEgNYBgAJ
>
> Inaccessible...
>
>         This group either doesn't exist, or you don't have permission
>         to access it. If you're sure this group exists, contact the
>         Owner of the group and ask them to give you access.

Sorry, I set up the mailing list not too long ago, seem to have a long
tail of permissions related issues.  I confirmed that the link was
borked in an incognito window.  Via
https://support.google.com/a/answer/9325317#Visibility I was able to
change the obscure setting.  I now confirmed the above link works in
an incognito window.  Thanks for reporting; can you please triple
check?

>
> And you mean just changing to 'const' fixes something, how?

See the warning in the above link (assuming now you have access).
Assigning a non-const variable the result of a function call that
returns const discards the const qualifier.

-- 
Thanks,
~Nick Desaulniers
