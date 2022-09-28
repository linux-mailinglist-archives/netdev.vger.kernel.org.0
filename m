Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298115EE379
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 19:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiI1Rua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 13:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbiI1Ru2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 13:50:28 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53A9B6D4D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 10:50:26 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id m66so13388488vsm.12
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 10:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date;
        bh=IWuIsbiM5h8T6lHfTIwLRtWkWb3zIvS3pYfwzdAYccA=;
        b=SyZyoanHkxzr2H6fF9wa4xCvJDezHTf1qhTv075U//2E89gUKQHREgJM53D2Raih5O
         9zBjj7C0u4VmgvRSeW+jVRzP4d3S8/Ek9m4qFVgM1pSLDYZ5z8KtpAjU1GnOJWBuiaSs
         34TIIyCXAnqgETxwhtLuudJNOep5i89m3TJZbEHmO5XsZMIRypGL6cOQI46bSrbGX3dz
         Is43JEcqiIOOJg4IoRQnNPGbuyrQdS94WOcDwzemO+nis+Tmsi6mgee+trQ7cLLlJXvh
         SMLuAC8acVT8+s/ROW46FJCJcnYfOlXIyuQadJpR5RmzljcrsMe9KqKhOR9WyCvg3dnm
         Srvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IWuIsbiM5h8T6lHfTIwLRtWkWb3zIvS3pYfwzdAYccA=;
        b=4VyssdT83ApGCcDvXhI0/PQ7bKLO2E309dQ5lEfqq6dskTyBILkumzsYNEtYUMhbSq
         foIJXU0cG0Vu0hOS5Q37FgHo2Mp5Qdp5t0zl0LKm9LZiwx3qGotWAy1y6WmArAOa2MMB
         /dl6dPx0oajS4ih1OyxmxO6bB5HwwykPaPtgTEOTLCz7snoP34WzWSaC3fena+R5SERJ
         5LmcB1HNPVrgdVoEgZBEPVDB2KASGvy6eXD4zlKpbwmP+pPOwvPUyARRgZw34GJHiWUs
         8xG4/j4g1n8k6qjBQsCmzBJLGMHsOEeuZb+INo9WFS1dw2kTv/nTNKQV1Z5WPYZX3xjM
         MCjg==
X-Gm-Message-State: ACrzQf3AJ8OE36J+7+MACkctw5xuygUPdD5lRwVuQGjZrKumjQfwJmRp
        dJH6kLkGLIJgJHibNbKsZRegfYeX6hfl6uv8p6E=
X-Google-Smtp-Source: AMsMyM59iIvmjQuH3qdHeVrDsYwoXQogvwyuQ5B/GGGE7B2USwZePO1HWRqi8az6LURyel37VHWPRaAAWFH8TgE5nJI=
X-Received: by 2002:a67:d601:0:b0:398:5965:2170 with SMTP id
 n1-20020a67d601000000b0039859652170mr16792868vsj.6.1664387426015; Wed, 28 Sep
 2022 10:50:26 -0700 (PDT)
MIME-Version: 1.0
Reply-To: edmondpamela60@gmail.com
Sender: phillipcannon202@gmail.com
Received: by 2002:a67:1987:0:0:0:0:0 with HTTP; Wed, 28 Sep 2022 10:50:25
 -0700 (PDT)
From:   Pamela Edmond <edmondpamela60@gmail.com>
Date:   Wed, 28 Sep 2022 17:50:25 +0000
X-Google-Sender-Auth: vxhYuYNia_bu5HZa7sWEP42wh1Y
Message-ID: <CANLyv5iDNGi8AANYFa-5Uo5MVM6cGPbkAHjfFz1raXLJM3=bCw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm Pamela Edmond from Texas United State of America on Two
occasions I have sent you an email which you have not responded.

I have a good proposal for you.
