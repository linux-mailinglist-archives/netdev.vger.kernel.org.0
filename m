Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5AA584A3D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 05:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiG2Di3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 23:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiG2Di3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 23:38:29 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82F97B375
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:38:27 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l4so4469033wrm.13
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=+D1zF2DCKf5WB+zgoPewh33B5r7wz0pan/6d9WW6hok=;
        b=ojnqkzaY7RkRdIg0tluHW87CGbw70YiWahZHEEYMC2uYwY9NsZaamCZ/mHQLKGLeKh
         1EDREMsCihRThQlOZW3r/3nB1csGPJDH7RH9Zziub1aEtq9TxAC8ba5k9F0KINtsxLMF
         mo2DO+HiDyDlnfQNOREZ/SJJC+dSJuxBlBmDXsmqDe4d3AI1vnx/RIumFJH1qPdQh2Ht
         ZGD7H7KyovYLmEtVjp646et1iIni/q0W4BkTueVINalwQEXpeEg7SA5uGssBzaOofZL6
         dNy8SX1rIfodPFzBDNkbjahjI1oECbtKsh/JWPyJpBVn489bG2WRHrdxQbcu38QvpaJo
         CprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=+D1zF2DCKf5WB+zgoPewh33B5r7wz0pan/6d9WW6hok=;
        b=D4wv+yoxfSTnKKRqSWJFktJJcoI3Nqe4w5QrTQGMyWa5DYzsChK6jtuusCQEU4EyLu
         tjHvq2Vl2VBrLNwiGmaAxmM6XvYuHvI1SY5s+N2NqnJsW3aTUJkKyKPKcQBqmFonXT7X
         HM69tXHIAjvW10FuQPYRugXgkn55pw4Za6jYHkDABKuQn4ZbipAFx1s7t6bKxgwGdNOR
         NwRs6WbIYH2gdSjzCvCZMhctlU5J4U7t6j7CZcbEG33v17gECAvZB9uXBaUmGPIfYcw9
         qrYSwXe5z0Yvgc8//ErhFem0zpsszhAabj50EV1lSvYGuzS2uK6UVXqzVC74X9xbGtJG
         cvXg==
X-Gm-Message-State: ACgBeo21y7WODxawxsuy+qJiziqyTzMmXs4Y5LWY0VEu6aOlTbIWEOqt
        Lz8ukwhxWkusk3peO8swUx2VzxCzMkZ2Ul8nM3s=
X-Google-Smtp-Source: AA6agR5PFzrxxrge+66T7lro5TmEmwKOGDpAqMIxsx3kaILYLRc+/yiJkzN3OHkBzi+pKx/tQeTG+KIKj+AWRUR9prY=
X-Received: by 2002:a5d:48d2:0:b0:21e:8f48:e362 with SMTP id
 p18-20020a5d48d2000000b0021e8f48e362mr1099127wrs.356.1659065906472; Thu, 28
 Jul 2022 20:38:26 -0700 (PDT)
MIME-Version: 1.0
Reply-To: edmondpamela60@gmail.com
Sender: group511930service@gmail.com
Received: by 2002:a5d:6e8b:0:0:0:0:0 with HTTP; Thu, 28 Jul 2022 20:38:25
 -0700 (PDT)
From:   Pamela Edmond <edmondpamela60@gmail.com>
Date:   Fri, 29 Jul 2022 03:38:25 +0000
X-Google-Sender-Auth: UDOUOCdiZGoE-gbDNCAF99RTt_8
Message-ID: <CAOx31BMsFAnGoCGK=oJxCugisQPnDubq9-HLZudn24UDd14R+w@mail.gmail.com>
Subject: It concern Ukraine and Russian issue
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good afternoon!

Recently I have forwarded you a necessary documentation.

Have you already seen it?
