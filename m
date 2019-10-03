Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15ECAD03
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbfJCRdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:33:44 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:43880 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730857AbfJCRdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:33:43 -0400
Received: by mail-io1-f53.google.com with SMTP id v2so7412091iob.10;
        Thu, 03 Oct 2019 10:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ONd5a/FfV7jhRPv/CKX17jAmVEE2xnEfML1eXwf+mLI=;
        b=RlDkfjCUyEaNWkAPUO4JplYVcNBlZNodh06k0HSYd10r5rKdYg3Ubq2kgrNgK4FOQ1
         OUp5HdC90acm/P1B8B7YrY7LEdSCXE7D9EgBqRw9dGH1Ym5PcRcUvGe9SLxBF3cCHTz/
         GYtZPO/fwRpkzKyPejlEu3toOXCxRa74A12wxT/01uTWAlDOVv4r1w1B/xzMZbGA9twH
         I3yLLF+fiDsaNK2CTma5OFFuT3kfcpICCSsSi7iif510tsicMnrpbQWyfdrkD3BeSswz
         25/1EsLPBt9BRg+7MeSu9u9eguX7kLQ/6KG1dquoTcjSqHi5YsqQEzwZ0FusTqCuQqFr
         FKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ONd5a/FfV7jhRPv/CKX17jAmVEE2xnEfML1eXwf+mLI=;
        b=cj/OJomLezOhOd9B3+WxFP78PczIdADtWMXtg0e0Du2ZR+6e/qc5hJ1Tarn8Eh//t4
         OicJHFw/rGMNZqbtU/zQLPIdUCkPV9EqIpaAT5+gPhRkAJRrzmYefhRDGkuf9LyG2jo3
         17vNX8uH2UskUGwUnvwPi1UIQy8tlTWGV1wy1Y0CRT54eMUfv+2fSVRVYkFVKTysI9Xk
         CbmWDfO3qOZC0KLd5FMFJGBp6HqNWGA7pebzfvicYUCd5uJk8uPtZ6BFMKQNNczRDY4f
         o8JKqnVWuhGYNe8hYNN8MIXE8GDiG71pMNCZrMYBc9y53N5GXyrRUqNeIYy7NFf7keNa
         giIg==
X-Gm-Message-State: APjAAAUO8Syt+QxkrI+o7aOt+4trQ5FC38QfU//DcVaFV71R4WEM7sdF
        5t1wdPqF1V543Q51iGjGrCA=
X-Google-Smtp-Source: APXvYqwPy36xtQfrFgoR60FRbdPzCnXu9mYMKBufjqU8f4SvpkIR1JAsfWaaFr3AISB5LaJx9B5MhQ==
X-Received: by 2002:a5e:8f01:: with SMTP id c1mr8936623iok.148.1570124022003;
        Thu, 03 Oct 2019 10:33:42 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l3sm1073597ioj.7.2019.10.03.10.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 10:33:41 -0700 (PDT)
Date:   Thu, 03 Oct 2019 10:33:34 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d9630ee7f2c2_55732aec43fe05c45e@john-XPS-13-9370.notmuch>
In-Reply-To: <20191002215041.1083058-5-andriin@fb.com>
References: <20191002215041.1083058-1-andriin@fb.com>
 <20191002215041.1083058-5-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 4/7] selftests/bpf: split off tracing-only
 helpers into bpf_tracing.h
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Split-off PT_REGS-related helpers into bpf_tracing.h header. Adjust
> selftests and samples to include it where necessary.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
