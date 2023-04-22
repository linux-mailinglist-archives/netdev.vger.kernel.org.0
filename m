Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30306EBAD0
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 19:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDVR7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 13:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVR7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 13:59:37 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49131725
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 10:59:36 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4edcc885d8fso3066953e87.1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 10:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682186375; x=1684778375;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ud2Qp+0j+JXG+xzOTKtAs0iVLtO4HhzSJ3v0hgygifc=;
        b=Ho5ffRtgrumMQEiD5Gj7X96pkf7jmfejxieHDRs8X6ciqb5EFESCR9rC2ZTKZnka4w
         zAq7K5n0IPeCxRYobNqPQzctsvaWvRfqr9E/gHistMZ1DXkOhbtp1uJRFMVqc1D0mJkt
         JhJE40loy8sQEmmR73LzRF+ROF2e2silZTxK4+dVe/GAvgnOVYnctIDe5oJcNr+dpFEM
         8VRqbPlGzR3n71ZNNlMV8MFe8PyJKR37JzYNicSTGBIIop2bm0rirxDQ75mhHSW3zTlQ
         b6uTKHfQgKpmUpOy0pPJvSfKK68rxhKyxpY2aI+te8wwBh3jhoC1ALkQ+dDC0HdpV9AT
         sOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682186375; x=1684778375;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ud2Qp+0j+JXG+xzOTKtAs0iVLtO4HhzSJ3v0hgygifc=;
        b=UlN8OQsWUPPsCtC0npcS5dRpSLU+MIREW22ToFCFyiombsI+JXFoCv98m3j9kx3x3j
         fAaPxyA2JDqQtV6EgQixR4AGMZvuJBDF2fTJNOQoOrLYbQ2KWQcT4BQ9pemwPQP+gH3o
         xlJsOzS/2ELFHgwC8eQ9dyiT/dxpt8jNCmSFvGTZToKYG8BoPqBVyS+5YxQ5hjNdV7MK
         zCm/8xXXieipIeU7Co9ef4lfS9jLdkqS2n0f0cmmRIJ5PKmUO4gZxKBu05uafK8R3+wQ
         +vdzcIuhPwKYunKf9vUP5SsluTKK8tTd4FOA2DLz3ht5FRl+hUS8WlzpfwG1tfE2PGtR
         eSvw==
X-Gm-Message-State: AAQBX9ejBUnh0xvPHMj5Ky9rPDreyBWgYT/puzmUXnSZPv+VZBLZw74K
        ntdafBEr5t70eUDAU3uk14ZRoQweOmH5zg5y1j4=
X-Google-Smtp-Source: AKy350Y8QVLee0g+OaXal/sS+O1sKc4S/7JBhJVgpl0alwdt7R12D5j/IUpxFUaUSb3PhCx5W07odD1o0cSUnn6BZ4k=
X-Received: by 2002:a05:6402:3ca:b0:506:8da7:fab7 with SMTP id
 t10-20020a05640203ca00b005068da7fab7mr7759899edw.10.1682185917565; Sat, 22
 Apr 2023 10:51:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:2012:0:b0:20b:da13:9ec7 with HTTP; Sat, 22 Apr 2023
 10:51:56 -0700 (PDT)
Reply-To: akiraharuto@yahoo.com
From:   Abd-Jafaari Maddah <dongy7442@gmail.com>
Date:   Sat, 22 Apr 2023 10:51:56 -0700
Message-ID: <CAGnEuTvjzLi61+HVQ+6UT=YaJ44NLsrBqExtdJ39R2FPPK0zJg@mail.gmail.com>
Subject: Did you get my mail
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear,
I had sent you a mail but i don't think you received it that's why am
writing you again.It is important you get back to me as soon as you can.
Am waiting,
Abd-Jafaari Maddah
