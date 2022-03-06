Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221534CE9DF
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 08:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiCFHXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 02:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCFHXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 02:23:12 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00D14705C
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 23:22:20 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 5so19211054lfz.9
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 23:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=VaaSLAJ+hgNGNq49WyPsh3ndDLo+mnrYcswrOHpJSv8=;
        b=Xeak0aeGs1VoKbhSZrM9vI9BL4ml+RUU05F2fXG9p++v5y6vpKNolVfRTRHtsRj0Ar
         YoUhVGzE2N4fduJgaFvsK+w7b9F61axPDEiehsYQyK7boUqdcBCnJnNJASpPQh5zTFkd
         j0mca3exNZiJjSAnknVQlGH3ArQmgORIakFGZ/VB2NB/OXo+11RUl2JFMUzPl1RtgcvH
         /r7yMsbr1XhJTOGQS+wgrJJc/rvTC11iWFj2XRlbSg4ZMmITqu/Wy9Na5kbPHXD1TaD6
         wQo6P/Vv7NBG8gRkv69oH0Xx0IUa+ROCvkkOp6I4qbksOuU8iRrF+p5xQ+hagX1vup72
         WELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=VaaSLAJ+hgNGNq49WyPsh3ndDLo+mnrYcswrOHpJSv8=;
        b=WDu+Yl/iVYciMH9vNv1M0NOucU99BzQJYFwvdo1NzrKfHnE89zqvzmyO+1OGXN9oES
         GGQinwO6N4IVJTr/446WxvB2TqNp6pMmaOu/7rVew4ZjQZzVNdshdS78Wkq4446yUa7m
         8mFn8qFc3I/dXuSvVAfFTI4mpiDQorq9c+NYzuHeg1MWkicOIjiJj3/TcjiDZfsUguld
         NOZTcTJXqLTNEZYf5SqowEOAq9Ts/5hiTe7PmnwNxicTbG07bO4Lky+4kBxpOA8Y/Iwc
         N/9VhVtLhPdzE71d1wwMvKafnmddpMbRkITGSYmSC8pu79dOX9SNN+dOhulsGqxQgTFR
         iPdw==
X-Gm-Message-State: AOAM532Pi5UNY2n5cv31Fq7EM8cAMsm7s6dwuB8eVUu5xEINCLIsIJjE
        Z6vo52f00SbMY1Md7so4gcEwIJF6kAyq/ycGDJs=
X-Google-Smtp-Source: ABdhPJwNLSt3/YRZ7jnDQxGgbZ7e71uPmQcP8wvckk1i59wle+L5EqSqxtg9bHosJtBVRyjLk/XlEobRDFZZ1H35WUw=
X-Received: by 2002:a05:6512:220d:b0:448:2d1f:5523 with SMTP id
 h13-20020a056512220d00b004482d1f5523mr957731lfu.492.1646551339182; Sat, 05
 Mar 2022 23:22:19 -0800 (PST)
MIME-Version: 1.0
Reply-To: mrs.susanelwoodhara17@gmail.com
Sender: mrs.arawyann@gmail.com
Received: by 2002:ab3:7d89:0:0:0:0:0 with HTTP; Sat, 5 Mar 2022 23:22:18 -0800 (PST)
From:   Mrs Susan Elwood Hara <mrs.susanelwoodhara17@gmail.com>
Date:   Sun, 6 Mar 2022 07:22:18 +0000
X-Google-Sender-Auth: jzO_v0BN4EKdVs73Kvfp0YP3Zx8
Message-ID: <CACppo44S2oaZhGN7JtfGwwur=afHbfLX8hP2_1hn2bVBY5MrGA@mail.gmail.com>
Subject: GOD BLESS YOU AS YOU REPLY URGENTLY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GOD BLESS YOU AS YOU REPLY URGENTLY

 Hello Dear,
Greetings, I am contacting you regarding an important information i
have for you please reply to confirm your email address and for more
details Thanks
Regards
Mrs Susan Elwood Hara.
