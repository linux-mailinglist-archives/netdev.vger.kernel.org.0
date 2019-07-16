Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFC26B026
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388366AbfGPTzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:55:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33135 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbfGPTzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:55:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id f20so721945pgj.0
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 12:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d1Azkzib+8xqVPZDnLUrm8VJ9XsxX7J/EJPH6cpkkiQ=;
        b=i8u0mJZ3MHHlIeEPYVqmIDXnyJUJDAuVU+IND305z0YyuzpuhVC9f3TSWMmFA6F8qQ
         1sQnH87W0LKTtVmUyzGq73KF4FmF0JAVun1FDoTjVye/vQxJT4ZbYeSKQzFjw9HbfchC
         iJUI0J8lELYarHgp390HWcCEd4VphNqRoVGDgdpuyZvos7OX+a0KmAeAJ/lAG4aXtfSf
         W+/cbYZiTf717s+hxbZGnSGVSMIZdgP4Uj92PplslEdqFJdOP52Y09u3oxaj/OgaShS4
         1o1CcFz5qg2nDghPRg9YgQgovT/AHCTjYrfh2+vldPrWxaKCh+UqUrti9yd7fHRcwTaR
         v9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d1Azkzib+8xqVPZDnLUrm8VJ9XsxX7J/EJPH6cpkkiQ=;
        b=jVnKcfaMmEHq7NdRhrDyu4f1WDcNm/06Q3ppYyIIz+rw9o18h0gkMTXvEx7u1UBuni
         iqbYLlIpkDjCg8yUsMO4DmQYrTdCYy5HRXq9haMTLNGgCBRHMLOWjFP0qB1lVXAeQQwU
         wzK9lHY0V/QzqCYpfDLxGxPlzmBvEtbYfH7BQjmXhGOPhWHwbjEjQpWmeSOiN9ANqZeD
         UzIILm82VwysfgBLo7EGZ8gPb28DnUBRH8aLG+4RtmTExBocr6rgmTJs+60G/q3xVFD0
         NyHsV40iLlPDnHVj9P621hEQjmr49uzbuNhhPXXPNnERi4baMFC02b1OLG60qRMjSgZT
         TasA==
X-Gm-Message-State: APjAAAU25d7NuPf71DnX+auDQqe1ObzVoeQJMw6utzv8rTocJsP31CGx
        qpwRfnwVdokBwIyouR7RCno=
X-Google-Smtp-Source: APXvYqzirQAAitbL7qs3tIm4MUCn3DWG9qDpP7wIIEXcZYovXa8t0DHyUTIPyePKS91fq+MseucnFQ==
X-Received: by 2002:a63:7e17:: with SMTP id z23mr36608368pgc.14.1563306945971;
        Tue, 16 Jul 2019 12:55:45 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id x22sm26357830pff.5.2019.07.16.12.55.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 12:55:44 -0700 (PDT)
Date:   Tue, 16 Jul 2019 12:55:44 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@fb.com, andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf 1/2] selftests/bpf: fix test_verifier/test_maps make
 dependencies
Message-ID: <20190716195544.GB14834@mini-arch>
References: <20190716193837.2808971-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716193837.2808971-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/16, Andrii Nakryiko wrote:
> e46fc22e60a4 ("selftests/bpf: make directory prerequisites order-only")
> exposed existing problem in Makefile for test_verifier and test_maps tests:
> their dependency on auto-generated header file with a list of all tests wasn't
> recorded explicitly. This patch fixes these issues.
Why adding it explicitly fixes it? At least for test_verifier, we have
the following rule:

	test_verifier.c: $(VERIFIER_TESTS_H)

And there should be implicit/builtin test_verifier -> test_verifier.c
dependency rule.

Same for maps, I guess:

	$(OUTPUT)/test_maps: map_tests/*.c
	test_maps.c: $(MAP_TESTS_H)

So why is it not working as is? What I'm I missing?
