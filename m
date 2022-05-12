Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51F524EEB
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354763AbiELN43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354799AbiELN4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:56:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DCE68F91
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:56:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso5002962pjg.0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=BKTUsOZXurokKw93pDZ/qCH4rd2yh1Ne8HUq4b8wchY=;
        b=qh7b7feyfcMWz/6/DqLn/0Qe85dfxTcsxJv2Ev8Qa+flLiQty+wFxE8Xkrhn9wvTQi
         8BmD3CcamGPeH2URq9zbMx85VDe/+JDDc1aGDF+VRaS5B6OKesNXwbWnkFvzKg/B4Kda
         +FcVKmDzN5qNMUOJbHyxhQ91H2UTwkzxJztSObNaaxPM348kpQuucV2R2+xE+jON9MzC
         z68BLscdY4Bw1iZWRpo/UoIC0pEcTrqicN11YWIttow/UUDvYoCOQCige40EsWjM75SD
         JXQ2aG2kVFNjV0oOv58wUowa15XElvYJbHdvmGwLR32dJJGFEaKj5wcra+Z3F+BX4eYW
         fmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=BKTUsOZXurokKw93pDZ/qCH4rd2yh1Ne8HUq4b8wchY=;
        b=R+7uGefTKhrw+oBtMXFduzquLhRh52nBiGIa3dV06cdCgBCjcPEeACS86awX/5iBmF
         qDkO1lRlHim1563h1CJXAM5vBmc1Sfu8uJaWX1rU1H70VikrRE15Mrnm/YTy+c2VscwP
         a0FyBpPAuGoG8QacFvxLmiYIMUxRFdIYXEqGeNYWFbQXfoYP7Fue37m5/6UCxvuvM2EB
         5mu4IoaW2nqHSdNUEM3TbeP5pYv18zQwxdQdhatzETbQ4+v3MO9a2q4rOe/bcQdrJLhL
         MCgFe1tiAODj6LzFcCrwrq5suOTKmrBI8cjtN7i8xfeMCZvfpVUHIIpsGe+IRwvAcbzR
         PDkA==
X-Gm-Message-State: AOAM530iajjJd3a/LRiS4ZJcTDYIVPRcPr1Mrf+WZwRHaJUpu8JxBElq
        A4d77G4zoG1bcmb8APlIEAZwoKtj+n3v6X4lYZM=
X-Google-Smtp-Source: ABdhPJz3B08ERMgvBUNTccjI0r2pvEVMzC31+ppaWQR3VpS+CR/heyBlPeG1ARgDWbmLQ2uunyHEo/NiwD7kPqYKa5M=
X-Received: by 2002:a17:903:40c3:b0:15e:9d4a:5d24 with SMTP id
 t3-20020a17090340c300b0015e9d4a5d24mr88037pld.77.1652363779017; Thu, 12 May
 2022 06:56:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:3e0c:b0:7f:499d:4df6 with HTTP; Thu, 12 May 2022
 06:56:18 -0700 (PDT)
Reply-To: musadosseh1@gmail.com
From:   David Randal <barr.musabame9@gmail.com>
Date:   Thu, 12 May 2022 15:56:18 +0200
Message-ID: <CACXnS-4=2ye-3VtPYkXQiaCL4onpJnMK5FT2mUVvEZnYp==Azw@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1035 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [barr.musabame9[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [barr.musabame9[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [musadosseh1[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My name is DAVID Randal from africa construction equipment operator I
want you to work with me as an overseas partner to do business GOLD.
If you are interested answer me.

Ms.David
