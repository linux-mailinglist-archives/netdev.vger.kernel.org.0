Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3770D64CE73
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbiLNQzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239212AbiLNQz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:55:28 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268992936C
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:55:27 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r18so2361802pgr.12
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EObqNwtNGvdYW0oti8ATav9xGajLqDXaqIkF5VnTCPs=;
        b=UHL2rIaP9pT5EXBJ1BYWLTyHvz6c0+YVbUQCf3DGC7usjIjUVDFaKsUNkdyHLaGz8a
         0XUv4RXAYMb0QD2xlUVJsGOTLU1AB/2url9K0w7vLM9us9d1imQQhOMyCSC7F+cRlzSE
         E9WcksN8+AQsw/EUMu7WhJr1IooUnMFYJWrAdc3Lj8K/wIsN/JlkeIXOLE2fohuJaVLx
         Lc5Ry9kiAzRd+QicNBsb9PdFLZy6/59/SqTvzAghWy35HKxuLJ0aF+9+G9uiWRd5ooqB
         jqT7xmhHTfNq3SY3W6bEf0Gx9jzIVA9cURu5bypDGqCzXadQe/BEDySYP6CESMTrG6be
         hf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EObqNwtNGvdYW0oti8ATav9xGajLqDXaqIkF5VnTCPs=;
        b=D35wIz2MZ7GwqkcekEUdNEfCHCU1h8DEY1uWcBVm8QA9KIV/MOH6HcajzLd5A4H5b3
         SbnCAoW1vOd3P9CqcFAXMPMqwFiZVU7gUN7gOPr2unFG8BFAE6sI1BIPGF4FHfg2kqVQ
         9riQ6meSkxThN4WJc+fL2FRE6gMZObzUktzuav0LLkVqTP6zAkxe4D//m+uaD1Xdx5IN
         4k3Cr7omwWgbRY+nNBJPJgUJB0NZQY/1SMKU865y3D8pSk3/S8miQTI3Thl7zCAANLtq
         Gz77qb7E0+BfDGTkPOUpZ3ifn90Gg/jrb7B1eZF5PtrqwZfsaSrZJRTTLrSrwaJfhkHZ
         p01Q==
X-Gm-Message-State: ANoB5pk8bKmwktxwDGYQmg/LsD6m/QDIWUTFnT4fXaCj6zEmwhEA/RES
        D9N9vciQz19bNsXOi1n1rTIX2TaVcg5vCe4+cOM=
X-Google-Smtp-Source: AA0mqf7abCiHb/0K57xt36iB/y07X4NNSiZtRKmdj+YgmIDnTLxLc/FQ2lm2BVwlomB/6GFtzi+VNQ==
X-Received: by 2002:a62:1b95:0:b0:57a:9a7f:7896 with SMTP id b143-20020a621b95000000b0057a9a7f7896mr4409870pfb.28.1671036926572;
        Wed, 14 Dec 2022 08:55:26 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t27-20020aa7947b000000b005618189b0ffsm112312pfq.104.2022.12.14.08.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:55:26 -0800 (PST)
Date:   Wed, 14 Dec 2022 08:55:24 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nick <vincent@systemli.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] iproute2 6.1 release
Message-ID: <20221214085524.5907b8dd@hermes.local>
In-Reply-To: <7a1a4af9-bdb1-cd8d-0b7e-8d6fe9cdc0ed@systemli.org>
References: <20221214082705.5d2c2e7f@hermes.local>
        <7a1a4af9-bdb1-cd8d-0b7e-8d6fe9cdc0ed@systemli.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Let me fix, the first version had wrong name.
