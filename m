Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F9F6E2FDD
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 11:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDOJGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 05:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDOJGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 05:06:39 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ADC5B8F
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:06:37 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id jg21so51180699ejc.2
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681549596; x=1684141596;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TC3rldRNm5eO74uJmpE/T/ebrIYv4yHqTDnYGSwXSOM=;
        b=k5cZ8PEnGMz9Xo66eOS03uYViN5ih4dgSssT6naDVu8+i/eE3ZAXrOyLBMNC+KNvpf
         L3Ms4+tIxp27+v44AdaeiiioXTAUSGSejN8qolcbPpDzmwG2cSg6fu4QKsKXgnzbFi4u
         NwcbqxD1u74mGov/G9Ku9iVjFLW7yAh75i7NQVlnTbnCn5WzqWToqWMBnHQoLb0Ly62X
         Jj3WFXbRdd++ywUppZP5KAmaPb9oe4q6EJfOnTpkoreWRY72zBS8qwkmldN+lGp5nOCd
         gUjc3+jqRk/j0V5ir6W1V80GkpsPoMKtnmEFltw9lSq1ekKxisk1zKxfhZwbCjlpe8Lu
         CvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681549596; x=1684141596;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TC3rldRNm5eO74uJmpE/T/ebrIYv4yHqTDnYGSwXSOM=;
        b=hE+oX6jLlCWQonmf8oOQAfkzquUp+MME8bOY12biioY2l7Eg7cytrv6l648bwIKFdm
         RBO8eG6YbFdav8Fwa9DrHNU/9IYoXd9T3IBxTQtmrO331VDJsMzu9LnnOWvdp85TxcDF
         lC5qGSTU8wzNTQOrM6QgVKNh7CjvMUXRfp/iha19qbfTusZOkXEey+BoOkMn91mAmVJR
         DNlcUXHDTdew1zdwl7JAzz+Gsg8338BNauz9DJ2PrF7J00lF2BGnTa6a09v6Dx7BGJj1
         TNMRu0NxkGJTs4HLi7tRoA+b/GjFKXO62+9ox+kM+Qr1AVkaeX1m8fKGTmgTpc7cge7M
         pleQ==
X-Gm-Message-State: AAQBX9fAvMcuEmRWGUgZRG/F0SOJmV1o3j+4NBBEWoo+e/G4cETQ6+OS
        eZfhsa1itiwW1CB3LgDpawNMr09P/DR0jDMOlGQ=
X-Google-Smtp-Source: AKy350bDqBsdRddCg4eYQ9Qy+N0ba/zrgqNkNHMtFfzpGVg1pq4eo+fp8M0/Vh3jqPvxsG21FAXzWlZb/lr1F54F5Ag=
X-Received: by 2002:a17:906:dc8c:b0:94f:2a13:4df7 with SMTP id
 cs12-20020a170906dc8c00b0094f2a134df7mr214390ejc.4.1681549596051; Sat, 15 Apr
 2023 02:06:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:3902:0:b0:205:e5e:422a with HTTP; Sat, 15 Apr 2023
 02:06:35 -0700 (PDT)
Reply-To: paulsonjessca399@gmail.com
From:   Jessica Paulson <bbnncc055@gmail.com>
Date:   Sat, 15 Apr 2023 09:06:35 +0000
Message-ID: <CAM0SPy9gV5nBEOoB3mmEOOdHTzid-TTVozaFT080nrH3RuR4xg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, I'm Jessica, from the United States, I what to share ideas.
