Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4CB6D7BF1
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbjDELuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbjDELuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:50:37 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4971E125
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 04:50:37 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso36955527pjb.3
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 04:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680695437;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r//wscmD6DqkDH7SDBc3decpjJkHCZvuOHM+LAwOwD8=;
        b=J1gudklWrx4NP5n0Z8K1UwUN3ZqmG4WGn9xrBkcW7iYGo1AK646sp55E6LcMYKHH39
         9LljU780GAizKOx2Ojg7/qWSGlmfGzwKWhbiLz3f6//VONzMVoMQNBfjLNgEbwzFcAmv
         xX/mHJsZRSuqkF/vj+iPok1cK8tARyh6mcA2kKH0xGlRtsP3o2s4871iisGuAt+vJY9O
         TuD5WUnxx22ir/ezHfnVfmWRnqqqvEin13RPoOJccIQA5ruCWN9bV13HS8n6V3gg4zPn
         dAWcUgdbfsBAbmTMEtlC9EdQ2HOnn0vSh6vKs+A2KH3xLGuIJ7s9Bw8cLfrdutlfqqAh
         j5hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680695437;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r//wscmD6DqkDH7SDBc3decpjJkHCZvuOHM+LAwOwD8=;
        b=68VthQp+Hxkd4YcVhjR0sfqb3FMg7xO1R2VTYO30ZV5RsF3tg6Hi3wIMw484fuOUiK
         /6ZQHOM+8c1UTR2Y6XQpshp9k3hPuJABTTMKktwNikggHbo368S2YgpIqWd50yqUFieW
         nQ9WU2CidWyHyEHmwJhNjB7wyHfeKSMVjF0d+7CEg2ro3JV1ae4ve1VGkJLYoTnjY+AU
         fSn/FkJJqS+CgvIkVytLynxTik5uq5nF9PyZXGnR1OYkoWSGOlfgw+j0rmEaSXOb1M3S
         iYy7ChTn+ERFD8YUKeCCQuIb86Uzvs6MgdqMut4N0iMI5k8s5tDzGOvwdqW9dLjh1eCa
         NGFQ==
X-Gm-Message-State: AAQBX9e0aRva/L1c86d7eZv6JubVKaXQQUOURFaYbgjpGzEekjB86SpR
        6fmaF7+JzkPAwYyrj9o1PV5W7aRkOk+uwe1MLV4=
X-Google-Smtp-Source: AKy350bliRumCOLzGMVRwR/H4qahrgi79rYHF7bhEm26eqmcRyScpcJbTf3rSvCynPwtT3DyhjsEurlXZGXpC3bA8nA=
X-Received: by 2002:a17:902:da8b:b0:1a1:def4:a030 with SMTP id
 j11-20020a170902da8b00b001a1def4a030mr1296987plx.0.1680695436755; Wed, 05 Apr
 2023 04:50:36 -0700 (PDT)
MIME-Version: 1.0
Sender: angelajuannireuben@gmail.com
Received: by 2002:a05:6a10:e81c:b0:46b:7737:b656 with HTTP; Wed, 5 Apr 2023
 04:50:36 -0700 (PDT)
From:   "Mrs. Rabi Juanni Marcus" <affasonrabi@gmail.com>
Date:   Wed, 5 Apr 2023 04:50:36 -0700
X-Google-Sender-Auth: 76QYP2Npvtuy-sHVIDJdTxpwwDo
Message-ID: <CANdmf_gTJsu1c62BWb3+hJBtsL311PNhJXNO6jGPsLygn1yd1A@mail.gmail.com>
Subject: WAITING FOR YOUR RESPONSE FOR MORE DISCUSSION.......
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my beloved, good morning from here, how are you doing today? My
name is Mrs. Rabi Juanni Marcus, I have something very important that
i want to discuss with you.
