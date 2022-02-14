Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9200F4B558E
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 17:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345126AbiBNQFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 11:05:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiBNQFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 11:05:30 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3648749277
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:05:20 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id bj24so3419263vkb.8
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=TPOJg3UTM77EsL7Vr73rSTLC+cVP1GCFfqHQ7KWs0Gk=;
        b=VFXSPcHR3H4aOped4oqwZAkWnbauojGuxly4RVSOGB/xkSq2gwb6wFrfqsTb/rEd09
         1J7IExoCsghgBYgUm2qF8Kum/STSPuyjy8WsjZcPE1QMvfm2fEVSIrwa+kdxsxAZd0Bg
         mjmEyYzQtmPpZ0d2J0ycOKukytK+GezDsp+fD5DuTpHJTOTl3hjx7rd/OqSEXk202lXU
         e2N4RhAes2FthGe4iCu9YqipDd/tw1MjIBlmahXq9/Yf4GXITaOHvH5R8MpkvgnM4E5/
         5GwB+4N79YnzhB0oR9KVRZJUTitpmkOA3d3mAfIgNnukuxUKMZuRv1loMhaySYpHiJsO
         tK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=TPOJg3UTM77EsL7Vr73rSTLC+cVP1GCFfqHQ7KWs0Gk=;
        b=zF/mgr23xg/Oq9cCRidUTxcWFL+QhxN8D0qy4ooCD8D4BboZ76Mnyr0JNCFzdFeLUw
         f11VJ1K6Wy2u75kaSSQaV2qluyNU4HSgLmbgWoKP+X5rwmVhSMF9Hz5To3Eahm/dMVGF
         g9b0h91mzn6E5+KtIlsyIkiLe2Dlh4NRJgM/3r5uzWWfP6d8Rua37P/9P/Ymdz27kzbS
         yrA4kcUcGGUKVKzAFmQHsxAeYQMTFBpqxccik7rDe7q0PjthghDX3YuhrHUmiiYVuf0x
         d/HpCRpkogjP1NCKOZArZ+Tw4VmHYMhMqWjf4fXrxu0PUZyFQRcQTlPF3hV9BSWXuWll
         6Tjg==
X-Gm-Message-State: AOAM532LnSfuZbTBonBj7nFSYz6GrcQDf41ho/RNy/3d53z3Zigrtx5z
        jzNJZ/BllC+8USUmJCvfMsa6pBhzrx5pPz0Vtm4=
X-Google-Smtp-Source: ABdhPJzdri9jMeViG7Lkgy06nUhNBv5nmQ4tC8I6o1EaDTXQNRi7IxT0iIIl8/d3VLlVFmifgrRP4Bqtx8YrghDByw4=
X-Received: by 2002:a05:6122:54e:: with SMTP id y14mr44474vko.39.1644854719285;
 Mon, 14 Feb 2022 08:05:19 -0800 (PST)
MIME-Version: 1.0
Sender: ibrakabora135.bib@gmail.com
Received: by 2002:a05:6102:23c1:0:0:0:0 with HTTP; Mon, 14 Feb 2022 08:05:18
 -0800 (PST)
From:   MRS EDITH BECK <edithbeck548@gmail.com>
Date:   Mon, 14 Feb 2022 08:05:18 -0800
X-Google-Sender-Auth: 1K4yrDCrCnKcVC_Zq7jNU0ehXD0
Message-ID: <CAPQQAPEBf4=3OiPxia6+wHHj_f3fLpaTbVXnk8x2FxqtrVJbVw@mail.gmail.com>
Subject: THIS FUND DONATION IS FOR CHARITY AND NEEDY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,UPPERCASE_75_100
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MY WARM GREETINGS,

 I AM MRS EDITH BECK, I DECIDED TO DONATE WHAT I HAVE TO YOU  FOR
INVESTMENT TOWARDS THE GOOD WORK OF CHARITY ORGANIZATION, AND ALSO  TO
HELP THE MOTHERLESS AND THE LESS PRIVILEGED ONES AND TO CARRY OUT A
CHARITABLE WORKS IN YOUR COUNTRY AND AROUND THE WORLD ON MY BEHALF.

 I AM DIAGNOSING OF THROAT CANCER, HOSPITALIZE FOR GOOD 2 YEARS AND
SOME MONTHS NOW AND QUITE OBVIOUS THAT I HAVE FEW DAYS TO LIVE, AND I
AM A WIDOW NO CHILD; I DECIDED TO WILL/DONATE THE SUM OF $5.8 MILLION
PRIVILEGE AND ALSO FORTH ASSISTANCE OF THE WIDOWS. AT THE MOMENT I
CANNOT TAKE ANY TELEPHONE CALLS RIGHT NOW DUE TO THE FACT THAT M
RELATIVES (THAT HAVE SQUANDERED THE FUNDS FOR THIS PURPOSE BEFORE) ARE
AROUND ME AND MY HEALTH STATUS ALSO. I HAVE ADJUSTED MY WILL AND MY
BANK IS AWARE.

 I HAVE WILLED THOSE PROPERTIES TO YOU BY QUOTING MY PERSONAL FILE
ROUTING AND ACCOUNT INFORMATION. AND I HAVE ALSO NOTIFIED THE BANK
THAT I AM WILLING THAT PROPERTIES TO YOU FOR A GOOD, EFFECTIVE AND
PRUDENT WORK. IT IS RIGHT TO SAY THAT I HAVE BEEN DIRECTED TO DO THIS
BY GOD. I WILL BE GOING IN FOR A SURGERY SOON AND I WANT TO MAKE SURE
THAT I MAKE THIS DONATION BEFORE UNDERGOING THIS SURGERY.

 I WILL NEED YOUR SUPPORT TO MAKE THIS DREAM COME THROUGH, COULD YOU
LET ME KNOW YOUR INTEREST TO ENABLE ME GIVE YOU FURTHER INFORMATION.
AND I HEREBY ADVICE TO CONTACT ME BY THIS EMAIL ADDRESS.

WAITING YOUR REPLY
MRS EDITH BECK
