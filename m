Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC425371BA
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiE2QBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 12:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiE2QBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 12:01:07 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6254FD3B
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 09:01:06 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id r14-20020a056830418e00b0060b8da9ff75so139327otu.11
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 09:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=33H7bzlF73boyoKARvolMJlGymprQ+hHPrvlaQBxLsY=;
        b=hyHQ9L2DFLcq6o741hNwOpVzSG35LkksNDj5nazBjk8lYnvVAsD0WHapwgIU5rzvYz
         tN3luXB584pQW2qTLMKPFEmRlqUAV/feQYR225EktdkESwfxKxmWOB1GQ2SPLZ0Xu9O8
         2sCFdySONr6X4cbb2M10XVCrBxOmMG7JpSBRCOBhbwN1jWLK8+pc13xElUZHWBgKBKFt
         yuRE0w6EEwsOCQWSrF5jJgzCOHkqZkCWTzMkxOtEtl5dFHz44t5Z7sp//ohyUd6DPnFa
         vjsKIzBkpNF6vxD+KWyzZ/k4EjNlvKQsWLDS5UhNqQBFEn7EtUBWhKjzmV88CqyOmS8K
         mfLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=33H7bzlF73boyoKARvolMJlGymprQ+hHPrvlaQBxLsY=;
        b=dMAi0e+SGl6djM2LlIIY10aUO0kY482Xa54UDHoRaHr4JsU0oJVJ+iGWw+eSXsmzSw
         WG84M1+f1GA5HxH/zLXAiqBvTpmdsVIbOS93qhsdWv87tirmBs71D2q6Za7zN7zjSxM7
         tVu9iHBaNCeSPzeO9Snz7ye4DtrCu1fF8YlOpS/TwMHOtp2gIzksS8cMtTFZbLFHwivP
         0axaROTyEyLuB7xrpu+chA8W6J8GRVO0HPbUXJyI4kE9hlhqExtRI2ut2X4JaN/pvxyj
         UodvvXAUNie+36KBCiHplrqMebKEje5cgxNlo1jDVdCvX6Oz4Me4gWzTV7/K5d5isNL1
         Yz9Q==
X-Gm-Message-State: AOAM532WAlzvZC2VloPxJQzSCspun6bIL9SbkHxGx5BVgckdfHKRKwWL
        anFqQDq+IbQWMswuZ/pNWk2thAJ616McWtylUyM=
X-Google-Smtp-Source: ABdhPJy/zmBJtoyJYSZVUcZgKZE/TXZn1zcSNKFHGE7tXsyP76kfDQXnaCHMs35l5vpnXMNAkkvloqA7Pegf7HlCFFc=
X-Received: by 2002:a05:6830:2b07:b0:60b:b38:fcc0 with SMTP id
 l7-20020a0568302b0700b0060b0b38fcc0mr14385843otv.353.1653840065804; Sun, 29
 May 2022 09:01:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:560a:b0:a3:6e92:e156 with HTTP; Sun, 29 May 2022
 09:01:05 -0700 (PDT)
Reply-To: BAkermarrtin@gmail.com
From:   Martin Baker <m.evelinemartins@gmail.com>
Date:   Sun, 29 May 2022 16:01:05 +0000
Message-ID: <CAEvQOXRxgmmNUQhL2TH2DYaBHb3maLVDj8HNqt2g026stmhjPQ@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


I wrote to you this morning because I have something to tell you, please
let me know if you read my previous post today.
