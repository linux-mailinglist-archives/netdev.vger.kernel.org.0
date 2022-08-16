Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E151595B7C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiHPMNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiHPMNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:13:24 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2C1371BE
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 05:08:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e13so13166927edj.12
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 05:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=CZjU7e2a0fCf/XEsO8nJVQl+HPFT9L7SSPvqpdqz67U=;
        b=NoFonANNT/4j85vYAWZV1ilcoQST4Jq8hY1WMaTzU5YDkSZgbytcxWZyeW9Z7LCNj7
         saxwwMhLUWoixzNutza89swpk1sNs0+A6ziQCgAKzI+w045DIcfTG5Yh68YFMeEADPF5
         Ij9rdd7V76Nmv1EoWMaFVjunXXYp50UKXycf2qqXtzdwvTo6zXd6snwPWdkHBm9I3heM
         DLzdTfhx6y4dTVkGVWWMS/CD7PKKPpZGbPqXRXLc1ryyG5iZ+DVTqnEz30emhG8lPjU0
         l1J2jg7TMU1hBCrXnEhTHgs030fpGgC0577OKVsH7HJoEwDvbJakc345tSQVAdwSrSRy
         LTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=CZjU7e2a0fCf/XEsO8nJVQl+HPFT9L7SSPvqpdqz67U=;
        b=qD7IpxDLVXZJdZ5rufG4XdxGpUdK6mmsZdiGDZXiYIZbBYRdkIx9JJ2BvjG7PBmEgP
         2dp24ACUtJklw59pTy9S80pidEFt0O2SG3sjxBdug11EmiU6+sHbJtEpd3c8gIng35AY
         njyPC+Ogi6OlzyNtjobvU4TEoX13cbIaLxgIIl2aSNlwNIThs5RP8Q9jZes5ZdqPTwgV
         XoUy6QXmg3Yxhcto9y/X4KCP+wXPuYPG0YbBtxAxI8g8n7m5XWi4Ts/2+cizq8xitL8t
         61EZD1MXcRwtFg2VHxwRKcfkXKkAxwZjMQZdzjJfRrsv9a+7O7A7bd+3TivuKep/gJt2
         hCxg==
X-Gm-Message-State: ACgBeo37K+IGU93mvdmYDf4tgEdjcHrSE+dBi6Ge7Utyc3F6cHvAMGze
        i1wpbHSJeB0l3rD40qiYNEGoPxVJSHLzNTafUCw=
X-Google-Smtp-Source: AA6agR6J3n33wrzIzFcg9X+hVuea8NyuFvfnv71wikTHNe5dJzIUE/bNdSH+30FK1CM6cSlBUTed1arVEKukTZfuYXk=
X-Received: by 2002:aa7:da10:0:b0:443:6bbd:a6ce with SMTP id
 r16-20020aa7da10000000b004436bbda6cemr13873855eds.191.1660651729828; Tue, 16
 Aug 2022 05:08:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:ae96:0:0:0:0 with HTTP; Tue, 16 Aug 2022 05:08:49
 -0700 (PDT)
Reply-To: abrahamamesse@outlook.com
From:   Abraham Amesse <pascalgeorge719@gmail.com>
Date:   Tue, 16 Aug 2022 12:08:49 +0000
Message-ID: <CAH7u1_4jhWumZ2foeeGO0tSUFBNjvrMV02RuNP-4eMfiJHF1yg@mail.gmail.com>
Subject: ///////'//////////Ugrent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have very important information to give you, but first I must tell
with your confidence before reviewing it because it can cause my work,
so I need someone I can trust to I can check the secret
