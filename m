Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B358560F6D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiF3DEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiF3DEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:04:50 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831682FFC8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 20:04:49 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3177f4ce3e2so166599137b3.5
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 20:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=+euL4kvAXiXF6UpvarEE11UuxUejKN5VHaeOjPcjQnY=;
        b=XXdYcsx6g6Y2+zeZjdWPFI8tA1HD6VS7RKFfEEOfxURClqXxiE4ZpTFX+C2lCEmBfA
         Q9nN+V707zRlb5PfNt0vJrdvXL7X31AAshbvUuSYfYUl/QUcuj1l0YZJi4AjWDRGNkf8
         sbvneKNIwxLMX50gBV7kj4K5ECBe8VM5oWFg+scLh9ETe0pNO2oizfQ4Jui6f6YLcKo5
         6gk7DNTI7ml/v0Ftj1J9vFjcJ2u2ZhZANaD33n4hkMB/HPrLUBeCiZ+jNMbnOrt2sD9X
         wpALXZFyc7jlANn9rpq5m+gurnTUgeseYR2Cpkb5eMpLo5T3r+9816rK2W7sd5yVU4xv
         IrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=+euL4kvAXiXF6UpvarEE11UuxUejKN5VHaeOjPcjQnY=;
        b=IEt2ydoNUFw3r/wQ6VHfxKnxFaSRN/NCWrLe4Gk2cXAdEhWfGyEr45Hxt7LW3/0Jlj
         NmXy/klJJsdJExWf03qlM+s9MBXcMQtIjpiZoALCkNQFKJ/+3aMiOKGPV+tGu3xnav0a
         ZZz+yTuIsM33KMQ95e/hN9h0p1Am+XfdcrjojdhAjJtYh6eed90L6PHX+JZDeZbtWJC3
         RTD+XXO85pkusuPy+IjXLUghEnWNPSUqlSUKphY2yAn2NbyjZzwPc1uILN0eL1Ha4Xbk
         8WkXfGVtlBpYOaIsVjrB7YW9HmKi/GeeB1mhyY736IixU8GkYVzUdPcZQ3/MhaGa4ttN
         34NA==
X-Gm-Message-State: AJIora/gxMp1meM0u+LPFPguWhL3kSpNNLgzRCH/ILi4oUf0oPb0GZhT
        zXUEGcDjpTdurwQRvOvNoWlxu51KOlRaof79HH0=
X-Google-Smtp-Source: AGRyM1vpZWUryGmX2Syul7itFxBtSVf9Bo+1E+e4cMCDvNvC1ZOA3g+ku2VwXSI2ex+9FInLYj0tlEdTA3VdWCEE2Yo=
X-Received: by 2002:a0d:d7c7:0:b0:317:bfe8:4f2 with SMTP id
 z190-20020a0dd7c7000000b00317bfe804f2mr8125251ywd.276.1656558288801; Wed, 29
 Jun 2022 20:04:48 -0700 (PDT)
MIME-Version: 1.0
Reply-To: edmondpamela60@gmail.com
Sender: phillipcannon999@gmail.com
Received: by 2002:a05:7010:624a:b0:2e2:347a:d6db with HTTP; Wed, 29 Jun 2022
 20:04:48 -0700 (PDT)
From:   Pamela Edmond <edmondpamela60@gmail.com>
Date:   Thu, 30 Jun 2022 03:04:48 +0000
X-Google-Sender-Auth: EfWxCQMY5ip1C-wyzzzZ4ShODzs
Message-ID: <CAOyhKGOcx7bj+xtTnJfF+m-jji+qTCvuj0yCb2En7s0gsT3VtQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I seek your consent in this great opportunity.
