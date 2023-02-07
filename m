Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C815368DA01
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjBGOAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbjBGN7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:59:54 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8FAE05A
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:59:23 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id r2so13634633wrv.7
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 05:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FRoNIQEL27TQJG5rgUjZdTAvpwT9Pkp9esSjXviO2Rg=;
        b=fxAGNwYjq/NnqbsxI9keYLQXttYGEMd6N3qOUEHQpO3rnU1sbvoZ+06QdwjrdGp93O
         UptqzP/3mFGo9lqRx2OVKMLgKrfwPHyTqqbBi26s/m+pZnPagbvzg2gfMoa1bmA9A6bh
         mSXoWtj251RUrJ4BWmERaWrKFbIdsQV6EWtzv7zmc1VjcOT5wetpAS8+BuNB3Uwxdj5e
         g2xTDxfR8i5f3HeKC6zdiKqvuBJlTVx/hGfrCW+UptLcuikWGSLZGMg1UIMH/Ugm/3Ha
         +YV3jUeyPD1UhmWujDkPqDpYhBWhT7e7vhYoeoSlOIE3nzhciCTjpYKDalA2s7u7xPAj
         NWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRoNIQEL27TQJG5rgUjZdTAvpwT9Pkp9esSjXviO2Rg=;
        b=IZzDJKcXZvsOUacSuY5r2/4a0OrS3cp2yWlY5h7J2HDVV3dd3dMriNXQ04MZ7Urnsw
         DZfyRZuTjKj+uJ2NQDGAbje90KQAGBvGZb/wUOfEFMpYkKsbg/+Q1ZkvhaicxNEH7hy5
         UoOhdnpyUE1txVItq1c7fxS1iU+WGjDWSQv5wOSYbJDC4X2iZ/poXFcFGJorc8Yy+k97
         7Sa67MGZsfCDKHkuCtaxNXZ/lSfKcCS+sa8YVFMmtdi1Pum5z8SE2bm/mzkTLWbMEzsb
         3R7vPd4p4liaNa15LoMXaYjpp7TkRUlYviTTYTN3o6w5tAgJZLddPoBQh+bPxAnJMSSz
         HfOg==
X-Gm-Message-State: AO0yUKU+3wGWUoeLMQnbvRTECox3GOQsOYaMprP3JAwAwZjIF8YVqIIC
        H8Gna7USaRqG2fqRZvc6OhQa5UyqYnyeR/trghQ=
X-Google-Smtp-Source: AK7set838RVR3kW7mUKSJRpjos9lTeEePp42pAtfX8W7z+RQDvMYUokrLXmGxSsZ929KvUowtx1oq2LAq6pcl4gDHmM=
X-Received: by 2002:a5d:4405:0:b0:2bf:c83e:9ac2 with SMTP id
 z5-20020a5d4405000000b002bfc83e9ac2mr136461wrq.633.1675778291415; Tue, 07 Feb
 2023 05:58:11 -0800 (PST)
MIME-Version: 1.0
Sender: aboubacar.s1980@gmail.com
Received: by 2002:adf:b301:0:0:0:0:0 with HTTP; Tue, 7 Feb 2023 05:58:10 -0800 (PST)
From:   Mrs Luiza Godooi <mrs.lllllll.gggggggg@gmail.com>
Date:   Tue, 7 Feb 2023 14:58:10 +0100
X-Google-Sender-Auth: Wz4GfY-LXLAsmhYJE2FrnzbKHdQ
Message-ID: <CAFue52MPdiChjPL=PYuGWAOfQAcE9P=g9XQnkhi4bwL4byV9eg@mail.gmail.com>
Subject: Only Faithful Believe.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I Am a dying woman here in the hospital, i was diagnose as a Cancer
patient over  2 Years ago. I am A business woman how
dealing with Gold Exportation. I Am from Us California I have a
charitable and unfufilment

project that am about to handover to you, if you are interested please
Reply, hope to hear from you.

Please Reply Me with my private Email for Faster Communication
mrs.lllllll.gggggggg@gmail.com

From  Mrs Luiza Godooi
