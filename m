Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82925676DBE
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 15:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjAVOk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 09:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVOk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 09:40:28 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EEC1B550
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:40:27 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ud5so24645494ejc.4
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sy3zWm+1rpQeP4hR6H66IbPDWw/GS2fQ3JaLboYV3s=;
        b=B3F1E/1UIULJ8WDdILuSrZPSJ7siyJCQUfErnT8VCZNcUs5fI8CQDlVHJYrsqdlQYi
         9c7cfwmHwY0gYvs5U/SdmnXJ38JHPclKRvmmGXaYnaEJvpJACZ0EOMKuH2CjhoVptNEg
         xzcJDVo9hvyFwTQvpWmHkYNLe0OWCmODcc1GECRbDvtczl0OBL+1uxvomtoKGu2Mvr0w
         pXqs2x+itoX9D2CLUsjqVMd3/ioUdJa9b3SnWRMCuDVwG2AkOz6XI7+srA5gVR6wtXIF
         CrwCmc6CmpAoaJkI2XaZYJBoc9owhdFEkgaEQ1l84mg0em3tepP7cTYXSpMOHG51Qr/c
         0nUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7sy3zWm+1rpQeP4hR6H66IbPDWw/GS2fQ3JaLboYV3s=;
        b=LsXeUO+HRsNq6YRH7LgfiF8jWcexAOjkkoY5bqiYa7fK0/hw9b+yD1bM19YoJ1UNwx
         2f5GQey53+QPw6ApmH1x8gWxGWvprzB5wO8fOvRJngtFkP1aSFVYRXezbpPyebpFBztw
         vrvpzfAQNmDfJb/FL09AQJWx7BDDYjOCewHp83hfJh3EoWuG8+f3VWWUOT9ODMjkvi6e
         G/VPs7XJaDl73fWh2Cb98sWpF0gwD45GVPT4XA2ikphQipytDBiFnuKTtNzQjBU+oweh
         6hCCPatUi2F5/cAYyOzwXJ8dCFZ+u91dAeMB3WG9y2XulzRVRRMjWnn1cr+A/6u219UC
         x6Rg==
X-Gm-Message-State: AFqh2kpB2Tw4F+IRAb+JHWhFoR4SAp6w4ktQ3QeGB/MVTmm2tY2gdS5h
        84yhvg9r3SbBKa9ah6qo91PVrq/bBZ2YzeZ4xLs=
X-Google-Smtp-Source: AMrXdXulPRB+cNhrDK/aiRZRUtwXtPaLz+ithbnoI/F12N9dk5SRQSkrcnqnmDjktNT9hN3v2yGZr7hct0B9Leht7hM=
X-Received: by 2002:a17:907:c586:b0:872:c2ce:b061 with SMTP id
 tr6-20020a170907c58600b00872c2ceb061mr3147193ejc.529.1674398425988; Sun, 22
 Jan 2023 06:40:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:d308:b0:873:591:1f7f with HTTP; Sun, 22 Jan 2023
 06:40:25 -0800 (PST)
Reply-To: globalservices322@gmail.com
From:   Ahmad Malik <am0895866@gmail.com>
Date:   Sun, 22 Jan 2023 06:40:25 -0800
Message-ID: <CAC+RTYZ7+wGtAMipEGnqhrDPnYVOXVjVvKY4WC=BTNauck4Mgw@mail.gmail.com>
Subject: Financial
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Do you need financial assistance of any type? If yes contact us for
more info via email (
