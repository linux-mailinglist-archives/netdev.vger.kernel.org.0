Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85DC527FAB
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 10:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiEPI3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 04:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiEPI3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 04:29:08 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B2DE027
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 01:29:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n10so13780963pjh.5
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 01:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=o0qudJChmRvhx2giXx5fvIT+yx8UdlmNUYCGDDspMcA=;
        b=mTE1B3n4QnfzlkX5aVAovaqmtE+aMaVSb0je8RcOdNCdHBQYuwZjnDBME8kqVUlt3V
         94MJVbSkiMdc5Oh0lZ5YKGoZBKnPWb47wtm64FTJRCHnBaeetk5o49dYCoEm1Dci1jUc
         1lxorlrKP1h6/NGVALbUN0sRNQeaf0/OHInzA5qF4KZDOmY9unSNinEYCGzqPlWe4M6L
         +/YG+GNzAZ57kb4oV96L67kb666LlSG6CIwLSGflZ0Q6FK7GVAIamIl3AbaQt0ZFTMBd
         pSv7135JOCsYWwR8Wj021gzOkr3ML2nkuC90rIEeFlCxXBnAGncXMesNssteA3lHGefH
         QtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=o0qudJChmRvhx2giXx5fvIT+yx8UdlmNUYCGDDspMcA=;
        b=ouLcanJUqBwHPCopx9hSuCP0G44o0N3VXfoAlMikXpXaEWBfZoJQS4KqAOP7J4suJ0
         B9J88cjdCPgGZ3uTby5L9j2vOhncventk6t+Ts92LTrwOOdN7ca++X6T2+OmWJ4VYcP5
         vdaYaoGY4KG3UGWHC6uC4VG3HLNkb8B9u2WDE7dZ9Pbe8sMMkmhnW462qDABDgYGo27I
         yZ1ZD+RtH4shq2uQzk8WwbhYDV8lKZI8GOqE0pu3Htkm+AycQ1jMPgocU2lUPnWue6cw
         Ju9iZF/K/XJtP/druiqQujAxCNUFAIgnIA4oO6Zpex5cqhmNnEb/eaJrBUhSm7p2/xoW
         2RDg==
X-Gm-Message-State: AOAM533sy9aQ0CPBkOTwMtVaGuHFEVVv2smzSZGTbtXmd7ucr7zQSKce
        CCOyDf7bd4clVkKxBdKnda4Gc+UKWefans9yVdE=
X-Google-Smtp-Source: ABdhPJwvY5nKLevmymAuaEubqk6cqT1MhbeG+hdXKdGEGawMSegIuGrjyf02dlKsExvLznHJWMVgyxkiOl1T3S/ghQg=
X-Received: by 2002:a17:902:ea46:b0:15d:dbc:34f2 with SMTP id
 r6-20020a170902ea4600b0015d0dbc34f2mr16150120plg.60.1652689747347; Mon, 16
 May 2022 01:29:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a06:1e8c:b0:4b8:c638:ee8e with HTTP; Mon, 16 May 2022
 01:29:06 -0700 (PDT)
Reply-To: jean.micheal33@yahoo.com
From:   Jean Michael <teresitar725@gmail.com>
Date:   Mon, 16 May 2022 01:29:06 -0700
Message-ID: <CACe6KOPg3KZOZr6gkOx19Yvr1bcDaQFuDZdf=LdcrjtZVzCbtg@mail.gmail.com>
Subject: Hi dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4617]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [teresitar725[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jean.micheal33[at]yahoo.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [teresitar725[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Please did you receive my email if yes get back to me for  more
    details about myself
    Thanks
    Jean
