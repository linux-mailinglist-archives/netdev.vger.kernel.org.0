Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571FB64F928
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 14:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiLQNxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 08:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiLQNxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 08:53:35 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D0613F23
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 05:53:34 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id fu10so4927384qtb.0
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 05:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=bUVS/dg8ArAcxZY6k7GYdHRkb7tCtb2dIyrqrGw2KFktHNZmS5IpZ256/Rc1k1RC+o
         7ZtLNA0NJTsmEnm5ep/UndL1Faft3zb8qp/HeXTeTEhd/EsEEDAo641+6CrHKH6Xn2i3
         4XRpZ/qgP0WW2c0ax9uhBkuL4MCKATh0CosfzlY15maLjVMnyM/QcCL0M9FTaTA0CtnV
         xy4b/YFIKEjpFpdY0wI0yCmnTL3BiMRSChhQbpJ71R3A22ydq5Y4+5iZTy/fnGExBlrj
         3jzpmTKxk41getrReqy+Wbdh5cFZG+L46wxu9Fbt4i4nk8DFmQvf0tUs3bEKNReMR5dj
         wkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=lR3PmQHRaw830FNCw4ap4NrceF4COmQutttGXjUf2n7eW7En7nYKIvkz5WqbISmEpk
         IF9KtKHZYzmZGRuLvzN3jgVvEH7hA3lZIkR9tw4P+KuKDvlYtMcz5ou88NrjMk4kRH3n
         IcIYzG9FkH3tyRcsMM9x9OzzWgZ6srLdlxF/N2DJXxisDXyVUSrST+PT1IrlQE2VRSJ+
         s8YrpMQSjRK8ICJbk87ljbcf3HRdnAclvO1vT3+A9qJv6CvtkRaoSsv0nLom/y3t3Z46
         GKJ+69Ikxbnz36CG2dKd0yoWggrPT2Q1vSkDA869+KigeN7MiSek/vY3BVnkEbe3hjoa
         dzqQ==
X-Gm-Message-State: ANoB5pncy8QVzUrYZfDxqN77jtIZWyg4mauxORvZv6MXYdDcjlGk8hAD
        GwKBLfBAg2PcOtnom4hbudyUBK/zMFNouedx0po=
X-Google-Smtp-Source: AA0mqf7rKI46CJvr+iInOizlHJ+e1yDtL7st8njqBdeFZw0vVOrc8H22ujhEyU/38yo/UyUofcvTweSe9O3zs+5dir4=
X-Received: by 2002:ac8:60d9:0:b0:3a7:e616:e091 with SMTP id
 i25-20020ac860d9000000b003a7e616e091mr13274959qtm.537.1671285213614; Sat, 17
 Dec 2022 05:53:33 -0800 (PST)
MIME-Version: 1.0
Sender: asfiss2018@gmail.com
Received: by 2002:a05:622a:38f:0:0:0:0 with HTTP; Sat, 17 Dec 2022 05:53:33
 -0800 (PST)
From:   John Kumor <a45476306@gmail.com>
Date:   Sat, 17 Dec 2022 13:53:33 +0000
X-Google-Sender-Auth: 27rELLrxJqmBHbmMJi6SQh19HAQ
Message-ID: <CAMhHx7-Li-ncT871nt3nYUpKbv43whNTDTVQ6N8ucb8ze90igQ@mail.gmail.com>
Subject: Kindly reply back.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings!!
Did you receive my previous email?
Regards,
John Kumor,
