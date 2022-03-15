Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49E84DA05E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350189AbiCOQrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350187AbiCOQrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:47:14 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2301B57494
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:46:02 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id f38so38486508ybi.3
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=l1FoG/E1FVRaVMh/ZTwanbPCKUUYYti1WcRMg+Wr3Co=;
        b=G+6D/qjBdmgXY6+FfYyJ5iEcnvmJbVhDnxKYxo2qGSkfd+xSOJvF0tj9cLS9ADo9yF
         B8DwcHf9QjDVEdI/fkf4pu2ow6YRYBfAGC/l6GNdy0BBo8ov6UQDb8VEzrKisSannaZE
         Nwpbj5HYScX9apAsj1A0e/hSA+WFtiyb38Dlnj9sTxV2IFqhc8HTCAiXJxJpJ9Qu3J5H
         zoGk9bXif4oq0/ZK8T+qIxKJWv1lN6FJe/I099GveMt+8Z9TKK0CbNfbL5QY2O00p6se
         n2RKO3VdlHfM2AiTlnAScqaM5rUzEXmoAGIEWwghv8//ecwttHQWpH+xMmavhOFhI4Ev
         pABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=l1FoG/E1FVRaVMh/ZTwanbPCKUUYYti1WcRMg+Wr3Co=;
        b=RkupcmQza71/o6YtabeMHKK4+6HRW+RJu80pFlc+bbf5rjNxSz8Y3jNItKTdvPzGCc
         s3L6D6YGHOgJraQohxhmkC0xVaPIMiOFVofbzqIrA4hbK8uZWI4yl5cv+Iamx91h5v0z
         W2YENfFIBum7JyPyoRrvBAclF7/sarwxg4JpQY38ZdyOSE3xGx4FGY5PD32XmPvZiR7D
         BGTK+WHdNirhuBHI3GuBdXMF1PAY7vmquNuV0qyJ0fuUv9MGs1Fx9iAp6AV/SKWSURdm
         I8Ua0LZT8kzsRB4/aRzMU1xcSzpvNnuWY5F3hLVJA1I1paS/wHgByDPrmDaKmUTKwrvK
         XSVw==
X-Gm-Message-State: AOAM532FBz+N7Uw8n3cibbOBrcLKBvDrt8joZffnTPOb76I6mmSHWwtF
        rmsMu7HRa2y0AdN8sPkFkHgYDvNTEt1dF3uUX6Q=
X-Google-Smtp-Source: ABdhPJxx0h+AZ1wh2p1IhDKa70jQzGRsQQ2RtNB9emnWsoP7J9c/hNuxZH94XgPlG1wTBRTSbhDKfjC4+yySP/zaTeU=
X-Received: by 2002:a25:a0c5:0:b0:633:63da:5ead with SMTP id
 i5-20020a25a0c5000000b0063363da5eadmr7338774ybm.412.1647362761216; Tue, 15
 Mar 2022 09:46:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:c7:b0:170:4f0a:3fca with HTTP; Tue, 15 Mar 2022
 09:46:00 -0700 (PDT)
Reply-To: mrs.jenniferabas@gmail.com
From:   mrs jenniferabas <opendoorforme3@gmail.com>
Date:   Tue, 15 Mar 2022 09:46:00 -0700
Message-ID: <CAEGYdBDFhiq8KSt=aVs2v1WD1kEBBNFOazCCN9D=3MzvA9th3g@mail.gmail.com>
Subject: =?UTF-8?B?2YrZiNmFINis2YrYr9iM?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2YrZiNmFINis2YrYr9iMDQrYo9i52YTZhSDYo9mGINmH2LDZhyDYp9mE2LHYs9in2YTYqSDZgtiv
INij2YTYqtmC2Yog2KjZgyDYqNi02YPZhCDZhdiv2YfYtCDZhNmE2LrYp9mK2KkuINmI2YXYuSDY
sNmE2YMg2Iwg2YfYsNinINmB2YLYtw0K2K3Yp9is2KrZiiDYp9mE2YXZhNit2Kkg2YTYtNix2YrZ
gyDYo9is2YbYqNmKLiDYo9mI2K8g2KPZhiDYo9i52LHZgSDYudmGDQrYs9mK2YPZiNmGINmH2LDY
pyDYp9mE2KfZgtiq2LHYp9itDQrZhdmB2YrYryDZhNmC2KjZiNmE2YMuINij2K3Yqtin2Kwg2YXY
s9in2LnYr9iq2YMg2KfZhNmF2K7ZhNi12Kkg2YQNCtij2K/YsdmDINmF2LTYsdmI2LnZiiDYp9mE
2KXZhtiz2KfZhtmKLg0K2YTYs9mI2KEg2KfZhNit2Lgg2Iwg2KPZhtinINmF2LHZiti2INio2YXY
sdi2INi52LbYp9mEINmI2LnZhNmJINmI2LTZgyDYp9mE2YXZiNiqLiDYo9ix2YrYr9mDINij2YYg
2KrZhtmB2YIg2KfZhNmF2KfZhA0K2YXZitix2KfYq9mKINir2YTYp9ir2Kkg2YXZhNin2YrZitmG
INmI2YXYp9im2Kkg2YjYrtmF2LPZitmGINij2YTZgSDYr9mI2YTYp9ixINij2YXYsdmK2YPZig0K
KDPYjDE1MNiMMDAwLjAwINiv2YjZhNin2LHZi9inINij2YXYsdmK2YPZitmL2KcpINmE2YTYo9i5
2YXYp9mEINin2YTYrtmK2LHZitipINmB2Yog2KjZhNiv2YMg2LnZhtivINin2LPYqtmE2KfZhdmH
2KcNCtmF2KfZhC4g2LPZitmD2YjZhiDZhdmGINiv2YjYp9i52Yog2LPYsdmI2LHZiiDYo9mGINij
2YbZh9mKINmH2LDYpyDYp9mE2YXYtNix2YjYuSDZhdi52YMNCtmC2KjZhCDYo9mGINij2YXZiNiq
Lg0K2LPZitiq2YUg2KrYstmI2YrYr9mDINio2YXYstmK2K8g2YXZhiDYp9mE2YXYudmE2YjZhdin
2Kog2LnZhtivINin2YTYsdivINi52YTZiSDYp9mC2KrYsdin2K3Zii4NCtiz2YrZg9mI2YYg2YXZ
iNi22Lkg2KrZgtiv2YrYsSDYsdiv2YMg2KfZhNil2YrYrNin2KjZii4NCihtcnMuamVubmlmZXJh
YmFzQGdtYWlsLmNvbSkNCg0KDQrYo9iu2KrZg9iMDQrYp9mE2LPZitiv2Kkg2KzZitmG2YrZgdin
2LMg2LnYqNin2LMNCg==
