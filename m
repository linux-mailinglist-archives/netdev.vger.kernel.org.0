Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0193E63C732
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbiK2Sab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbiK2SaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:30:24 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF152F651
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 10:30:24 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id g12so23476850wrs.10
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 10:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZKN9Q+eq0uc2V72eeYpmTHIZGYsEOhCOCy20hkaLTtc=;
        b=Jx5kOmL9PjWkOVdCGqCCP6eJVRPPnxUu+ESyFlfwmAGllgusYYrfm9X10AWankt0rY
         j6Ex5r68K+zlAR0l6OygC+VK7iGlrQa87ScAUxWUbbZqR3bm1kMVzjY/La2/0MQ9yfz6
         iY1bIP0rf38dE1DXo2u/5yjzRCLgJRmvXe+ZpbGRwu7tuWR/TDCz5/8HAQcxyKrfuTey
         t0lGqcLxNjWM/pQQEjYtqPrAPvkCpH23xhyw17DMhFXd5Wtvu4CXtwrh7E8vCdC4z3AM
         jEhbLO1ZVudk6e60wbIel58Ck1D/lknsEkNTHrUENTsDjJM2AkZhURRSWWIx6yXxvKsF
         mkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKN9Q+eq0uc2V72eeYpmTHIZGYsEOhCOCy20hkaLTtc=;
        b=VNBRpjUt42OBoujSfDZVh9zcmsSxWjSk8kWkeDdfAa2KZ6JUsfuf4cVm2M2L99FDvC
         TGDVYdWsxJKaXHRWuWedg+Uhr2izHPDDZwJfXUQQCIePyCjov/sR9lphdk63Tb58/tUf
         Tuv85NekBuL9StvMYl1kdzcmDNPJCXJQaUn/CA8Kf4QltnxV1utBR1aVazJPScwKHH5Q
         Th38b3kinaCEqE6qllxrM2GMrmL6/Q2Fgj7aUm+K5gjR0sNQe2L/lrVARMdhZX1OiIai
         KDMgCCTSO5ELtvN+Z7gmgNq7IA7MEE04IjMtGOEFY676Sw16ZFZtbFJx0wtDrzOfbAry
         SGjQ==
X-Gm-Message-State: ANoB5pk3ubsr0OGygN65TnYt3+BE4zstcPvFpqJm6CU/k/cADDbXUSDd
        m7Ta5sBYEbQ7bwQsj9AE3lbSu3l6R4FkE3KGPBc=
X-Google-Smtp-Source: AA0mqf66vPlNAfqE4ssKXraqSUWIxeg+72nD8xZig5bl0CJcTApP0WwDn2dHSTLo3Bqi580J+voRusxrRT+QYOXyobE=
X-Received: by 2002:a05:6000:12cf:b0:236:6442:2f86 with SMTP id
 l15-20020a05600012cf00b0023664422f86mr35533443wrx.588.1669746622542; Tue, 29
 Nov 2022 10:30:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:4489:0:0:0:0:0 with HTTP; Tue, 29 Nov 2022 10:30:21
 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <emmanuel84968@gmail.com>
Date:   Tue, 29 Nov 2022 18:30:21 +0000
Message-ID: <CAOCfXBTTFMCDE_V-Z7Fyk2XwKxVeTy2Zko3R6RsOur9XCJ1qrA@mail.gmail.com>
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

Mrs thaj xoa
