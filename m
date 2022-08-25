Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A0E5A12AC
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240724AbiHYNtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiHYNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:48:58 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A4332EF3
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 06:48:56 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id z14so748548uam.10
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 06:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=OhrrxA0+VtUH2OMYp4JdnIujQjBusCdPTL4Hk4sQ+XM=;
        b=ofdC1R+2HA5CQfpn6C8l66l4835MJ0Mm+81pOfUfTNxGAgINl1WwOa1APToEfPoK95
         bWYNxi1enmUYQ8FryVKN5i0jURufURD+NfJ5ItvflLiW/3lerCGK35twKwRkAmmezr+w
         BOj3OLSGZq1CoxTPsAla1Y28GH+uujC5aJknJFtlfhn0Mj/0iRhZvmrZyFClsgE68Zu2
         yBpE5/MreUmuIap05MOwQKy5A3LiN11X0VW8SQD1yGyzXNgCFn26mHnSCyceraR9fDWW
         DyYm6IVrsbu28sguGo7xnZrULYD3A2ufN+v5CTsN1qvVHFzkSigWlyGbcCL6t6ZuJjo3
         RDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=OhrrxA0+VtUH2OMYp4JdnIujQjBusCdPTL4Hk4sQ+XM=;
        b=N0ttyfeHxYSylJ6N9Iptk7vX/OKTBxYhI8kdYvvECoYNwbS8/mE2C649tuTwll5RIA
         NIaB3Vh6PKRFcep8w9kDxzOs/XI4Ng0mhPE6Pxkt09FZ6+pTD1ln/8OgmoERJJJtz2jb
         mZrGi84iPRffsa/F1qVsYvBfM9Mcq/Uq9xJqH6WFaYUur4Mgx7gvl+QcHgLTLYKrESfx
         Ri0bhkUPNjgC8D+UJ9+0kNW2/D52VtnvxXMX0+z9TzT53YwSKe4E2zDYBIlR7LZ53tL2
         H94DnXp+7hqsA0bS4cUCoZf2AQPd2Q4HTWw8Tp+njjfF19qF78BhlEdfs1S2a1pd/bvZ
         37VA==
X-Gm-Message-State: ACgBeo23TFE4Syszln9Z8i/ausRPaqzhcJb8KcdaWPzs1icI+7/ghCCg
        CxGIfvzwcYHIkXP5m8WgCLvqzI9PhnkHTazTc7U=
X-Google-Smtp-Source: AA6agR4V0aSr/c8VICIr/hfSRyYNyavsGd9v844JviYbypchV8Tq+iFclSvsCOG5dG7upn5WCDJhgxqrE9ev+S8C/1w=
X-Received: by 2002:ab0:5b8a:0:b0:39e:daa5:84a3 with SMTP id
 y10-20020ab05b8a000000b0039edaa584a3mr1401097uae.99.1661435336008; Thu, 25
 Aug 2022 06:48:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:dd84:0:b0:2da:1bbe:5176 with HTTP; Thu, 25 Aug 2022
 06:48:55 -0700 (PDT)
Reply-To: franca.rose3@yahoo.com
From:   Franca Rose <roseharri3@gmail.com>
Date:   Thu, 25 Aug 2022 13:48:55 +0000
Message-ID: <CAGs5tX6UoV6NJCysFEZ=eFMFs5z3S7XAZ88DQBw5knGaoJUyvg@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4964]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:92c listed in]
        [list.dnswl.org]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [roseharri3[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [roseharri3[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [franca.rose3[at]yahoo.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

i am trying to reach you hope this message get to
you.from Franca Rose
