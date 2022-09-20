Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436125BEA3B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiITP37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiITP35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:29:57 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6663B97A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:29:55 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id c81so2037959oif.3
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=+DSlfSel3yRE1C1IwW4OrAqTmK3GNN9Jwi8kn6ihhjw=;
        b=ZP/z0SVbTw2O08wweGZHFpjR5zp3Fw/AvHp5BYMtUm0kCFB0Pr0PxHAyztAPPD06DK
         gmgc5KsWpvpuTvczyVVEBuSGE37WDIdpf4rNVmkP0erYhPznpHyicsiOhVk5HpESTdvi
         smTq08sKXqhLG0uyERlgAIskmCvWVCBd3+/VPGA0a0zLPP05EofxJXZFU476hv8mBblc
         tPWAF2XVWp54YFpzng8fF9401XFqnhYwjxuoXe+umbw5AaHgkhkC8dtcC/2Vf191X5l4
         UHFa8GqWP/jU0k50lisOQAMaYq+xxPRYDrujm8IP7yjhp9MhbgKAhKbBkqi4p6UC77W0
         Anrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+DSlfSel3yRE1C1IwW4OrAqTmK3GNN9Jwi8kn6ihhjw=;
        b=WRO+Xp2vVOw9zABBzAecp/tafYl6o0dEDLzsaLOuoV05uXc7/byZ72kuQx1B3iayUP
         qFtGd0Bw6WWIQ/f+GBMPtSeL5dVud5Art5LZDFRa/MOE3uandGRM/VCKSvguiaPon8zi
         1VazslQ87mYfR5xVRK678qaerx8QTk5unUFSq5ygXCFqb3w1lWx+fCI7ws5UJ5t+eTYa
         wZfC9O0bEhCv4Y6XNp6u12S6quDCn/GJwzKxCMj29SkE5p0bTeI9VAU3bCIfBNCumgGm
         LUFhJEvodSwXADVXVveOBLPLN74ty0Bh/UkixTn7Qe+juMsS8ESzpJIMYCTne0s/NSDO
         +C8g==
X-Gm-Message-State: ACrzQf3xq2gnHLPAbf9kKfXl9P1aSQD1ICv8UzRwRTZW0YFmafqKmFAf
        6GxkiXiNbrRdew31Q60EaS71LR7kXrQ0oOSYeNI=
X-Google-Smtp-Source: AMsMyM5ckw6f05wrFqmIP/cANtwHrMhVyqa3ect+P6QI6ytexqkTtainNKnMnWNCvgxV543YsnenH6uk9VkP7eYQX+M=
X-Received: by 2002:a05:6808:1b2a:b0:34f:f989:99c1 with SMTP id
 bx42-20020a0568081b2a00b0034ff98999c1mr1806777oib.173.1663687795175; Tue, 20
 Sep 2022 08:29:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:6e4:0:0:0:0:0 with HTTP; Tue, 20 Sep 2022 08:29:54 -0700 (PDT)
Reply-To: mr.rwilson11@gmail.com
From:   Richard Wilson <richardwilson0012016@gmail.com>
Date:   Tue, 20 Sep 2022 15:29:54 +0000
Message-ID: <CABJaJH9jMCX_SudAE0cjcv+vjCOp1v_NOtQDTLuH8Cbb_jnAsA@mail.gmail.com>
Subject: Deposit
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:22c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5003]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [richardwilson0012016[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [richardwilson0012016[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mr.rwilson11[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear
I am contacting you to assist retrieve his huge deposit Mr. Alexander
left in the bank before its get confiscated by the bank. Get back to
me for more detail's
Barr. Richard Wilson
