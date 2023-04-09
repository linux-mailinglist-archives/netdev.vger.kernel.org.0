Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A9B6DBF2B
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 10:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDIISO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 04:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDIISM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 04:18:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082755595
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 01:18:12 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 60-20020a17090a09c200b0023fcc8ce113so4675935pjo.4
        for <netdev@vger.kernel.org>; Sun, 09 Apr 2023 01:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681028291;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vE40mJuVkISt0zg8IVAmmNvtPq9ArtEbvKSLEgCOttk=;
        b=jW2o8kDpMcbR+MQ5XqFb90QF2p4g36Ka49QnunifHdI5ER2gbRWYc/tbctenKDQ9Cv
         NNTPYLnGvN57BvEwyDzhNEBzBsKmlORUCXxtV1eFh4pb9tlQuL9qG0EF5dXzVtOuyb22
         CkKgrt1hYQQP90XnoftqBXaRUBP5J3c6WJ6cROo/shpUtaR4JPzNwhtMBNfGHaAb17/t
         e+X4PA422SK6MWf4CoIAPg97FAEB3XRPOePJyMt4dcQc24bEjMffR5D3UI22y9P09oLd
         tuuw5mQEc+RibmjOD89WObEiKIi5J2LIfV43NVF4CdcdbUkG68q1KO9TxXhf9nffXjBr
         EGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681028291;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vE40mJuVkISt0zg8IVAmmNvtPq9ArtEbvKSLEgCOttk=;
        b=J+1PAXqla2JNPfRw2nOL1G5p1h0GRSwnz8br3fUpWdIWokUXSoD4Mht4akBLKrCru7
         sDoCoL8nkMXFwuiow8AG1QwbTItI8Ac5IO5tcABi4uyMZMVSNTuQY6Axas+5b1sj59ly
         BfI8Ke84EfpdJmFqtU/ZQIHYK1ndfx4cofz60p+7MCk0YP+C0fHc36ZCNkQkmkLUThlI
         GuwQvEMXTyHY4DVWp6I4bdl8UuSo9JmWFzCXi6ZCa7ew6ehjVqFehL5Bn/LBswOhEC3C
         1S5Jm54Sa+Qx4nl7TqlEdZOAekrD0WIlJCft1nMPYs4elKAP3CHdrH7nU+qCtTvBEFhi
         O/xA==
X-Gm-Message-State: AAQBX9cUloQOUY2Kl2V86+1r+nqwwKZ5+SFFfJTRbK9UgTeoF0dM+tMn
        vm0/AjhBRmUV6haCqrYDftO0iGpcIUDpEnuE+MY=
X-Google-Smtp-Source: AKy350Y6WUYL+YcGNWXupJ/EuK2hHnb66CAYg8Iv4ToZ8+lH7ngNb3LZtSZwMXzP/avWH4il5nNMTY+25/Sld5qDXE4=
X-Received: by 2002:a17:902:b186:b0:1a0:535b:22d9 with SMTP id
 s6-20020a170902b18600b001a0535b22d9mr2391829plr.10.1681028291470; Sun, 09 Apr
 2023 01:18:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:902:d546:b0:1a1:b153:bc6f with HTTP; Sun, 9 Apr 2023
 01:18:11 -0700 (PDT)
Reply-To: saguadshj564@gmail.com
From:   Ms Nadage Lassou <nadagelassou@gmail.com>
Date:   Sun, 9 Apr 2023 09:18:11 +0100
Message-ID: <CAJ97MqRww8sLqP+xjv+Ln8qUiOeB6pStyAGMpQOQiF_AgYTnCQ@mail.gmail.com>
Subject: PLEASE REPLY BACK URGENT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings.

I am Ms Nadage Lassou,I have something important to discuss with you.
i will send you the details once i hear from you.
Thanks,
Ms Nadage Lassou
