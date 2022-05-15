Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A902D52771C
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 12:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbiEOKn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 06:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbiEOKnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 06:43:21 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D30B1FA
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 03:43:19 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id v65so15344384oig.10
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 03:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=NLijoYwk7hqoA8TsUJbQbQCYzScrvalH7Lc8MykkZrA=;
        b=ch8fFB/zJGYfbLcNujFzkoQ91CwMiZfii47GZKPhkF0pN65KcWvS0pu7m1Vse6OMQf
         rlY9gb6TLnX0QdB+gORz7NLSW2vdPcvCg7cLnR1iJV6U20jGBhAHDRIfihsd5HGa2M9Y
         FQTpRjIp20hYlO1iGEY5RsR3UcMAHN18H3KVKV56t6m/qbalt9bBTZvkeuawXa2pRjpT
         KEWuHCMxcMB3ai8PhWQ9jEjcsI1vJcLpQISRyVeQqPA78SG9g21IqleO9ixXrW1ube6u
         DRGPHWESLQNWtG5i8satQrfqjOIpdlfy4wLindKXTaC/EZhOukXArC7ChmJuopLboN+h
         616Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=NLijoYwk7hqoA8TsUJbQbQCYzScrvalH7Lc8MykkZrA=;
        b=EAzN1bVfZ0nzvlPWgcp2fC000FDkxgOKva7Sfa/4giiqJaCjMD/DzvMQOWATBZdRSI
         p1HRMwpt5/Ph1k5poy/eU2ZXcD7r/4ZYVHQdbhmvu26zW0hyewWaZsUMaHpnDhpEt0N6
         agMsI8OVUjaLbrNNAudh2hdEW3W1yL4n8xPagIwWXk3OKBNMgc9rzU7pKi60TYCJcjJe
         QnLhUv+ZgSc5Pm8RSxPIm/R/L4zpZPkU5xwcnLi5QeMypAgx/GYVrHEPzOj+HwZMYZt5
         kh3+5bt0kU6+61z8eVtIXrtjLN7DYZLPiWNydu+3qRs40dtXAWX2/RhkRDHE8iSGNYcn
         7Ftw==
X-Gm-Message-State: AOAM530W7RZqrfm/aKfRDQOZ309d+ej3G5unmmvMCP9o446zSsD79Ews
        /6lWHiCF5khoC9lMDJ/cfcKIDSGnaylSsOYlxlw=
X-Google-Smtp-Source: ABdhPJzm0r4foQb1J0vHkIXw6spzW+CPsV31CHta8zvKPwmh0c5K3LnvZahRWfiM4w60dQEg58lO6JapbVcM/xTtVxU=
X-Received: by 2002:a05:6808:120d:b0:2f9:27da:9255 with SMTP id
 a13-20020a056808120d00b002f927da9255mr5871029oil.43.1652611398459; Sun, 15
 May 2022 03:43:18 -0700 (PDT)
MIME-Version: 1.0
Reply-To: salkavar2@gmail.com
Sender: mrs.shirleysisme@gmail.com
Received: by 2002:a05:6820:812:0:0:0:0 with HTTP; Sun, 15 May 2022 03:43:18
 -0700 (PDT)
From:   "Mr.Sal kavar" <salkavar2@gmail.com>
Date:   Sun, 15 May 2022 11:43:18 +0100
X-Google-Sender-Auth: 3O6Jz5zk_ahRHupiI55tJzK_jhc
Message-ID: <CACwG4eT+tKf_4ToOFqvw5gUZfLOjTMLGR-WQCuQQ=rgH+0jGoA@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_FM_MR_MRS,LOTS_OF_MONEY,
        MILLION_HUNDRED,MONEY_FRAUD_5,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:241 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [salkavar2[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [salkavar2[at]gmail.com]
        *  1.6 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  1.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I assume you and your family are in good health. I am the foreign
operations Manager

This being a wide world in which it can be difficult to make new
acquaintances and because it is virtually impossible to know who is
trustworthy and who can be believed, i have decided to repose
confidence in you after much fasting and prayer. It is only because of
this that I have decided to confide in you and to share with you this
confidential business.

overdue and unclaimed sum of $15.5m, (Fifteen Million Five Hundred
Thousand Dollars Only) when the account holder suddenly passed on, he
left no beneficiary who would be entitled to the receipt of this fund.
For this reason, I have found it expedient to transfer this fund to a
trustworthy individual with capacity to act as foreign business
partner.

You will take 45%  10% will be shared to Charity in both country and
45% will be for me.

Yours Faithful,
Mr.Sal Kavar.
