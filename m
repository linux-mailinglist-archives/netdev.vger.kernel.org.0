Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698F963C92B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 21:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbiK2US2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 15:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbiK2USZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 15:18:25 -0500
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1C2BE23
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 12:18:24 -0800 (PST)
Received: by mail-vk1-xa41.google.com with SMTP id f68so7452516vkc.8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 12:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=WUrteBJor5iabiHyu/h6Kh1u4hc7rm0OlJ8vin71QE2YIa0sJuk9tz3TYeTbZH6MOw
         DHr03XIRbLSiM2j9OJYY2lpizwycNUBUgNXMuTjZKcPBoim/7K3vCnpqUXqRUm3Oz6qV
         yuPQMKuDKEz68OzjAOFqca02jt9zWWPqM/jXvh/boC5T4Q/BTJvAh5YSSGf26Y0E3zH2
         TOxXYoy9AyaeJoR+6UfvmNSKYo8KvwE3lEJFRtKX0JOrYu4t41KY6iIl3QeD37rm0M0r
         GKhOeJf70G4rIdx1bRLUwjwlsm1vS6oiNXUHApy2eKB8ro/QmllrbIJgRnYqIWTgsrYI
         Z69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=xARiFfIn/B0MZLynKzSpe99DpwQ2wzN2CN0ful3gHdSjXujIfwD0f8XguNNXnyVaeE
         vOP34lgNT4ceBTVDEuzXDkNO8dwDhdASlVjQimis8jAY4ydvOfQqcUvs16H2BuWbwKfU
         AbAULPWhDaef2ZRRyDcstuuGKS7sg89clet1PMh8IOGsbDrh7MnZEpkWeqlyJb4apr6O
         EPsMjBJJv8D+c17703Shw0p5yGH18/aIkDeaY87Uv7Mxx2nylQBjdixHBfTjfcRazc28
         CBZfIQdU4ju5L4hAS5ziSyFQDTLwwO/CZLHPrYfsAyBHXcnxUc8ixbn2aDu7E2xafzIF
         NK8A==
X-Gm-Message-State: ANoB5pmYK0ZUPjYfcAljcwysRvfyYx3iTy1BsXcB26lzTHsTix/eVPRY
        iGV8GJ6LYgmBxerxWrBhbtp12VH+GUybhThiBpE=
X-Google-Smtp-Source: AA0mqf5ayvorfcB9j/U/Td0EzpinEGhlLui08ksxXYMGSLvmhH0ipr59y3ATqQaK+cma/0LkwLplgR+RKZ5i3q31gWU=
X-Received: by 2002:a1f:2b8e:0:b0:3bc:5598:2096 with SMTP id
 r136-20020a1f2b8e000000b003bc55982096mr24704898vkr.36.1669753103355; Tue, 29
 Nov 2022 12:18:23 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:dd17:0:b0:32b:c965:6e63 with HTTP; Tue, 29 Nov 2022
 12:18:22 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <chiogb001@gmail.com>
Date:   Tue, 29 Nov 2022 20:18:22 +0000
Message-ID: <CACHdXT21_0OLyG4p5xAiMBzF1BibPBSEd-mm85a3qGko1CZ=tg@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
