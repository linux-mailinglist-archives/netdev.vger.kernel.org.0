Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215866F2E52
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 06:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjEAEVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 00:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjEAEVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 00:21:40 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB64D191
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 21:21:38 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-55a64f0053fso3426837b3.3
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 21:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682914898; x=1685506898;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+ZUuxUTAoz+nMDIAxIHUE5qjUM6hZWQNbOQhvaBX2U=;
        b=HBQMPxQW6rhgG4ciWQhKadeA9Xw11BuLH6cHVoVfFiDhrbCcF8p6sbqsCv4ng3WzeJ
         awl96RoFrPgn9i8DoTGD+/z2ZXmR3npeoWVpGaXNVyGoMlHrdaPUIpxQsyBDtIgiSEJl
         ojC73e83j5KwIE0I6itehWKmTCuhhebtRP1c6hkPuGgjeAV5My0UQqTejB8qS+ZY/7Pk
         DMIRQ6jzZUGwl19FxvWaAZ1s6Tq205EV6Ls3ytl7H4K9om19yhn2NwPqZFSpeIYFcMEW
         iWsLDXEloHoPENPtuxFxhr8lfaWNiOgp95kJznjzK3MX34rXOpVnV+kF+GCJZVPyo5lp
         d//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682914898; x=1685506898;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+ZUuxUTAoz+nMDIAxIHUE5qjUM6hZWQNbOQhvaBX2U=;
        b=QRjEtblhMlVtbzUEXALR8nlVL0o9tIxshuEG3h1GOVSH5Xh1sBDSVaYTmcCI6mgrOp
         mdyIZsN8PZgotDg9DrLdjbQempDxdy+2q8oIno5/hCqfhw9/+Iny3D/l2T7Z9KvDtOPw
         HnCQtnY8Jl+wjbkbLi6czXDm+t5dY+V2ppP125YlA6wcbnsUQ+0sNg8Z2A6eZusmGt4/
         /PQUu009SH68HWtj0SnvMcz5dRDSuwu0U9enNm2YtKqHSk1dbzPZ2xGvWa75ofjaf4bt
         /GL6kBAoZvz2CxVGslPIvNNcxE6McAMxoXal/PNFB+jxa/MS3R0Z/07zN6W+BVPLOgIs
         tHxA==
X-Gm-Message-State: AC+VfDyI0Uoupwgrl4FDOws6yxFpqZ3HrQhg6j6S64PZLGA0FxmJaBWd
        77swcRvosnecQbc/F2Vm4y6tmRYtyb0fYy2ewYHUTiecGHs=
X-Google-Smtp-Source: ACHHUZ4arfw01+5CK18ApEIYsnYGGJJZP80kEreY3ux+s4L6orRBsEY0k65gjla50Qo6hQqYp9Jnv6ZBlflQyy+uXLM=
X-Received: by 2002:a0d:db45:0:b0:55a:4164:74fd with SMTP id
 d66-20020a0ddb45000000b0055a416474fdmr2753237ywe.33.1682914897831; Sun, 30
 Apr 2023 21:21:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7108:788a:b0:2ff:f93:a2c5 with HTTP; Sun, 30 Apr 2023
 21:21:37 -0700 (PDT)
Reply-To: ch4781.r@proton.me
From:   Bill Chantal <un321500a@gmail.com>
Date:   Mon, 1 May 2023 04:21:37 +0000
Message-ID: <CABBO7ctF6BdfgMT0r_DA3GqvA8s7GBF5+1oP+o11PEJV8DbH3w@mail.gmail.com>
Subject: SANTANDER BANK COMPENSATION UNIT, IN AFFILIATION WITH THE UNITED NATION.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1131 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [un321500a[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.4 HK_SCAM No description available.
        *  0.0 UPPERCASE_50_75 message body is 50-75% uppercase
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SANTANDER BANK COMPENSATION UNIT, IN AFFILIATION WITH THE UNITED NATION.

Your compensation fund of 6 million dollars is ready for payment
contact me for more details.

Thanks
