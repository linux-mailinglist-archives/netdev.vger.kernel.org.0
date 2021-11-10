Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B85444BE3D
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 11:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhKJKHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 05:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhKJKHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 05:07:35 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395CFC061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 02:04:48 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id o4so2179566pfp.13
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 02:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=zGk/ZhZWEg56YKF9pnwKft4+fj3bPtgDY5IUehTT0YA=;
        b=EFKUlaz07h+LKCuJsLlAvQFWfwo6ggSfsOhbjO5HY2wrcPeL+L8J3HX0iNew19uyka
         HPMal2roRPCVskfA03j36k1rEuVu7dSqneOSvDb22Ppv9whSe8JA44wmAKzoIxFgsh2Y
         TLtenW1zVt5YSBwmjAQzVybeFF+CX2WCcryc51QyGu1bHgD5L+wEhLe8BU/zwCUrmtVB
         8xLudiHw0A6BflzgWtTlYeXOmTO7tLT722HvYMjOoulRUURUg5Mzmz0QQ4NR1HMnPlqw
         4Xgj+JJPEwmUbhiUiWmQKgAdUppKN/oTKMunk/JjVSm+TThTl1gyhKLfHsZc43XHu69p
         mdmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=zGk/ZhZWEg56YKF9pnwKft4+fj3bPtgDY5IUehTT0YA=;
        b=NO6FauNnmiUG5U2XYcb0Ly2lWfIx3pblCh5t6a7S2jZA1R7l4itnfOJ8ACZSGhiqJ8
         tAIcoE+je3mpUsw9c9vhFrp9TA8u2cJ3oazg0XCxJR1xELrI2Gq5M3rZm9hZX0tzPMak
         LnwQMURWE9/eeyA0kGsVsNLHTwfCviNy0Fgs1izGGoz58b8LNXOaAvQ0s6OWqxdkA20h
         rxH8fpq3qK/j/a/q1XVvsrC/JEfctbYxaBWcJotlcOwZbqE8xWwaJ7aZkii7YrlNB57t
         z/hI2kcZ257YV3SVeLU3N610kSNjrtAjmgZaQN6A11ah/t7cnUpLrvUP4h03gjnQqD0q
         IgkA==
X-Gm-Message-State: AOAM532NfpobZMdjURts/NYXMGiezK7ImGXeQAXWFc1xFWoedrYpgiP7
        BTJ/KAj5oLGs0Jj99kNJWMXCKjnTIMF2dViSBog=
X-Google-Smtp-Source: ABdhPJwJaL4qMI2rnRCjjyxJRM9Q89kDG4RGR6bJhGluDtTUOu5Zmzr1C/zFVHM0un4YWkjj5qZIorvFKv7vhdMPeLM=
X-Received: by 2002:a05:6a00:1242:b0:44c:2025:29e3 with SMTP id
 u2-20020a056a00124200b0044c202529e3mr98968587pfi.59.1636538687812; Wed, 10
 Nov 2021 02:04:47 -0800 (PST)
MIME-Version: 1.0
Reply-To: mrscarolinemanon9@gmail.com
Sender: engrissahahmd@gmail.com
Received: by 2002:a05:6a10:24cd:0:0:0:0 with HTTP; Wed, 10 Nov 2021 02:04:47
 -0800 (PST)
From:   "Mrs. Caroline Manon" <mrscarolinemanon@gmail.com>
Date:   Wed, 10 Nov 2021 11:04:47 +0100
X-Google-Sender-Auth: nyiWt66c2w0RQYDLMZeAIjPTBoE
Message-ID: <CAA3kfcJj0ZBZceB_UAO4FnkGhp_RnZLTaV3PSn+_WEK_qPaGpg@mail.gmail.com>
Subject: Greetings from Mrs. Caroline Manon.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,

I know that this mail will come to you as a surprise as we have never
met before, but need not to worry as I am contacting you independently
of my investigation and no one is informed of this communication. I
need your urgent assistance in transferring the sum of U$10.5 million
immediately to your private account, The money has been here in our
Bank lying dormant for years now without anybody coming for the claim
of it.

I want the money to be release to you as the relative to our deceased
customer (the account owner) who died a long with his supposed Next Of
Kin since 16th October 2005. The Banking laws here does not allow such
money to stay more than 16 years, because the money will be recalled
to the Bank treasury account as unclaimed fund.

By indicating your interest I will send you the full details on how
the business will be executed.

Please respond urgently and delete if you are not interested.

Best Regards,
Mrs. Caroline Manon.
