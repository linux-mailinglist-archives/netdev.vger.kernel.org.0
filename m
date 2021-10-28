Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE243EA0B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 23:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhJ1VO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 17:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhJ1VO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 17:14:57 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69992C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 14:12:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b1so3631762pfm.6
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 14:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0854AbNyTTGcn64aYwlT4ZlWQD+Oz8IMxt0aF+tGdbA=;
        b=f4vw+U8m/R10LqHbDLArpAH7OQUhOjanN9zMH6qYAp8vB8c6ECOHoWYwb/REP32XlR
         3wPIh7XsnjK9xRoGEuT1m+kn2huYuva8dZUBt6dCZKy3KJa9Ry4LblZOvaCTFg+z+vg3
         1+2Xa/rTMLJY4kj1jukgm5q11x9iWvpX58jzGdyhjUj/vv0pTnUM4ZXZRiY7PUrov9vH
         +Et2EIRSHX+XfnrJCJKbjv7VcJtNktxtRpJK75Yq2iUe42WaqSJW4SnZq4875EsclRxE
         DqhUC09FMLUv0gDV6ckS0LopvRLr0MxcR0xpOgQf/CPyY3t9h8888Vm3MAfn4oSFLopU
         vE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0854AbNyTTGcn64aYwlT4ZlWQD+Oz8IMxt0aF+tGdbA=;
        b=cNW0d4Tw4Nj0SS4cNCRE54kRWCkIiTSAa6Bc/ON1KYVZlOK/zVZlM6WvsB7caclvZW
         dr+u8yxVYe+Bhpz1uLqvT0ervcz7nu5hpRvM+OCRwdGs4yKQwORcPEUtpuu9WCuCRZCY
         4wNwnphGLzGK8VjIAi6lHos6Q7MKDiNys1y5FPSiCQa0ov9s27NEYCMIgchukooPkqNm
         SUTaLwjj/eq4IZUrJmzf59m0Dw3UIx/ZR8bnc4vMMPHhSofxG2/fYsffrTYihjw+6J4Z
         K21XqkNjB+o+cZXFpYRj54t2ex2/29DHbqit9f0/7CLD8a4uvWcnJ4JVoaSaRerkw5vg
         QpAQ==
X-Gm-Message-State: AOAM5305KNAfoFTDSn/tNWXpUWlUg9IZ8dZ4boZ4Fiz3wMNSrFnhf2xJ
        ewSan8w8HnF8P5p61C+vY77Mjg==
X-Google-Smtp-Source: ABdhPJzoO87A9lypXrxy5r5BlUtGJEZXl/Vl+rguIhlgL4BzeFQ2L+Q0DpqkbCMQuz9p6LuYmCsjew==
X-Received: by 2002:a62:e707:0:b0:47b:e32f:8538 with SMTP id s7-20020a62e707000000b0047be32f8538mr6518809pfh.69.1635455549981;
        Thu, 28 Oct 2021 14:12:29 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id v13sm3398389pgt.7.2021.10.28.14.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 14:12:29 -0700 (PDT)
Date:   Thu, 28 Oct 2021 14:12:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 v2 1/2] tc: u32: add support for json output
Message-ID: <20211028141227.3815c03a@hermes.local>
In-Reply-To: <b3310b7f38cdcd5a1b2fa14671af16821e895303.1635434027.git.liangwen12year@gmail.com>
References: <cover.1635434027.git.liangwen12year@gmail.com>
        <b3310b7f38cdcd5a1b2fa14671af16821e895303.1635434027.git.liangwen12year@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 11:25:01 -0400
Wen Liang <liangwen12year@gmail.com> wrote:

> -		fprintf(f, "??? ");
> +		fprintf(f, "divisor and hash missing ");

print errors to stderr, not f handle.
