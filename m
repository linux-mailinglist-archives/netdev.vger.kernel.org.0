Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2313B9BFA
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 04:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfIUCVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 22:21:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34217 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730788AbfIUCVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 22:21:37 -0400
Received: by mail-qt1-f193.google.com with SMTP id 3so8454321qta.1
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 19:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bFbiKfS/DqaAsFUoNm9oxB524RJPQVaal3R43p6A+Jo=;
        b=Z4g7nx+XeM+HScPbv0MfjMvDFN1zEOKYV7+7BDh0nOOz6RzkYms9C1tEDIDUkyXOU0
         3d05uWRm8BolrKccT2/2WwKGPNqQyftgFNZwMu1mVK7bqrT0kWZYteF9rtiZJ7Cz/S7o
         l8xgG2ZpBIBVuNdFflyNnzcawTu3Jrt5B0H8XsjMQxvTbMzoi3OEc7DrgC/XLNsEjF0k
         IJ7GewNtZfgjR/zDyLQzVJr360MMh1j6EX76rmPOeqlKGFMZvKJl5VTBgeMlClNdeh0r
         iUPJNY3MwI5ZPigl83D5QaAUkeMswQuZnTNgLUb0D0PogRDoipep+xgcVY93An0e54X3
         kGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bFbiKfS/DqaAsFUoNm9oxB524RJPQVaal3R43p6A+Jo=;
        b=Jb6njvMEC+B5Qjb5KGSWBX/TmTLyhLM4vlaHO+/JTy7VCNtrRVPmECZuv4jcryEZmq
         L87ZJclZtGt5Pb5yjkYtElpLgS8QVBGlhU6dU5STSQQ/8CxPEfUv17sK339d9n20dHNj
         xfpmTYjfBRf9CX25py4KQkbgHraTJGCxDyNr4/e8+YjtKUJQX/xgz4g6VoDCntPzV1Ho
         /uW6NFhie/xJvy96ko1boOBqn9FPkz4T9GJ1RZ5hkjOu0NKbWceAJH2RtKMnsFCKhmps
         3KsOn6zYx9Llr50s4v0RJ3577o3+41+LeVbmLNAtuw+3CaBZUek1cFD7D6AJ9TcvaQSI
         fvmg==
X-Gm-Message-State: APjAAAX8cbHd4bKJEHxDnol74DDU/BFmu3Jj5H1PW+jJ2iHrChpLNxWm
        lRLAvN2upb/roX3v26eyZ1vajA==
X-Google-Smtp-Source: APXvYqy8s9iGZFIG60whj6RaV2SoI/YhcQtItgW5sPCuij5JKWoev5ONBZxK7i344iDxcvfjsUYIXw==
X-Received: by 2002:ac8:4702:: with SMTP id f2mr6602205qtp.134.1569032496796;
        Fri, 20 Sep 2019 19:21:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c20sm1661550qkm.11.2019.09.20.19.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 19:21:36 -0700 (PDT)
Date:   Fri, 20 Sep 2019 19:21:33 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wei Wang <weiwan@google.com>, Yi Ren <c4tren@gmail.com>
Subject: Re: [PATCH net] ipv6: fix a typo in fib6_rule_lookup()
Message-ID: <20190920192133.4212962d@cakuba.netronome.com>
In-Reply-To: <20190919171236.111294-1-edumazet@google.com>
References: <20190919171236.111294-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Sep 2019 10:12:36 -0700, Eric Dumazet wrote:
> Yi Ren reported an issue discovered by syzkaller, and bisected
> to the cited commit.
> 
> Many thanks to Yi, this trivial patch does not reflect the patient
> work that has been done.
> 
> Fixes: d64a1f574a29 ("ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Wei Wang <weiwan@google.com>
> Bisected-and-Reported-by: Yi Ren <c4tren@gmail.com>

Apparently:

WARNING: 'Bisected-and-reported-by:' is the preferred signature form
#15: 
Bisected-and-Reported-by: Yi Ren <c4tren@gmail.com>

total: 0 errors, 1 warnings, 0 checks, 8 lines checked

So I lower-cased that R, hope that's okay. 

Applied, queued, thank you!
