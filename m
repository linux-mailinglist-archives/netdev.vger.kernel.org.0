Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5D558BA9F
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 13:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiHGLNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 07:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiHGLN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 07:13:28 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B05766A
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 04:13:28 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-31e7ca45091so57959317b3.3
        for <netdev@vger.kernel.org>; Sun, 07 Aug 2022 04:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=XU2MHWoFLDfGPN4FYAXpMsyIqAjE5G2Pbwuqeg9eIDaMcja7s7MX8itKVdIZefVnko
         t63sx68OD60ChUzzLBxZPTnTp6qR+Zn39RQgIr97SCH0t0X8lbtkQK0iDI535QqVwjod
         Jz9FAD3OLaOcsG7ZFtytztWmdxuQSrHowESit67gM4Tx4eS3EG7HKz0ilHFSRe4Fqo+s
         oRUNt1vyFhogzS4zEbBsLHSi2so+Y0iGjKWXgcCnjequJlegEld7QpOQqitAr2to2eVH
         ghYP1Ht9euXs5G4Fha0N0dfZFprvcKLNpQGieNa5iIIJwHUcxXHtp/2pbul8b11D1W+S
         L4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=gzJA/k0dRAiMrtcj+iDSnrc7iXrw3aZBfnNWll+TQnb1PakR+PCPywRWszbKTa0PRR
         eJSsMHXJQiPTS3rkCsOUJjIKjKZVI0E//Hraw8XDmdSep993LLXxjkmAAyFgn0Su7UFA
         95L2iLAm9xwb3StFuOv6dUCPuBxYoVnhClWjiAsa0TeZTRr2fn3e2uFHLjKP9Wy4Vk2k
         UMAruZzfX+SIFlxRTiCQ7QGp7BE6ud7b5IdKwaagAmNW7yFYD062uotO0HItube6FPgf
         HQLhA8CYw3Ute3Hkq8hnpjSUOk+6GUqpqyxwOtl1OfJGP2/CbbQVAB2r7Df/2TBJcy7C
         Tj+w==
X-Gm-Message-State: ACgBeo3icYBFQXCsPCKDnG5OIdUVn9i4yye/l+gJx7XNSI9qCfOEm+fn
        In+VKpoSDgldoe9zBYlZJPEdTdKg7pNcgN1n/Cs=
X-Google-Smtp-Source: AA6agR4164oQKV0pB4LpXtrHv+TZ8g6SDLzl4t1LodJPiH7BCs57bUtPPN30sYPMq2Lo5f2AF5z0CRFhrA2QFMdnfg0=
X-Received: by 2002:a81:b142:0:b0:31f:ba7c:5b56 with SMTP id
 p63-20020a81b142000000b0031fba7c5b56mr13587461ywh.390.1659870807060; Sun, 07
 Aug 2022 04:13:27 -0700 (PDT)
MIME-Version: 1.0
Sender: ganamenoufou00@gmail.com
Received: by 2002:a05:7010:1625:b0:2ec:af6f:71dc with HTTP; Sun, 7 Aug 2022
 04:13:26 -0700 (PDT)
From:   Lisa Williams <lw23675851@gmail.com>
Date:   Sun, 7 Aug 2022 12:13:26 +0100
X-Google-Sender-Auth: 6JmGm7RXVdSD2q-qNUDgaEIVHqU
Message-ID: <CAEL6NB++7TsaWd+mMbhhn--oG6xfVabepu6QVfuFTuJjP7rUGA@mail.gmail.com>
Subject: My name is Dr Lisa Williams
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dear,

My name is Dr Lisa Williams from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lisa
