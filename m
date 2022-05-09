Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF9651F6C5
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiEIINV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237505AbiEIIAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:00:54 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239ED65C5
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:57:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so16314379pjb.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=u33bLPRdxARRGRPezs6qQuUbqXt0FX2OnInzgW6/Vb8=;
        b=G26OteOuvac6iw1qsXBsWFeecI0FVmkZIeJpK9URo2zdkC+Qi7Frf7pZT2dbdcMBDn
         W31eppIlcMiDpqA1ZaTW4xQ2p4y110HtUU3+eWijMinuhqsLlu0+krnUEr3Q5POCVoPv
         HpdL+/bKKvXE0evPl6eAeGsfDN/QhB9aWax96pAXaljLqAlXvURCHfPeWlSuLodsYKyT
         EgwYkLfUbpGDyuBrQTDBjYFC4GmZG3e90yLkVOElIJHq0sFeP/m0CYaQEfn8HC4atPRc
         DnsHpfftjjUKaGibqtVSnHuPz7kaRjRwPz/KjiHjVb7fcwV4OZsE0pTNxS66VglPv5ei
         Ionw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=u33bLPRdxARRGRPezs6qQuUbqXt0FX2OnInzgW6/Vb8=;
        b=f8h7EPbMDeRo7JHryac+SZDxndoltsMYfkztUAxDdzQbHW+nGrJjtaos6FAbZl4BBH
         9jMH8ZXgTp4DtSVPsUU5b3nZh1mnuW0gyYGuTN4KIMpW+Ub+fRj2aVgJHv/ln5DjyfY1
         LFLSwj6PXZaX25ozcVVVDfhgyEt6fvX92eQ+Nhntz3ruSkbVfoow6a+d4KCddPRtwoDS
         NpaRKd3AgvK/rcXFzw8CgZuNnUnq8KBy6C2UjcajRDzI9qANaoX1wRnzhC8YKJsmKCxS
         EYpUb4E3XQuQ2JHWwWUuTKecr33Mf+/fljKsKkfp1lQhFM13EvoU7fiNuykXRaFT7Q7G
         anng==
X-Gm-Message-State: AOAM533vJSPpF/pC9RsEP5HolylCTk6n+abbXFLBcQSgZon7q1yVSolp
        CPB+VhzgjGtjK48VTH7jaL9Dq3L+TTIVELfmfnU=
X-Google-Smtp-Source: ABdhPJyJSz279Fzyud34c41jv4RGiv+bQDjeLX56vKY+nVGMwizPrMqQyd2pNtQTp5+dRCdDaoToO9igFrUTAfVBNP8=
X-Received: by 2002:a17:902:b703:b0:15e:ea16:2c6e with SMTP id
 d3-20020a170902b70300b0015eea162c6emr15052052pls.100.1652082897952; Mon, 09
 May 2022 00:54:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: salkavar2@gmail.com
Sender: stedoni745@gmail.com
Received: by 2002:a05:7300:1484:b0:5c:e857:54d2 with HTTP; Mon, 9 May 2022
 00:54:56 -0700 (PDT)
From:   "Mr.Sal kavar" <salkavar2@gmail.com>
Date:   Mon, 9 May 2022 08:54:57 +0100
X-Google-Sender-Auth: HedZF1si37nTNfPOIivc8-TF9go
Message-ID: <CAAWQ0g4hC=ato6wXs+MukEjJ7SOML+sCX=pitcODSKMaiXOEpg@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_FM_MR_MRS,
        LOTS_OF_MONEY,MILLION_HUNDRED,MONEY_FRAUD_5,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1034 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [salkavar2[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [salkavar2[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [stedoni745[at]gmail.com]
        *  1.7 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        *  0.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  2.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I assume you and your family are in good health. I am the foreign
operations Manager

This being a wide world in which it can be difficult to make new
acquaintances and because it is virtually impossible to know who is
trustworthy and who can be believed, I have decided to repose
confidence in you after much fasting and prayer. It is only because of
this that I have decided to confide in you and to share with you this
confidential business.

overdue and unclaimed sum of $15.5m, (Fifteen Million Five Hundred
Thousand Dollars Only) when the account holder suddenly passed on he
left no beneficiary who would be entitled to the receipt of this fund.
For this reason, I have found it expedient to transfer this fund to a
trustworthy individual with capacity to act as foreign business
partner.

Yours Faithful,
Mr.Sal Kavar.
