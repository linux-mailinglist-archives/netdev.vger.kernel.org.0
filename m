Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB815FDCD8
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJMPIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJMPIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:08:41 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2F6108DE7
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:08:40 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id n74so2361379yba.11
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RZq7zJW68AsB2c8MQdTOdMV2RE0j/waEnaPxwlHywbM=;
        b=TzaRC7NKK77U/1F49MoVJGTb0V6GM8sflY9zu74O/MTSHPIeb9Jhurlw42RuunFxXN
         Vr1JQ534zYKXZG3cR0Z5aA3gkujjobESyic3MCBIXpsgO7lv6Idbyi3iaWw4vltOWHI8
         //glphKip1Ee9h4OdcULQaC/5gDwq8ZhvzB90jXwmZOW2HaOKb9Rafu6rvd3YF7ZabD+
         kxIYF527YfW/ewyiNOMaH1JCqUn3g05hK+qrGWXt0FvIwTHuLT5mSQ33AuxGqaNXCqIJ
         Rk3FB9J1nJpxo0dxvXQmYW8UZOeaz03ThTKlbHUHPKUiKF03YlTzjlnG2F6XZf3Teunp
         YlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RZq7zJW68AsB2c8MQdTOdMV2RE0j/waEnaPxwlHywbM=;
        b=SEPEHiKSSFkEeruh9czmIGu/rQP45zV8sfP8vQL0S8gKBNSI0gBbp8GErcOY8cNdQn
         6V6vUOpyLguoHlmUMg/NPGejn5Z8BXBTQ/K7jZPA186oBqTk5KaMjafQfzzdv3UfoGmh
         VbNR8J5ulH4ZyXBm6++z6dMc0HFoCnwv1xOTxdij3tBQjapk9ltWSTzf+FW/WRMtRH8N
         2On8n+uTopPHpdNIc5UVVjtP1kCIZimIVGQaq2wpYWE/V+YRz9i25dNnxfmovL8pK73h
         6dMtOKFYR5h12oRl2NOkUYPPVM3t/SdGrXuIvUtogE19yBYJl8M7g8RjIKLYoQGAJB77
         BAKg==
X-Gm-Message-State: ACrzQf0G4TRzeTllvZphWz84USmnMQ1xezKWemMeva7hoNQaTtTQdrxd
        O9wvFqhaZMzqTS+1fFk+xI/CcBO3BSepzJ9xcKU=
X-Google-Smtp-Source: AMsMyM7cKPsa31STE8/ufH3tAXwp/x4/+XEzdGJ6HtoEI1LEfzVu2n0PAM1P2os8HUY8hIzbXXJXL46Lm57R54YcWBU=
X-Received: by 2002:a25:b749:0:b0:68f:171f:96bd with SMTP id
 e9-20020a25b749000000b0068f171f96bdmr402776ybm.137.1665673719999; Thu, 13 Oct
 2022 08:08:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:438e:b0:306:7e00:edb3 with HTTP; Thu, 13 Oct 2022
 08:08:39 -0700 (PDT)
Reply-To: sgtkaylam28@gmail.com
From:   sgt kayla manthey <alazabode@gmail.com>
Date:   Thu, 13 Oct 2022 15:08:39 +0000
Message-ID: <CAD_BLtOuqDyiiL6E_C5mMQ_UT-iOcHrNXdghpQc6ONY24+CBXg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Greetings,
Please did you receive my previous message? write me back
