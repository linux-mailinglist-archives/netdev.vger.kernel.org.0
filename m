Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674675AEFCF
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiIFQC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiIFQCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:02:10 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE7C82D27
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:22:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lx1so24043461ejb.12
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 08:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date;
        bh=+D1zF2DCKf5WB+zgoPewh33B5r7wz0pan/6d9WW6hok=;
        b=lE67JprNCX7SN3lPprUe6JMb6lN2qR3wx5EWOsmBhTxm9aub8LdgqUGxPSenL0W31P
         Fe9oJK/lPXlccC1QN7Wjy2GgzHjJbe2wvFW8QMvbVOhcKoWftZyFTmmmsU0Utr5W3JNc
         475H2pVPQvqCgnrlyfVqYphqYiNbalvucoAm/o+7Z8Trngt2TN78wQkDJMGNuktelNom
         9TKeW8dxB4zlkaqv/6Dsw3oZeFxUhcaZii15pGo7rN4p8n+o/sQG+VWRnOJ7AJJhkVSQ
         IILXoQpWcaH/ZGY1zEOORGXgOFrSChth1vqhHRqpVghN/M3pHIQ+4vZ7XwShovcUrEYT
         b+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+D1zF2DCKf5WB+zgoPewh33B5r7wz0pan/6d9WW6hok=;
        b=bFj5agjPeUHhBcsEPVTZbrTDvd/bl1cQItBN117dOuSwYXxjtDuziL70dmqcSl+2Br
         oniA4VFAVxuZQzM8g+JFdNqVA8/jnidVEheYQxxzIXzwMgcxpbuvGDqNpTTJImcDGJbo
         8qY5RgLZz/Cv6QlGOrNXuZIeXZYPvsNaZLc/5nl43kxcyGXleHru/W/hV7E5lp5p2euq
         LyYTJc6g+etMgpmP14vAbZ7QxrwE9rYInyOIMbRJbdB6gOAP952ztLnp/+AG0cafISdk
         Tq3Uuh0NzpPLrr/5nxe9YeagpUnaKdgvgyGOx3T4yL450YT0+s/Llb6pdvcjKVzv0OsH
         Rf3w==
X-Gm-Message-State: ACgBeo28nq6TgHNsO0mfCU3iJWhSLQesoyUgLnNQ1qDxUrxE+uQij7Uc
        TyODQ8kX+rpotE18sFDOVBm4lTJJvVihggdAMp8=
X-Google-Smtp-Source: AA6agR5cbTRDey2qc0f7fs1dZ3sw3Xk1BHPqMzgzsKxWP+04LKYTywUrwMCBRz3cE6Fff0isoW43fByQeGd/w/secP8=
X-Received: by 2002:a17:906:4fd2:b0:742:133b:3522 with SMTP id
 i18-20020a1709064fd200b00742133b3522mr26720399ejw.21.1662477746354; Tue, 06
 Sep 2022 08:22:26 -0700 (PDT)
MIME-Version: 1.0
Reply-To: edmondpamela60@gmail.com
Sender: 553450897dy@gmail.com
Received: by 2002:a17:906:7b81:b0:73a:a972:8f77 with HTTP; Tue, 6 Sep 2022
 08:22:25 -0700 (PDT)
From:   Pamela Edmond <edmondpamela60@gmail.com>
Date:   Tue, 6 Sep 2022 15:22:25 +0000
X-Google-Sender-Auth: zuu-j7pUPvFECT-xOq8xyfehoQA
Message-ID: <CAMSAxkXFWxMT822MLDDwGno5G=8rkubfdvrAet2vnDf4trga4g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good afternoon!

Recently I have forwarded you a necessary documentation.

Have you already seen it?
