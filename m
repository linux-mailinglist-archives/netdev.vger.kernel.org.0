Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C16A56409D
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiGBOHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGBOHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:07:23 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A80E0E0
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 07:07:21 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j21so8345977lfe.1
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 07:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=V5RYFH0CYEv37XW44OczMvVlU+WsjUIeMziTLDEA7/2IdeUnyS1qNzC2RxeSnniNnT
         fv+hG26KeVkmv1L4Ux0qrhvEVeFOcH7Q1aWvS7igyDYBsqfyDgrGosRn5nsFaozdbTTz
         AJDQCy3noBeZMwY3g/fBN1ZrBJJlnXGpO+f6jkBdAg/W07G/jmLToDoq3iy4Y7aTKsr8
         B3jszz07Zbd7wtVCH7gdCqbFABQaFgxIjD8sDFzM92EFAXhbcaY+SR0BsuBqQDHV2YWq
         2eGbdt7+01V2QKO/fK90rPW84kMGVDhrmqCdEGfTxRkdSDnRctdGffSI5CiJ3XA6yP9K
         7pLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=b4XjV/h6VsR0p/DLj3lqTqsouUJKkjvbgv53c+vTk8B/Z9asIdPZKu59gvJ4GWIbd6
         sziqL6tIXBB4F8V2MgC3E5xeO7u0qitdt105d7Wkl/eiJIRhrnTmNHaBTI69V7EXDHsf
         56PwOuP50zKkBOPzu8QfgwypuFNDZppMV1DU+9FE43s6fz9sEtHLRNPfSndA47O+XG5O
         +Z5xdWcEwcuEYjXpqyn9Y/dtlhdg49K8jHeqAp5YGyt3yJ6GRPnVELeIYTUgfTuHw2qU
         wlnffgd/x15fZWo49fIZ3Mx3cVsP+vzVjkArByLxdTG50d/wAvw7uHdEf+eyUmVtF5l1
         JgEw==
X-Gm-Message-State: AJIora+M+G8z63jlWSLr4sjzi/awe21m9IyTlu5vE2R/qp0mg3HG/jZC
        Ebu/xsN8tVat0RcR01jh1Lj++tspJ2H/+H9kFtc=
X-Google-Smtp-Source: AGRyM1tZjUTtqoGvhDilyIio0L12d4/eoQy0jaw/WpvNF1xanE5QP+qQg/wQDneCAY1srrT1KYd0BJZAoHaMH8Yr/Pg=
X-Received: by 2002:a05:6512:2312:b0:47f:6f22:a054 with SMTP id
 o18-20020a056512231200b0047f6f22a054mr11899773lfu.287.1656770839589; Sat, 02
 Jul 2022 07:07:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:651c:1143:0:0:0:0 with HTTP; Sat, 2 Jul 2022 07:07:18
 -0700 (PDT)
Reply-To: davidnelson7702626@gmail.com
From:   Emile Agboyibor <emileagboyibor02@gmail.com>
Date:   Sat, 2 Jul 2022 14:07:18 +0000
Message-ID: <CA+rznj29kmtG9Y-qXFOT5U-OrgZfvfJwoRWfLKPym-kNvLRbjA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
