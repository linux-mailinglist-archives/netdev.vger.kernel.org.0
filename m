Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DCE6211FD
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbiKHNIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiKHNIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:08:38 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9CE13F73
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:08:37 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id b81so8839001vkf.1
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=DKkWfxExwMlEUJXNP6lKfjyb4CMccx2Kai3Q0h/Roaelr7alr5uAkTo62gd3//EKF1
         u/2zEzeJv5VIaaqataB1zclP63Oh4T0RIF6WHq90ryfBcWCt1l8PJITeTlJL2J8NT8CL
         GZsliKtJInFjIPLbI2HgYXJKmMxUJl9MSNLCqqkMdTfKUlpW+2/va5HtK0XoYg2cdKya
         O91VZ9jBHFIfRUXEckXlx+Up/+BxrWBKd6T4C6nR6gjuZsTjiElF4faWZM4wvhutMuo2
         a3hY41PvxkuFETI78LBZNVuV1ml1LhejvXQ8zAgJAPc07//imjJmrdrDqwbr4f2shXEG
         9H6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=mw/W/USxIVGYVesqqFZEa/3ZHx8dEZT72xUBYsmBecfexoAR/c+GaztwtBbsr1dKD/
         rU6BRNmQAUyMDdat6OuAFhX82WAdYj2toTtPE/n2aXT4/+/TjloHz0KOvPt7CFuFUrCq
         XK3qFKtKOWLsCbJv2RHyAmA4VLHv+G5JZ9uqhR4mVFO9hl7rBC7CdzPtiFk7UhvyPmus
         YWO9v7Zu+ksEW3YwxYARA4Akez4nmJqGo3jO7FozX9iDJtMsW73fZy6ImsmQW4gCSprZ
         49cxK4UuVkARCBL6tLYxH7WhInMyFf6mjYC7C6C6813fx1bfxWu9uVJJ6AWlbd5Z0l8z
         iIvg==
X-Gm-Message-State: ACrzQf15Zx2J11/tBoXd5TLJncjLi54ynLbFQPKqXOmKFSw0UFx+ywFg
        R4GrsMVnqZYHfeqs2zZmIZfvwBcrpl/zv3IkWEHoGRzFNqjN2A==
X-Google-Smtp-Source: AMsMyM5tdOYLdG/oxKOBN/WLHl4YriGuBMSS/iGMoC30zQYR1SEKqy220Ddxri5UKqj7OmrjP6qodRR0EpWYfh+a+NU=
X-Received: by 2002:ad4:5be4:0:b0:4bb:e947:c664 with SMTP id
 k4-20020ad45be4000000b004bbe947c664mr44158322qvc.122.1667912906076; Tue, 08
 Nov 2022 05:08:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ad4:5cc5:0:0:0:0:0 with HTTP; Tue, 8 Nov 2022 05:08:25 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <davidkekeli1001@gmail.com>
Date:   Tue, 8 Nov 2022 13:08:25 +0000
Message-ID: <CA+f86Q=8f8EXvBeCBtU7zSEiurpSyEpYw5gxR0u4R6X5kQTDOQ@mail.gmail.com>
Subject: Greeting
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a35 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4980]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mr.abraham022[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [davidkekeli1001[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [davidkekeli1001[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
