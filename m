Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C4C561529
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiF3Id7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiF3Id6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:33:58 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C511A382
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:33:57 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w193so25079211oie.5
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=nSwjXI9RLIO/9+kKkmmm1khzylH5gkgLY7cyCVJB7Bo=;
        b=KQ/F/JA8b/xtUWwqr6S8BiVk0IAQ8zTVFqgMbPM1xoX0f2yAkkuCFyysaBeoFNRpxY
         o3BxsnicrEEAMxNFztrMx7RWe1f8fJm3dz2MTTsvq70IPB5oB4YW7u6S8vhhutB5EDhM
         OGJw8MLV0Og4UxvBKCrW4wYR77raqxpEHjVaoZ50qjBO100YOG1fsnUEdsuPIBtZYpF0
         Agwq89i8EbXBPnilZvCZYORvC9BvamUULWYa87/rSWmmfY/DDeLgUunpuV7Wb69MAOWa
         PnnZcKKn1XIeSZqT/v7bBvUMCYOKTcoMxPObu9ejV8o8DmE8Q3usYu08FRQutTWSKZc6
         4V2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=nSwjXI9RLIO/9+kKkmmm1khzylH5gkgLY7cyCVJB7Bo=;
        b=BTCpYzFjmJz6B0PIwya+sV1GhP1/QOk46A2cy8WKBmuk5LIAk7fqTLDedZ8hL5Cl9M
         Txv7dGiUYDWED1iqPQTWKr5lri7N/q8/kEI3br1o1EMMT2QuQ9CUUZU5+Dz/1SSBiLSH
         5/Mg5MtfFjVN59yhtO2BXSWPe/BOVPtxRb5gKUxP/V5xM4YzG2MhTcoG/etQhxoudH0v
         eyRIs+8c3kU8s4WVzrSu9QUxMlEy7NLRnxHBaa8dRaAu9l4BkmMB9Av+NH4pENTJDqHu
         M521Qynn/APPeT9pHcH08PLUIz0as0GFUIG+ZyiczLKY24ecWj7i9177WMXqmmi1Cozp
         EyXg==
X-Gm-Message-State: AJIora+sGR15iLf3yteWqrbuO/gMs6cy749mEbbYEdeZyvhkFHJATNGK
        g5HkdWEW/BaIOuk6jpfVT9IjQU+qaMeJ2WKgedU=
X-Google-Smtp-Source: AGRyM1t38HzKOdGRUt3vqCE86nt1B80Es8PuPpZhwu+BEA+jz6iKv7KvxqnPcKPxHvGhVSvWzjiRCCZbdFYPEBNarvw=
X-Received: by 2002:a05:6808:1204:b0:325:7ce2:77f6 with SMTP id
 a4-20020a056808120400b003257ce277f6mr5846061oil.165.1656578036464; Thu, 30
 Jun 2022 01:33:56 -0700 (PDT)
MIME-Version: 1.0
Sender: engineerrichardh@gmail.com
Received: by 2002:a05:6838:a82a:0:0:0:0 with HTTP; Thu, 30 Jun 2022 01:33:56
 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Thu, 30 Jun 2022 10:33:56 +0200
X-Google-Sender-Auth: voqP4v-LEQY5mOoAaKNyNOdEHao
Message-ID: <CAKMkGm6ktwZyonJxg5M-JEsfqG0mk+FiT+WCyPDiGC9pj3dWxw@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

It is my pleasure to communicate with you, my names is Mrs.Sophia
Erick . I am diagnosed with ovarian cancer which my doctor have
confirmed that I have only some weeks to live so I have decided you
handover the sum of($ 11,000,000.00, Eleven Million Dollars)  I send
you this message because I want to make a donation to you for charity
purposes. I would like to donate funds for charity and investment
purposes to you which you must hasten up hence i will lose all i
labored on earth

Get back to me so I can send you more details about my fund.
Mrs.Sophia Erick
