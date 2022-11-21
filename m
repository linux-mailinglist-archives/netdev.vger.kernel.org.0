Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DB6632540
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKUONf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiKUONM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:13:12 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654EB10B6F
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 06:11:44 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id r8so4033896ljn.8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 06:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLuxvrtTwLpjQCdZkBOlAPtT4PuOt7o3XUb4SWGRYeY=;
        b=ZuqIlZt0gN7LvLqLHOeZLr594lzujfZhePYXLj7XlVvXEh5WITMpD591Pq2VU29rHG
         qijZY9bH3snSAbYuWhIyeTjy+25Qi8B4jI61PI/8sGPRdx8u7w3ticNnDDxNQZwlXa+j
         SKG9LvQISh3zQdoL0fCuB7HEPw1QCi1qw4XrytLg25PaQQvKGGipPbnMmxMvyKx5axjU
         bOaHkPdYT100zPMWPmfXQQ83R/MHsb1a4r8liFo63VSkdvfLXYGyx1GR7cXdZkNkdROa
         DMPy1VfUNWFa9H8ryyhvmQlRfU+DHoktopyu/vUOH7arpV9zjJ68/JRbrTnMIhOkeqNN
         LWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DLuxvrtTwLpjQCdZkBOlAPtT4PuOt7o3XUb4SWGRYeY=;
        b=HvnLiBMdTW2BNRUBIo8jbyN4w1YPc2dDFRHjVO0aTHCwtn967jsK1H0G0H1RJP1L1i
         jVVDl+njWC6vzNfSznb4oZ5sWsoAsQlLwxDCWSw2mEelJDBcNV+4KEp58D/M45RAp9pE
         6cBTwWJZ4iqSO3blY/NMnaIJT2OtfGpJR0VJSiytNGbPG32+XNV9Ut9aspBk3OxWHn/w
         NbWRzADUvSt3MudMbYdG+sjfXrUO0DGZlGEZVZoB4KfWfIFEP65rrKwJbMSs2lhmxIdV
         ap4WwUNxGOs6ioitz62939UAB3F3frLabdY/iW4A0EgG0jE9TKAj8cfwXda0cXtFJkWX
         iKxQ==
X-Gm-Message-State: ANoB5pl9LR5d90flbyFd1br3yzA4UEDu1dbRjT+lIqjYuSawjEjm03Ui
        1LQcYV2Dp4CpYN7QHB2Ot5yqo7l3Q200k6s6beU=
X-Google-Smtp-Source: AA0mqf4qfdtst8qQg8lEmr88yBL5bETz0MccOhOZe362+u+PZd90AC+0Bott4vk+lcf7WylI0p4kOqTs7j1Ky/GY1j4=
X-Received: by 2002:a2e:a5c5:0:b0:277:155d:28c4 with SMTP id
 n5-20020a2ea5c5000000b00277155d28c4mr2041861ljp.123.1669039902582; Mon, 21
 Nov 2022 06:11:42 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:651c:1a0d:0:0:0:0 with HTTP; Mon, 21 Nov 2022 06:11:42
 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <rw32888@gmail.com>
Date:   Mon, 21 Nov 2022 14:11:42 +0000
Message-ID: <CAM3vi+8x4M9FeJSY0BWAN6Rry+f14JgHbsitrU=dvjjdtgAdhw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear Friend,

I have an important message for you.

Sincerely,

Mr thaj xoa
Deputy Financial State Securities Commission (SSC)
Hanoi-Vietnam
