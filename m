Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B74496CEC
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 17:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbiAVQhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 11:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiAVQhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 11:37:07 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928ABC06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 08:37:07 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id t4-20020a05683022e400b00591aaf48277so15944465otc.13
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 08:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=nQfnDsNAwBhiTzvcCVWAW+CtmC1+ndx2xo4KA92H/eA=;
        b=lOvmxgmq9GpbTSQfd+ZMOUCrgP2Z9ebtFKrmDF53dJYX/c8icafiNfu59uSvoiRP+z
         r7/hjR0alstPoPV+L4rI8i7DP05RowYcJzdW3a8KGKOYCkeqmbt22FJJ7iHOE/HCHAka
         DTIb66/8K+Mfo/fk7Hu5LFZPIPWpZtjW8jD8WfoQTJokDY82ulKFPJLLGMOWJ/DjAH5K
         2mI2lg/2FIU5yG2bgvH/a5v136ZvJEbt4rTCTLFJpSNBAIhV2b1VyDaKBZIkPPL2ZEo0
         NjL6qI/s/1hStAug11rd5vhsFgbFq8zV8BXks3AOPk2uRhE00UCLALehecChc+3YEiUE
         Vh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=nQfnDsNAwBhiTzvcCVWAW+CtmC1+ndx2xo4KA92H/eA=;
        b=1FH7yfhOqmSbOx/HT1qSQL9sAcBQiobsiE8zcZdzkb7ynSxVv6Jk2qGaVdt9IoPsy8
         LOsP/29VKI6mgXb1EgxA1tpgntOtChfS8mNIKhvMz8PIUQSM3MMFYisibJklYZDYT78D
         BloWHbSicuzrOTATZKwhoKToW1QaV9r3pR7q55WAJWxlzPlEsIuK0cAVkhsWxpgfKGKZ
         Ow9MoLmtmcvO/OQrDA6iftLVH76eY4plg3ejDBliHUKaeMwZexcBg2SVlaH87x9I4nDd
         GSKj63re5HwZN0SQ1YFBHpMb7f+w8rXtSmaxDT1PguZ7n6r9nmpeYer1o6BCECVYdNte
         LkZg==
X-Gm-Message-State: AOAM533uri0t+W3nMS/GuenT4fRKNs62+cJHajx4D2e/MWgy+1NCKfr6
        1zjeMuxufkaWJ0kEuZ+n5zNEh49rUdbS1/buiKY=
X-Google-Smtp-Source: ABdhPJy45GdFGFWqtDRRnY6spEsR1CPXS4Ge8WGwaFz4ageK291v+0ix2Hyj3ZAvMWfg7wze84c8x70U1VKXNRrbU2I=
X-Received: by 2002:a9d:6e94:: with SMTP id a20mr6245428otr.378.1642869426734;
 Sat, 22 Jan 2022 08:37:06 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:56d7:0:0:0:0:0 with HTTP; Sat, 22 Jan 2022 08:37:06
 -0800 (PST)
Reply-To: nelsonbile450@gmail.com
From:   Nelson Bile <addamss.petter19@gmail.com>
Date:   Sat, 22 Jan 2022 17:37:06 +0100
Message-ID: <CA+gU1v3=xjMo0tNZUVw-rNnwrhRsAhkGsc5s-KmgBxTVM5F2Eg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings I sent you an email a few days ago. Did you receive my
message? urgent response please
