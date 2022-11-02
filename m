Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B57615D53
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 09:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiKBIGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 04:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiKBIF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 04:05:58 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507C227142
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 01:05:57 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id k2so43193055ejr.2
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 01:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P94UUStTrUPcayMOGdsy3XukMJnYJS40HRHjOb+GJcw=;
        b=GguabHpeUtZHJqq2MUp6ycL/X54BL5FCgUrMUHmworjVlJM/a1eNd4s/EVzI7X3OfN
         85s+CuagdHfeGL4yCYy2oR2945ZMuRubKS5zqzWmOIebCsWw0jT4F1j1XtnQrlFtgH8e
         1HLpdMIJOV52fRctNAajboZ1Jo2F3ZONsEYx4E18HzTekYDLUj44sSgm+HTgFRTCTWQY
         w7zQnghd9fN0Yr7RED0RNC5mH8W7pARqlAxiU3bYnqjmXQmJT73CQgF47gZCjY9rj8ED
         ZjHjGxdSI2uAy2IGG+v+HlV1Zw2OeK3WWtfc4avS1/iEf0pfFrW05Om64f0kECRby4zS
         9jPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P94UUStTrUPcayMOGdsy3XukMJnYJS40HRHjOb+GJcw=;
        b=OfdYSvqsWAHgTJvad+vcVu4t/levPlLK579Q+2LJ07dA2e8KfwVV5eCtFnuL5y7mgq
         wartm//Yq3kPGPGupjepqqTy/8d6iWraPOeo8P8EeAlftVczYe+Y+piQHBfw2edgbkis
         UTRbs5BVx6aAXp2GeIPNznzcN81RihHiUgl2qHsnGguQ2B7t0BpGUxf+DFftjVPvblPY
         rnzf3g5Nan0iNKdSVhJVp+mcotYSqv9kKPqnEOCHgMtHr4efaJLK70D5ove+GsMdDPE5
         3EjBP77JNKPg6fKcqWK5vp+GmXGN/H2XF7P28gzu5Fcb2zFXlCg7AqPvoydYsvV6CugV
         /78w==
X-Gm-Message-State: ACrzQf3LiB5H1Dg+j/mUjwPNRc92CAhRDDha6/n4yGAr8sBWPHXIXfSz
        DdeLZqjb7qY7jFDvxM6xaHrIMayHVjvkkbYUG4s=
X-Google-Smtp-Source: AMsMyM5bPo8MGecAQUDoAPk/ZoYl8OdpZ3viHO/ItZLzleLBZ8CnHGMLdppZCZ21B/A7UyYs+ffUP2Et70IfcRS56i4=
X-Received: by 2002:a17:907:980e:b0:78d:b6d8:f53c with SMTP id
 ji14-20020a170907980e00b0078db6d8f53cmr22626684ejc.70.1667376355524; Wed, 02
 Nov 2022 01:05:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:c38a:b0:24:d57e:26f0 with HTTP; Wed, 2 Nov 2022
 01:05:54 -0700 (PDT)
Reply-To: brunoso@currently.com
From:   Annah <sarah1edward@gmail.com>
Date:   Wed, 2 Nov 2022 08:05:54 +0000
Message-ID: <CA+4jXko8WANamqOeCHTfqYTyfNL8mLjEsKx2z1hNCS4+mZupZQ@mail.gmail.com>
Subject: A Little Patience
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,REPTO_419_FRAUD,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sincerely,

Please exercise a little patience and read through my letter. I feel
quite safe dealing with you
I will really like to have a good relationship with you and I have a
special reason why I decided to contact you.

Due to the urgency of my situation, my name is Miss. Annah Saitoti, a
21 years old female from Kenya in East Africa.

My step-mother has threatened to kill me because of my inheritance
($10.6 Million Dollars), please reply ( brunoso@currently.com ) and I
will explain all to you.

Your Sincerely
Annah Saitoti
