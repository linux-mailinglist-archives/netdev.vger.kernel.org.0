Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7046F0C6C
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 21:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjD0TRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 15:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244578AbjD0TRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 15:17:09 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587EA1BCC
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 12:17:08 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-958bb7731a9so1208955466b.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 12:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682623027; x=1685215027;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QzwkxqIKYA43IUd5e8fCs+e4L0IHL4Z8MF7QLmk4KQA=;
        b=s57I0ue3kPGI3mgBrjdijLAKvCYlErRsH+o5eBpchbQ4K/NveP5eoFyCakDOV7bXne
         1T1nsgLgVZtA9uX/ubONJtFrO0y+YUp+/WYvcktxZPDZvXciMCczItnvZI4I55URO/I9
         9vQ15OuZo5TWUHmz0dVeoBxe10L3J83a6j76Cb0e5Uwq/L839RMTyRJ7d2viRU2ZKNcY
         N9o6jGYcSAZ20xiNiP9E1EUJvpzZ7yqLmRU9Y9Xh4kL2fCFAyXZCp/t814uuvc+ts0cL
         wrUKZn/BjyhVsdYoC2GreB5WNrUb19/fLMNqvoW6k9kRPsIXQdlQfzDlAzCQ8BPKQi4p
         gMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682623027; x=1685215027;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QzwkxqIKYA43IUd5e8fCs+e4L0IHL4Z8MF7QLmk4KQA=;
        b=Fu/PMB0C7XOj83nOWOvmw+/nIGpUKidB2nrh4ALsM7e8gspbsvJSB14pCqsM9gp+UW
         2eSZ72xghqOdDLzuaqzIi31ZPxHIUmS3IG1ZkmrDi0gxHMpt/jGdUSZNsacjgj7EivK8
         ufBvpeQ7ihLxIUwKnyoOKoLQlqG43udPF4hcRGuwjYY4ddyjcpw3NPEmEZEZi4emzQcx
         TxiRJlC3XRSM4LhJ6jd0srRTW8ruEdv4uQGSJusNKSQLvWlET/w3urpFwzwU3DkxaUHq
         yqeJEiH8XHXZH2C1K5LtHldE/BbnvtL5ggNG1rKnAE6oukA7R3misuJBgCuSaYcheTUy
         Ofhg==
X-Gm-Message-State: AC+VfDzbHtIlI2Dbp3LVhWxGPEDrbrR0ehMzOzPlPx/OJTpetL9j1aMF
        BVxLvGPVKcT9Mjwlm2GhjWw6VG+TmerQwO3yHZQ=
X-Google-Smtp-Source: ACHHUZ5PnAuJrlk2aoE4s/XHTa+unsacjc38tNHfbTQdRmg8Rzt2VVALn9aETJFHo+L+Ggg1GkyPQg38aVtOhIdUZ2c=
X-Received: by 2002:a17:907:1b09:b0:94f:6627:22b5 with SMTP id
 mp9-20020a1709071b0900b0094f662722b5mr3053288ejc.47.1682623026787; Thu, 27
 Apr 2023 12:17:06 -0700 (PDT)
MIME-Version: 1.0
Sender: fadilaminumuhammad@gmail.com
Received: by 2002:a17:907:7204:b0:87e:f941:e1e1 with HTTP; Thu, 27 Apr 2023
 12:17:06 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher001@gmail.com>
Date:   Thu, 27 Apr 2023 13:17:06 -0600
X-Google-Sender-Auth: 6fjNywb2_OcQN0Iqqj7sTzF-U4M
Message-ID: <CANJEunCL4Xz0bfODWt7qWaoX2T3yKR3L+O+ho0Pxm3psLQrTUg@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_NAME_FM_MR_MRS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you

Best Regard

Mrs Margaret
