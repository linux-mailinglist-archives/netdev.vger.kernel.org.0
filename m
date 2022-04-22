Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8489F50BB89
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449383AbiDVPUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449368AbiDVPUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:20:24 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D2A5DA17
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:17:31 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b7so11515663plh.2
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Qt3/W40hcv9wQ5IwEUdWyTaa2pKYTjT3vA04rxBl3DE=;
        b=dSnndCqqc+21Do+Lhf1DjsVzWWQhSpPeFne4QstxrdKu/QDUDfG4DkMRCtlssyMEmQ
         KTQfQxOGwQZl2txKPS2GfJ1zJxwYNzBx+pRkaG+dmg8eI+gyqRhs1XE/N8KxD6EvXiie
         3wqU/Wy7dmXKNA8aNtsby7b7qaa3s7ChPsNELVT9RJyGConQv6MxK41OTiqM+pBrGyc4
         CNYpMmfMV6xY9JrfGeQhed015+hVziI39sLYX5ZgkGFh+mphwPTB95VxbfSqhm5SwXCh
         YmZBteLUSkD2834QaSv4/OWvKx7ZwkYZoe64V3HDN6COVg6p6gTiyywvVbpLpUSQ4cW6
         9Adg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=Qt3/W40hcv9wQ5IwEUdWyTaa2pKYTjT3vA04rxBl3DE=;
        b=DgXSjE5HRoeKAlSKn2SE1RZjAqXQ/mFCe4qo6LJ2MgKjVaDTtZsAQZguN8Ar/iDFTL
         zeqbdFPmVdm8RgmHOxNdlFDoOW9CkSMUzsg1uwj8hAAJJbi263cLHPzoPZY3Fvtn/XiF
         z+oXp9lFyaSxi1w+y0FnBGIkdbS9NNjoW4fMF8v90SpNbMb6pXyzd0hfzFG33SulWas5
         V10OJstG4f3flfAPU7m4qIWrOk9Hpaa2RdQhpnBX8aF0ddyJ+k6d/epxpbAm/Q/nzTJh
         z0SS8LoXE2OLtPq2iVb+LNQQT1Jn68VaLeF79izwk0xh5c2Zdyb7rb/49/GC/UWMXI09
         Imrw==
X-Gm-Message-State: AOAM531aPg8w6vN+CIKZ9xhqD9rYprr8IGmGIy9nZv6osAU6EugRQ1wS
        r+5LVAPgJyae+NUvllxfbCKY1lHO1vwqSha+bPo=
X-Google-Smtp-Source: ABdhPJztUIhCb1vJz+4/Q2aU98qKYgwTdmgYWjCGLAO2EfYIx1xTiYjmHyqk3sd7K+EXg+2M7DZ0GUoX3Jk4uPH57DE=
X-Received: by 2002:a17:90a:c02:b0:1d6:48b:176c with SMTP id
 2-20020a17090a0c0200b001d6048b176cmr10007338pjs.146.1650640650911; Fri, 22
 Apr 2022 08:17:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90b:3e82:0:0:0:0 with HTTP; Fri, 22 Apr 2022 08:17:30
 -0700 (PDT)
Reply-To: marianadavies68@hotmail.com
From:   Marian Davies <apebli994@gmail.com>
Date:   Fri, 22 Apr 2022 15:17:30 +0000
Message-ID: <CACjfG3nz1acj1xywf8SQ1frSq41aPuT98wG-o97_be6Hssdtbw@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQpEb3N0YcWCZcWbIG1vasSFIHBpZXJ3c3rEhSB3aWFkb21vxZvEhyA/DQo=
