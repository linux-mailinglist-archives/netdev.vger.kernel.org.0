Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCC91ACAAE
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 17:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395355AbgDPPiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 11:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2897801AbgDPNjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:39:03 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D631C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 06:39:03 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i10so4838940wrv.10
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 06:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dHVwV1hzpRqAWcq9LPcj7aFIz26RHWe+KQsyWjKRE0I=;
        b=Ou+ZsWDihiPS7/UJ1MiMkt4+nKvh6MvBIbyTnk/Nim/99yc0dbU1FF+6d359QlNZCZ
         T27cAkpwdPCKDap6O47ASSuntRdm4LeL9NgB1Fj0yXYQamr00kZojUuLP/QfRS2VgrIH
         HtLKQc0IdP7jOH4ZjhPunb6SNCxwABXOAgHSV5iwT4j1QUj/YQB3pJBVbIuXyaou3QYa
         wmM4im68iHpjRTBdixNLqodldE45xyCIrt4FIRiNF6Rt+2+0j5Fg6GAV4n40oLTzC/z5
         t9cn49p4C5fR+sP7619+kwiTZSWEVsOWokG+FRwoSC4noZwBtTjf8n0PCeXqPhyFKd7M
         1+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dHVwV1hzpRqAWcq9LPcj7aFIz26RHWe+KQsyWjKRE0I=;
        b=DSeD1S27gJZXskLxFl//uP7YfZF8QpcEIpWrCtQoBsvI674UpL2sxb7RuoX4NBKEbB
         dG7gzH6i3DbWCJnDKJuBrAQmwRVfP5KaXog/LtqYGthdLlxkjzSVit0tzQOcisv0D244
         IYp+uYM4DQfYgLXmyQXNGs+GJIboNTzJGlxQhawpX80TiHsA5aQgbPv7VOHj9Rwsai58
         tLNw5skKluP1VqexWZnmz/lY3w2Lf6e/aHQcmdDBMBtqyueFIaodNzom2JCm6HTwYuKL
         UgAB72ym0IEnmiAi10jV6HfLdbvH1J7pZn6PPd6YApWoijK1ZxGvJKOW2bDBL8+5gLG3
         ee0Q==
X-Gm-Message-State: AGi0PuZ3zOsnN1g7nCK0mHW7p6cSvIDKM50VNZTGtaUtGoZ3XFK3yKES
        OH76MmDKmr5gykhZNRbUt7Y=
X-Google-Smtp-Source: APiQypIQjYIYmecq9HOFisoQpzdZK7PsZg/ujgaV9p09KCVm52g+R6aP2hliv2b6LdUqSUyLkevPEg==
X-Received: by 2002:adf:afdf:: with SMTP id y31mr34058293wrd.120.1587044342338;
        Thu, 16 Apr 2020 06:39:02 -0700 (PDT)
Received: from white ([188.27.148.74])
        by smtp.gmail.com with ESMTPSA id g6sm8419534wrw.34.2020.04.16.06.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 06:39:01 -0700 (PDT)
Date:   Thu, 16 Apr 2020 16:38:57 +0300
From:   =?utf-8?B?TGXFn2UgRG9ydSBDxINsaW4=?= <lesedorucalin01@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v4] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
Message-ID: <20200416133857.GA3923@white>
References: <20200416132242.GA2586@white>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416132242.GA2586@white>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should I move this functionality in a getsockopt or ioctl syscall, so it does not interfere with other syscalls?
