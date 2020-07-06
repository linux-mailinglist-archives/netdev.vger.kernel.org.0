Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C71215E0F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgGFSNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729622AbgGFSNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:13:53 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BADBC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:13:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mn17so3826813pjb.4
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=icSRLqBpxXrxTH36O3+5fqX9znGpznK9dgVGXDMOseE=;
        b=jz3y0BRhKueYYX7l9Rb+J+x5AuwEkmye5/cRjsxp+WmfjtjfBs8Ox/nCxkgCYoeMBM
         P6mkGsuTa8UJmG6ibe/UQgiyeb8NNsMR7IPAjep2DjtNYv/zNucfGJv64JZBUFbPQ0c5
         z0F7P4u3IOZC5NXDt0nBGsMsKP2CiiEVpEiOOOfTdeu7RFBKQvVWJqbN8bIRzGGaEl2Y
         gy8IU/8X+9UJrz1YlFVsr+q0esitOHhXYr4l48GftMzqicmmY/P6wjL++Trsu0vdzZme
         fhTV+C2Osz/VCOB49SwHojfeobbuo2O5AA8Ql1bQXEhLGstM5fuxR3frvD5rM2dbuK5s
         TOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=icSRLqBpxXrxTH36O3+5fqX9znGpznK9dgVGXDMOseE=;
        b=O2yanbXThrL5Q2+2I9/ga4CPPXOSgSMl5+O3xJV6Ir6dXB3zSZMi+f+DEFaQV6tEjz
         ztRAv152hGykKMZbibrt3kKTiSsyhW0AUq25yHAa2ndmPgLyMmg6KS6gZfhc8fC733sQ
         tWmVWT6TFofOU2Jb/gEUl8bXQVwiyz505DnVhzdkJt2Y7BaAri9e9fiP/SoyW/5N9wJ9
         4UQ3Gq3jBzeNVWXLt4U28iFVPYddvzikkbFZmu0D6Ee4ykt9x0k72ygdibr1/naZ2yvo
         CqFWW8DW3/POcOo6QdDXbW856vzyjJ1KV04Gz67XBYo4kKzI0BTIC/z5izN24am+pHqV
         JPlw==
X-Gm-Message-State: AOAM530dN6VCfc6hH4PKWPs2sytqXCLys3ACdKScF2b5KdrDG1/pVLPV
        bSpPqy+/Cm/vBMDZvHtma/aotw==
X-Google-Smtp-Source: ABdhPJxnstMwCle9RcWrPxRMP88VRxJnO59rOLbtcfr8owUsKJaarLxi+VQBmm7JhctLO807G1qNcg==
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr35104538plq.192.1594059232870;
        Mon, 06 Jul 2020 11:13:52 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f2sm18820956pfb.184.2020.07.06.11.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:13:52 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:13:50 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, Andrea Claudi <aclaudi@redhat.com>
Subject: Re: [PATCH iproute2 v2] tc: flower: support multiple MPLS LSE match
Message-ID: <20200706111350.5a916e3e@hermes.lan>
In-Reply-To: <4c59a4a8f59184be8ee48fec5bfe4e1310c34761.1593598030.git.gnault@redhat.com>
References: <4c59a4a8f59184be8ee48fec5bfe4e1310c34761.1593598030.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 21:49:18 +0200
Guillaume Nault <gnault@redhat.com> wrote:

> Add the new "mpls" keyword that can be used to match MPLS fields in
> arbitrary Label Stack Entries.
> LSEs are introduced by the "lse" keyword and followed by LSE options:
> "depth", "label", "tc", "bos" and "ttl". The depth is manadtory, the
> other options are optionals.
> 
> For example, the following filter drops MPLS packets having two labels,
> where the first label is 21 and has TTL 64 and the second label is 22:
> 
> $ tc filter add dev ethX ingress proto mpls_uc flower mpls \
>     lse depth 1 label 21 ttl 64 \
>     lse depth 2 label 22 bos 1 \
>     action drop
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks
