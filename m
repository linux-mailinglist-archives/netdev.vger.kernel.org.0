Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3B334D9F9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhC2WOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhC2WNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 18:13:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3A6C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:13:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s21so6710555pjq.1
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 15:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mHgSyp9m0a+Gs8jnMlENq1/aIQTsHN5dXu4wmBb+0+k=;
        b=txM5LyTMRt7qYnK7JA99c4LT1mUlzg4q9IVZnMS/9pKO3vuAtqKc37uYpTkFFWyvFA
         8v6+pOm6uVpghDPF0Qkbbw370BfRZtdjg4rk1vHrvaIGMcftxrMv7tb6bb8CsLAjyBpT
         ntTnkwo9+PsFnU/BAuvbrbvC4YG6X1+tbi9wch+m/LyTOEcHxmUHo9eOpazGhibyXQjm
         sRLfAZT76Cg639YudQb4J6Xgo86eY8rxSWsJ84i5X123uGwP7YHRiUTwGNGB3t8RUwLw
         mp1QdTbu2cFFCmpbcZhNfNMCPw3JWm1DxNCMcv/E0sptVJsPm2ZTWD2xh2HICJKphOR/
         SLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mHgSyp9m0a+Gs8jnMlENq1/aIQTsHN5dXu4wmBb+0+k=;
        b=rfscdUS9vlXIx/gVTLUq7/RmcFWkpGYfMh4Cz9BbLlwGFusHNDchYRHNGJJrn22U6e
         CNA+C3s/Zt9lfvE4Hgcl7Ns4f5BojaGW6yWbqG9jfxZ8X/4iEtUp/GUMPwyOPdQtSlvq
         10hAVhLt73qBIydZaI4EJnmgOfq5U/3R2Oi5sLOVG/VSr1y3kaW2/4J5J550HGDLnOcv
         ZnMJO38U96EJxiPp2hPx7/44ctjtSZLFinneHhMrNZ93Z9QrsoYlQZ4HjThh09sc0FJd
         l8QqVG0AtiNJHaLI6Yp6rvOUP/AyxVA9wvqOfldKwc/gxsFkOft6fh05/5E3JewgeT59
         TpUA==
X-Gm-Message-State: AOAM530kstuLtbGrTJ+2Wf7nOEKqJ89LlOdHrt1nmDtJGIrX/CtrdOuS
        DRBzdR+KrNjI02G2/CJMK2B/dY1sAsVgoeox
X-Google-Smtp-Source: ABdhPJzID/it+FMP9CTOLArTQwKd2kMqu8Ch9gnFKYnt04wLtwC3v34PndcPk9oWNRtVNrJ4DUYxqQ==
X-Received: by 2002:a17:902:9886:b029:e6:2bc6:b74 with SMTP id s6-20020a1709029886b02900e62bc60b74mr30738340plp.13.1617056026480;
        Mon, 29 Mar 2021 15:13:46 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id fr23sm565786pjb.22.2021.03.29.15.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 15:13:46 -0700 (PDT)
Date:   Mon, 29 Mar 2021 15:13:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vincent Lefevre <vincent@vinc17.net>
Cc:     netdev@vger.kernel.org
Subject: Re: ip help text should fit on 80 columns
Message-ID: <20210329151338.790332dd@hermes.local>
In-Reply-To: <20210329172405.GD209599@zira.vinc17.org>
References: <20210329172405.GD209599@zira.vinc17.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Mar 2021 19:24:05 +0200
Vincent Lefevre <vincent@vinc17.net> wrote:

> Help text such as output by "ip help" or "ip link help" should fit
> on 80 columns. It currently seems to take up to 86 columns.
> 
> Tested version:
> 
> zira:~> ip -V  
> ip utility, iproute2-5.9.0, libbpf 0.3.0
> 
> but that's the iproute2 5.10.0-4 Debian package.
> 

Have you looked at latest iproute2 in git?
