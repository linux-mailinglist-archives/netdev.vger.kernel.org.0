Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B354CCF12
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiCDHcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiCDHcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:32:11 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4951419141B
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 23:31:24 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id bc10so6737593qtb.5
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 23:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=vIF0HCtULT8/Hj4oEOKhM3wVM2dbK4vAQWbMA06NHEs=;
        b=A8s97aGXurgLri/VLXVjQQ+6H90uys1vFefw+GDhUFNUgj0ZKAM7D/CZqAQTv65Qpf
         h2X54nVb4//TLwMTzB71BGH3yfapsLMIYSpOfv5uY0KILnQuZWJ5oK4R1H67XOGoWo1G
         TAG8VyDaDNbRm3rFBtuyvvh/kFtNXDBgO96iw8nk+FxG9SsnXKkVaxhqOj9yVzOt7yTn
         xiyC57WBo3q2gztJ2qt12LpeKieDqgPkIWjDc2qgKlfintGWw0+9IqGCBGY7L2NIguJk
         zVeNFb0BqpaU6fsAfKyMlgLJq7mA91rB3CzhqpTzPbLjdBjKZOXY4GDkbuct6vDSGmXW
         L5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=vIF0HCtULT8/Hj4oEOKhM3wVM2dbK4vAQWbMA06NHEs=;
        b=Gi0mWFww/k5OaBu9YHhyyF85NoGoykmf677xqqZRcpQ/3bswshKjgNTMa1NU4K+Hhf
         ZgsF07ghuZcoJYr81x1Zscg7ZWJcyoBZLO4HtVwJ8QYepPUa3yxYyuF7qmEWiF/OE2ME
         iGXaklvaymeoaHMwfJ9Uqc2SflVd1pxVmHnaVl389alUH8frt55FtuFcamA1XRcIrm0y
         FOku9ZckLvZLEBjazpuZi0Go43KEkTO+ahBFn4N36TJbLLoIshk4eKP6bqDxkGL154QZ
         5Pt2D6kj/H6AUaxlZzPdA7yS621LutCtx5OcESIseQp3Yd3d1aqElDpQPg4WcAoFo554
         Gmsw==
X-Gm-Message-State: AOAM530AF6/KKVxF9VoEE8RTJlHFJ0BWBwYVQPdUjzHRYTlqzHgJclBd
        /EHeq2GHio7sX52bQaHk8cKGQqNq8kPJXCjgDXc=
X-Google-Smtp-Source: ABdhPJxL1ubGR8HAapuq6JPbp1H6IfxWDBnyIVSukBlBs/h3AcHs6Wu+tYYTk1szqogLhjdb6MFg79w7xrNH8/bWCPM=
X-Received: by 2002:ac8:5b56:0:b0:2cc:2dc9:9a89 with SMTP id
 n22-20020ac85b56000000b002cc2dc99a89mr30832785qtw.182.1646379083009; Thu, 03
 Mar 2022 23:31:23 -0800 (PST)
MIME-Version: 1.0
Reply-To: salkavar2@gmail.com
Sender: mrseedwards7@gmail.com
Received: by 2002:ad4:594f:0:0:0:0:0 with HTTP; Thu, 3 Mar 2022 23:31:22 -0800 (PST)
From:   "Mr.Sal kavar" <salkavar2@gmail.com>
Date:   Fri, 4 Mar 2022 08:31:22 +0100
X-Google-Sender-Auth: uDbWE1-8C7bKV4AnpCRg-JWoyqg
Message-ID: <CA+-WbAXRs0BNO7OaM5FN8F_9pKQRMhdA9hS6kXS4g5s9n17bcg@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FRAUD_8,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
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

Thus i humbly request your assistance to claim this fund. Upon the
transfer of this fund in your account, you will take 45% as your share
from the total fund, 10% will be shared to Charity Organizations in
both country and 45% will be for me.

Yours Faithful,
Mr.Sal Kavar.
