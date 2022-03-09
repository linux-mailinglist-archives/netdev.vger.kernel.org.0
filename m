Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680604D2A8D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 09:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiCIIXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 03:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiCIIXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 03:23:31 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74833C48
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 00:22:32 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id 25so1928637ljv.10
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 00:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=vIF0HCtULT8/Hj4oEOKhM3wVM2dbK4vAQWbMA06NHEs=;
        b=Rxo2xtof74d9INblB5BGghXhZu+LrOn774DLWiI17rXlsCNvR15Dpnz10ONozkK89L
         N3RnD+iEoFPnK8nK++BY3f/Kj6/gBJiJryhxt8BMOCgs9o7rYeebzzm+sZyOkOtaRhb3
         r+ew7livwOPt9uwWongw6FShWCrL0LoFJT3DafpEFOaJitgpsvw99PzbICdi8XlHxQrr
         6WNS5jnpGybSEqtLNYd3/xBvt/LhpH5uio74Rl9HJc8sKpp0L2uiVQrELKJP8RlTyrSs
         ljeI06BcWdPuU39ze2mqeG/ftsxuK2ekKHfIZ5OuGCo2DESM9UEOusgQSeDDY0d+ZXf4
         yb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=vIF0HCtULT8/Hj4oEOKhM3wVM2dbK4vAQWbMA06NHEs=;
        b=YlXGT+XjXaBow8va2pQMp8L/viZh+eMygVGX5apvfM3QTMMXscROrWH9vQIYQ9IHGS
         l4nwhRshZqwB1DqYoMhz/KP0iiE63RFhRrwXq4Dm4zwPpy383JftsUd+CYs1lkm+//nb
         WYVvKGMk/ib/uQv2jXDLDbraxIylVqwLrHfG9BF0vM9fQyPZrcALgBt51H2i7jRkjk4l
         ldjHUN6vcSNwjzIWKSE2tgSNZCuMHQ1XE+Cg4+XU6jBSrMQz2wO3RxzhCRpXNXyWURz2
         L6CBL6mr1x9BrvVyepO8AnLD6qVI7MNq9cR/GQTvc6F14+MMAc+hyBEj/iy5O9jlSn0q
         7T9A==
X-Gm-Message-State: AOAM532nVdSAodWVNnzevPCkkL4TmbTLC+d2IXf2jtNeHpMPOVLjxAS+
        gmdv6AudtpzS4rKtf7fuUuHvPKVEt2+PBJ6pXO4=
X-Google-Smtp-Source: ABdhPJwZet6naRndQB7M0ZauXNR0xoSQEVaK4EuMxZrwo2KocHHGoFuYzllhj/ac6lzHwdJ+Qgt3/FQ+xZHRkU2jle0=
X-Received: by 2002:a2e:bf1e:0:b0:246:7ace:e115 with SMTP id
 c30-20020a2ebf1e000000b002467acee115mr13562119ljr.189.1646814150551; Wed, 09
 Mar 2022 00:22:30 -0800 (PST)
MIME-Version: 1.0
Sender: winnerdonnna@gmail.com
Received: by 2002:ab3:70c9:0:0:0:0:0 with HTTP; Wed, 9 Mar 2022 00:22:29 -0800 (PST)
From:   "Mr.Sal kavar" <salkavar2@gmail.com>
Date:   Wed, 9 Mar 2022 09:22:29 +0100
X-Google-Sender-Auth: RwOnSwfn1MA-SVECxxz79qm0pZU
Message-ID: <CALP4u5VDv=uiA2dAtne37xEzJJ30icdqGyhegr21adxDSQkT4g@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_NAME_FM_MR_MRS,
        LOTS_OF_MONEY,MILLION_HUNDRED,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
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
