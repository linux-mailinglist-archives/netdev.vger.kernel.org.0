Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CF94C0112
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiBVSPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiBVSPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:15:44 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95E81728A5
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:15:18 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i11so37251924eda.9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=kNGXZsmGpqnHiykoKGX/IVm8clsDWOdGnrsEFmWjOqk=;
        b=ao0bZzKFoVsndIvk2eg6+8nViQBOrTknI0grDiwPsCjF6lQ9CjZjMQI1rFQro8jg1s
         FYJx6+rbfOCSQpkNBjXxtcV4Gv0JcEp05/eIHGOv5jJqo34nBCJSoqot4EwIK3Y1LFU4
         L5l0tAn42OcJOCAZfVmHAYtcpuiHRv+zaMR11+wRLcU5gC8siIIhogHCuVsIolQLlJnb
         G05ztDdKQ6QxIWyquUmCLMOIR5/I51DajPflBC+AUxPEuHURu2x/asTVl/19Kbn/yJHt
         wLBMmZoKIDNcmHbzIwDxuQPteEwTUjgwE+M6Wha6rwhjxctuReH71uR3AxowCAYDobB9
         pfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=kNGXZsmGpqnHiykoKGX/IVm8clsDWOdGnrsEFmWjOqk=;
        b=xxPViBT625y+VsE5lkCR4/3g3giw5TTou0KzMNyzf5Y2ONi8sA2KuYu4PFLHtZtBBI
         cJcRpjrayLgKzfMC+U7zW9UbUyAvv/r+ux3ishAIY0JX4aau3eeq3SPzBJ7nnE52atak
         EqWsc3lUWZehkLCtlzovIz5QTSyO9sPc0Q4ajVk+05Gu153b+XJFstjOh4tX/5l4UQGo
         uvCjboQuCz0ouxj7kI1G1e4qY6HBpObnTpawR1LTrbEWpZmV8qrpQa75B2u88Ondnivb
         5+slfaapPwUFq3R3gPpFwjr0YQY3Ub6chcrc7qmVf/Ywt45JFC6zIDZFzFCRMoE1DR7n
         T3CQ==
X-Gm-Message-State: AOAM532e2mD5QC6t0l2gfhRRgCCRQxb21jwTumhP/OU2mPwq79UnZWSY
        J+Wwx9bRLQzKA1ThpXiW4pTTvOT0AFZXyk78Ftk=
X-Google-Smtp-Source: ABdhPJx8bIvuJxCLdkBNOYbCroILkZ188kGYYWleZB1AHzQCQJrDpNPCjVLE/iQ/iFzGV9OACeoiziJAGb/Enl0MdY8=
X-Received: by 2002:a05:6402:34d4:b0:412:b228:868b with SMTP id
 w20-20020a05640234d400b00412b228868bmr26194878edc.444.1645553717273; Tue, 22
 Feb 2022 10:15:17 -0800 (PST)
MIME-Version: 1.0
Sender: julianterry39@gmail.com
Received: by 2002:a54:2346:0:0:0:0:0 with HTTP; Tue, 22 Feb 2022 10:15:16
 -0800 (PST)
From:   "Mrs. Latifa Rassim Mohamad" <rassimlatifa400@gmail.com>
Date:   Tue, 22 Feb 2022 10:15:16 -0800
X-Google-Sender-Auth: lQWQ33Leyof1j0SIMtsPs_mcMTU
Message-ID: <CA+Kqa7fmGi93w7aim4OQc7=najKa=y_bVpL+voezp_27NaGjbA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.5 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good evening from here this evening my dear, how are you doing today?
My name is Mrs.  Latifa Rassim Mohamad from Saudi Arabia, I have
something very important and serious i will like to discuss with you
privately, so i hope this is your private email?

Mrs. Latifa Rassim Mohamad.
