Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E626A971D
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 13:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjCCMRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 07:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjCCMRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 07:17:45 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E345F6C2
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 04:17:42 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q16so2072352wrw.2
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 04:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677845861;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tcw1FUJszn0ybZBzjWPIGWACFhZNznsTlZ1HMZm7vk8=;
        b=QWFA1p2VbUvl/RdUvsI9SrEVga79yQA/3yUbwnl3CpZidZGFIQlkcL09qXoGEQNu3i
         agte4DV6kkLCq/KqGuFyAvw+/Nga+gxAVctFDcVnsTWnCKsQRAPun58wU6kJ1KDh0kWH
         2cS7OrYiZnenvxsMX2G4Gt8Ee79K8jM5w19wGv83UzdAdKL32vuFrAIQV1fEbgzHbXiP
         L3ohqh2BIXxmlGY6bGAVtOCw5Lb21ZQOytMyzrZHBYpUTu66eWRoQS5LntS6IpS4z80B
         kKvm4qSLGjYNuqDJh4X5capNk2b+Hiv0eMPoafJeP6PzyhlnTe346F8xZu1dM6P3h30P
         QPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677845861;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tcw1FUJszn0ybZBzjWPIGWACFhZNznsTlZ1HMZm7vk8=;
        b=M0SnaPWsxAQ/spJuTW54RTH3rWZeq5jJSkz2F+wyPv9k9qL8hzE7dpX+ICpXOQy10B
         jpxEK1qR8oVPhkNyHLUvL/RzzgWtpvpGsyTEW0lEcINKCzs9z5wQ5wBzPtthpb5e06iR
         ckquwv6ehA6li9j59ftqXOzWpdGNlUgVyMO1uPlTwZEW1jd6p4LlcCAIOO+uSLuhYZ5R
         7LsOkMmtmU87mKOVmuvmhu8v5bXCn0gLIyzBUMVNxdRurDmCtb4FxljlTv8pUtx/S1l4
         N6tOjdo/AiCpauhbdLMoqZ1B/Q2cFRk302/dcbfNdIvk/D4z4p/t9uFRg9EJSZdQR5FB
         viAw==
X-Gm-Message-State: AO0yUKVB6q6ZGO77bEy7qtZ2LQ30A3w1v1YSX/XLjYzF+isZefFD9vkR
        Gv/PslD3BAPVLZ6BKgR1MkVrz6jEaxBwH+yvrRI=
X-Google-Smtp-Source: AK7set/q2qgHoldqk5H5fHx63GGguv4oW2aJMvHYg/RMimJh1RiuYAb+oDVDZt68KNqXqDha/i92nGWXxoipDebsHGo=
X-Received: by 2002:adf:f584:0:b0:2cb:80af:e8ab with SMTP id
 f4-20020adff584000000b002cb80afe8abmr395579wro.11.1677845861134; Fri, 03 Mar
 2023 04:17:41 -0800 (PST)
MIME-Version: 1.0
Sender: westseaoilandpetroleumservices@gmail.com
Received: by 2002:a05:6020:29a1:b0:263:7687:f144 with HTTP; Fri, 3 Mar 2023
 04:17:40 -0800 (PST)
From:   "Mr. Abu Kamara" <mrabukamara772@gmail.com>
Date:   Fri, 3 Mar 2023 04:17:40 -0800
X-Google-Sender-Auth: mzELhk_HG8JExflG6i0PX5QuC6k
Message-ID: <CAO_TN8wOgZgR-+_VuPF-Dq-Z4X5RH63NVLp7ef-OiED+5H84QA@mail.gmail.com>
Subject: WINNING NOTIFICATION.......
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:436 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8992]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [westseaoilandpetroleumservices[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello greetings to you, My name is Mr. Abu Kamara, Director of Alpha
Lottery Guinness, did you get our notification?
