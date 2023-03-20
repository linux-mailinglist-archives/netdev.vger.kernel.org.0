Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37946C2240
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCTUJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCTUJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:09:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FF61722
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 13:09:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d8so7346590pgm.3
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 13:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679342939;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4Ip74mXTBaBOu/DM+vMEHiFZnUSz4I1PLZNR1ZgdCWI=;
        b=oogjfSTrLCSIOjXbUVPNh3Q993RELs1L9MOcIR6G6WnyFaqSpdoSM2B/tUOeEHANYw
         ea0WYN/lJQTXhnGurbr+c3TmrmiQEShL/1Qv+8+2JaopGTWzanvTXnrExx39s1V5kFXQ
         zJ7EgHeKZj00XPBsAF0oyhoygja7PTh/lvitfSvjYkGUltgGQ1Y9Esz/KwRDCZ3NEU0e
         gpi3bgO67eHxAYXmS+5QGXOt/b9RpJuXuzIR4jWFSDjjdgGIH8sPeBoNesKQiLj/kfzQ
         MN2OLJ+360f56y73STrpRZ3GDMsU8oinqDyYjHoIE0tnj8NZfKFbpR0XLYhb66oUk0Yg
         KW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342939;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Ip74mXTBaBOu/DM+vMEHiFZnUSz4I1PLZNR1ZgdCWI=;
        b=eSYIkfzhN7Vp9yEc5p5gPwZ3iJAnuqZDfS9YwZNo4+7N4Tp1hETh+qeteTWOP0RCW4
         ErEG9EaAckLjyk3UfpuUf8g6r3bETuWkhvwnLBJKISQsiqtZU9iFLj/zbSq3W/lAlIbo
         2jKnBXXrNr+YG7tP8t78kBVxOM6nse+N5MCJdkjgDYK/L1oepnWPXbGezfOJFC3ZVHDJ
         tBW5geAiZH7NFqTCHV5ur8H2bnlR9piZGJv39+YuXcrL7tr1r3GW3afa2mFde05bkJDN
         M8TO//Kpyn26koCmBCp6od6gqeOEl23DbpPXSPzlcOk1cc5X/yqtoslmUNTFWrzw/y1h
         opJw==
X-Gm-Message-State: AO0yUKXuf1Cg0GcF29Ief+bnj8kpSt/GpVjLMX1y9IVuz3vKmfOPTSBD
        TknN4R00GVHnyJrRTyyOU/HC+4ruTkaUhm9C06TEmolFlOqrSbn0LEI=
X-Google-Smtp-Source: AK7set/hz/LtTz8vU4QTvV5aZWhQKa3oQ7Xb5ozaTTIG9bn2gDyZTQ3pDkG6NsygRbJaknklVDaWToxPEHIhD9VHmNM=
X-Received: by 2002:a65:4249:0:b0:50c:6cd:cac8 with SMTP id
 d9-20020a654249000000b0050c06cdcac8mr2051705pgq.2.1679342939023; Mon, 20 Mar
 2023 13:08:59 -0700 (PDT)
MIME-Version: 1.0
From:   Rom Yar <rom.yar.progit@gmail.com>
Date:   Mon, 20 Mar 2023 22:08:45 +0200
Message-ID: <CAJGeiUjDcuC4=b5Cy8HFMKt7iDZjm0CU5w+2e=r-hCEuMD4UWg@mail.gmail.com>
Subject: Help with source of ebtables extension vlan
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I'm developing an ebtables extension that works with vlan tag.
As an example, I took a standard vlan matcher
https://elixir.bootlin.com/linux/v5.17.15/source/net/bridge/netfilter/ebt_vlan.c#L36
And it remains unclear to me under what conditions
skb_vlan_tag_present (skb) can return false?
More precisely, under what conditions can an ethernet frame having a
vlan tag not be translated into the flag skb-> vlan_present?
Thanks for any help you can provide!
Regards Rom
