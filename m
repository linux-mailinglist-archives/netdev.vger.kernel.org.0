Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9E04CE71C
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 21:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbiCEU5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 15:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiCEU5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 15:57:19 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D76E64BCF
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 12:56:18 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k5-20020a17090a3cc500b001befa0d3102so7645050pjd.1
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 12:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=B3GY5pHxl40fgyTRDEfHUIewqx+99afdPdvQA2cgGa0=;
        b=Ul1DeFOZmW3eIFJ32FIxFXueK6EqkR9q2CRk5Na8eX4rZT7yaC6xqY2IhWHvRuX3AH
         yoTdS+QI0eSRqerNNW9QSExvVh547i5bvNatPM3qS+GIfrc+R4FW1bGM+DamxS93fo9w
         PmXU+9Y3aUIG+8SIRsfZcC+W3exbxi10EycqUwe7Th9olfFX6bz3qpTBN0kDOGRNuoc0
         p8hq9RQGYmeXmXpe6XXejsC2BxEzRI86297q4BV2RZ/2lZKIFnseihlzV7RImmJKaYCg
         fh1/bLO7RQE073MgNsCmGUGh6HarVXbwvvztj1vMwiUX5Sl2zEsLCACRhHRvTk4Z8PTs
         Z91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=B3GY5pHxl40fgyTRDEfHUIewqx+99afdPdvQA2cgGa0=;
        b=Y8Egs3B97h9tkU4cR2oznA8N58jFo1vhHVqr2q4ikSqMzhEnFlpqnI198eyorGDnCC
         6FknqshQaMIHUBbIs0p7XKs6dL7IxghzpwH5WicVfPBoWgPkIi2QMlp+F5JHERap8IDv
         iobZqUQLLXPa/wraqtxxl6JMnffwnKVApdCspmBIbD5ZrA6AEyIoYlMRg18Tsf2+mXkb
         +gmj2PWpwUhWNpDVFOfXNVSfw2Z9kQnu7G12CifrWu76Pb/021qbe1hqyPU2VOVu1Wss
         Rfi2D94HavTr7mI0l8w1jdhfKyZre/89yjReo6d2N8PZeN3i/MGuBC1PzNhPOiicaVPH
         8+OA==
X-Gm-Message-State: AOAM532BYSTr8T935CNw3zTAFfFX8SARtQhQSCf7082KEaczCqqiZC7I
        dSuviGL/o8qkxSB0bHH39vxZaJlRsZMgEeQgdRWvcGUCXANqDg0i
X-Google-Smtp-Source: ABdhPJzC6V7S7/vmnS4sbC3SfbGo81mhRYnCpYIEFtSOyxw6+u3/WU0TCJDpc3AC9jOrnHJ5LXu8dPK+sxEDVM3cUlw=
X-Received: by 2002:a17:90b:3b50:b0:1bf:b9b:df59 with SMTP id
 ot16-20020a17090b3b5000b001bf0b9bdf59mr5351841pjb.11.1646513772435; Sat, 05
 Mar 2022 12:56:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a11:388:0:0:0:0 with HTTP; Sat, 5 Mar 2022 12:56:12
 -0800 (PST)
Reply-To: sgtkaylam28@gmail.com
From:   SgtKayla Manthey <kayladaviesu3004@gmail.com>
Date:   Sat, 5 Mar 2022 12:56:12 -0800
Message-ID: <CAD4g+Ji2_BM1vEhKy4pri3riTQ+r4u12d=7kN089EpE4MvjHWA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,
Please did you receive my previous message? Write me back
