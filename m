Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89EC5403DC
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345053AbiFGQhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345049AbiFGQhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:37:08 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2943C92D3E
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 09:37:07 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id g13-20020a9d6b0d000000b0060b13026e0dso13267240otp.8
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 09:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=V2h9z/Ifbd6f4YrmaVfXNCHrvbCppjkt75BAO7WtpHM=;
        b=Bde9pbF8/kL2J+zYmNeX1Cy7rEupQvGPik/dAD0mz6TBfvu0v/svVPKmsUiEdbZQvX
         pEaEmtyF85i4F0GONmezo5JDuuP5wYfkFLHNE2DnVGnw6Fdion1COkG92tF17sznC31H
         S66iE0/jHww5XBFRJyMUk0tHl+KWJReHe11jMFxKhBtpKoPvF/f5OccBGKB8qcf6U/eu
         fjGMGw7qJcY1BXr+cYm2MmBpPoX2x8ZHkXXybXYq7JO4V2C0N/h+/GWBZNuornWxwh2M
         y47ZBnjUitDBWdekiF4M90d7oSkNGxCRaJlDlzY9fPjIuSyqldGQw/uGr1Yu0khMxEZW
         CcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=V2h9z/Ifbd6f4YrmaVfXNCHrvbCppjkt75BAO7WtpHM=;
        b=rDf/OFFJL7bnNzGAIxX8QhjnTFOAPtj/7ohqRO6eRNgbCx7imqkiX37xEjcqZqHV5t
         O82ZntIY7GEVTnn6IxgpA6pzQMPvUPjr0/Kc6km4kIGwyL3wHBKivMcuhxv6AJDgfgrj
         yG9KjBf7qBld25BwAvqKk2dVsonfsvpaN1sNBCORsIj5ayxoOxjsdy/K4jcSJf4WaB0C
         GcPnjnjTtN3GyY8hCgPfKRfNWF5PWt/faLNUrMhIvP1nMBRf2I65yrtTglV51k8IdO+u
         ijwGCU2Ry1MuuJk1o9FuFeqtfHB32kGTnH+gSc32TuZ7YYiUolj2JI2rxnCMYjovAcUw
         xUeA==
X-Gm-Message-State: AOAM533mKqsZZ2Omq8z8yTyV0PnXV5uH9hfKEtTJKzAMSTfp2irWHj2N
        ASjmj2X0GS6W8qx857HgOz/3n5U03B1SJvv43PqjVw==
X-Google-Smtp-Source: ABdhPJw4ZEmR71RxBkUJKriac+k6z7Gaxe2UYTNIXIQ4Ge1yRvWFkuVPXxOeKiawse/tQZlZhJY7p4uiWEb5pTFs0dM=
X-Received: by 2002:a9d:2649:0:b0:60b:fd52:a47 with SMTP id
 a67-20020a9d2649000000b0060bfd520a47mr4497090otb.246.1654619825215; Tue, 07
 Jun 2022 09:37:05 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 7 Jun 2022 12:36:54 -0400
Message-ID: <CAM0EoMn_4k_w_maX=0=tmiK5k1nTEWpByGP+83qiJHdM0DbigA@mail.gmail.com>
Subject: CFS for Netdev 0x16 open!
To:     people <people@netdevconf.info>, netfilter-devel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>, lwn@lwn.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     prog-committee-0x16@netdevconf.info,
        "board@netdevconf.org" <board@netdevconf.info>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are pleased to announce the opening of Call For
Submissions(CFS) for Netdev 0x16.

For overview of topics, submissions and requirements
please visit:
https://netdevconf.info/0x16/submit-proposal.html

For all submitted sessions, we employ a blind
review process carried out by the Program Committee.
Please refer to:
https://www.netdevconf.info/0x16/pc_review.html

Important dates:
Closing of CFS: Wed, Sept. 7, 2022
Notification by: Thu, Sept. 15, 2022
Conference dates: Oct 24th - 28th, 2022

cheers,
jamal (on behalf of the Netdev Society)
