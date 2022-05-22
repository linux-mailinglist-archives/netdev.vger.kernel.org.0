Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E5D530646
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 23:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiEVVmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 17:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiEVVmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 17:42:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9C937BF4
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 14:42:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b135so338307pfb.12
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 14:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=loDvYEF8t7bLKVjfnhfY6pWRpyY/6/eNtoU1TRfTF48=;
        b=QivWUUkcK1Oywiv0Mb86TQFBrU3Hs443/UDaBe+xqgKU041stQ507GjLKXnhYrmsCV
         OfpogtBGdU/sfRk6TrYHhGXbBSlbEbdkwYPdHScBlKclrifaMPCCj3X/CDMwY7dOOZqg
         A5IPThLctGH0r4nDVeUB5loBCqgu5848lM+a5/2N0Q2kmuugitXPy1DuqpMzTdFmD6L4
         y7GqwWuknvJxjRAQbuXBM+itQLvBNzREKDrGLRHWAK6EqeuCL43x7iOU5QYp54dOJyJo
         2JDkbvvc66jyrOuvKrhuLB0x/6iUaSJMk5WFKPInNCk4aAhKu6/PpOn6SFwYKYplJe9c
         ewVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=loDvYEF8t7bLKVjfnhfY6pWRpyY/6/eNtoU1TRfTF48=;
        b=RkywT/ojQvGqSAK/wQfSYTN19yQITQ04utrP07tI6+xGc/tWEvE96UksFqwQi2rcGa
         qaw/Km6bkmWOkbxEG1oj4lRPMUU13fmIEXioS/5jzzUeI6v33W/bwd6a7NU9LiEpL8iD
         LT13VXC7Vr1w3xTsyQhjJ4V6mIt1CO2eRabZVMHEyFWooD5sXoeW986hrR3bKI6STuNy
         BtgKBDFDF9DvelqQ3HeJ7Juyqn1YBKvu81Sdt1sRu49CqKgA1W20qjYmXKAFxsalRoIP
         9jb25+EawJ1cSq1PpZp2WL5KK+rF1frP/E5Kn48jl8J0K/5QRJJcnl9BwwS/kAdgA2Q0
         02Mw==
X-Gm-Message-State: AOAM533KiNRhfcRBrcFRH3AxYS+bLR4LJCxZMhlOAnlfTYv8nhiO88rg
        NlTQbIX9Jl6cLOdYPwGIePM/0O4ZLdYucHCaYdU=
X-Google-Smtp-Source: ABdhPJzg0HwRMQ5EnbegKyCDULYd3ZJb1p/bRZ40sN51wfDTXd7WI8cDPrOMybWIYD9/MUYQRWkptFd1ExoymVppZuY=
X-Received: by 2002:a65:694d:0:b0:3fa:34df:cdc6 with SMTP id
 w13-20020a65694d000000b003fa34dfcdc6mr3645537pgq.439.1653255724736; Sun, 22
 May 2022 14:42:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a06:144:b0:4c0:45b1:4620 with HTTP; Sun, 22 May 2022
 14:42:04 -0700 (PDT)
Reply-To: jameskibesa@gmail.com
From:   James Kibesa <summerstimothy80@gmail.com>
Date:   Sun, 22 May 2022 14:42:04 -0700
Message-ID: <CAL4KC5rgJdMpjkfmocQ=26LL8Ks4eK8o4_ytv3GbmbiRBphuaw@mail.gmail.com>
Subject: GPE COVID-19 relieve funds.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [summerstimothy80[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [summerstimothy80[at]gmail.com]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:42b listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
You have been approved to received GPE COVID-19 relief funds. Reply to
this email (jameskibesa@gmail.com) for claim procedure.

James Kibesa


Chief Financial Officer

Global Partnership Pandemic Relief Consortium

www.globalpartnership.org.pl
