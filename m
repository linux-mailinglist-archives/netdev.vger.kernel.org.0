Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F766E2046
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjDNKIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDNKIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:08:01 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBE210DE
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 03:07:59 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id he13so15040649wmb.2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 03:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681466878; x=1684058878;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cIuacTUe55V68yxCoo7ary9vLzT4+1nPwynRvBBZauw=;
        b=UkOrd1RRTM25mxj1p5I5fnIrtj/ejTvq6ROpDCbeeILUAi7MHNax5/wKU8KmK0KdW9
         xz4+ysZ88t7IQaCEEwMoj5bKyzYGQNTHlOnZcIefKbRUoJoOvNAJ9CPtHh89Wixpvk4q
         dmUBpHEHMQo8tenvLQ25k/VryWvKrGchjyvAKDhMlN22hctXuz+pjSuhTyR9Kkh5xX8b
         CruamDbostVGlYJP4P/oT/fWU2HDNFWWFfU8VonJbmx86TGwP2Y4/smlskFVFXsepylP
         ZxxYUzg/niO2UuGRs8qbxB0qMmVeww9XNzR3UJ6vg6SFeZAKFcwetbyhSfCv3sl9i8dY
         RdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681466878; x=1684058878;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cIuacTUe55V68yxCoo7ary9vLzT4+1nPwynRvBBZauw=;
        b=NJrFUVd4+xNCC1mqTbxrKChalhrNpSUVXklQPfUN/LcwM48NHKaR18vU4pOUzmkWwV
         6SkHaw/yxqDpcNJBxcJO7sJbtyv96dVIGWjp38lqVLFQqYhLoaJ2mTWkeKfwQdTeGDNQ
         TJffhO7JqiiEcWae8jiSWFezjuJPiXkdepI4HQXWj2wQfaBZLotu5RHto6p6VHqfj/XF
         nbxIKq3Lxko5db5SHwJLyCtMlXl3Kz72HzSX0UUpyigB69r4GUEfyhvCBKkcytg+815A
         gt1t6HwPCL7prNkQnyz9LgsRjipUuN2xxMu/xGpKU9foSWBhm+lV5Zb1viC9RhZMlVNu
         JcKg==
X-Gm-Message-State: AAQBX9e4vX0sSIP9iODfp94trftomO8jdldLPq0L359Aa0fKX8eseCha
        AMYz9bDZdPd6gsXFgxlakaNso13EVA0640jEYTc=
X-Google-Smtp-Source: AKy350a2QgLxJtPIeeNlSPUDRhbft3OXkK0vR6wSxba9GLq+NCEtYk7PvXClj4+B5fszmqu3Rz7YNb5BFkub6Z/ZHiE=
X-Received: by 2002:a1c:7901:0:b0:3ee:41a8:729a with SMTP id
 l1-20020a1c7901000000b003ee41a8729amr1301800wme.4.1681466877682; Fri, 14 Apr
 2023 03:07:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:e4c9:0:b0:2e5:6bfb:b905 with HTTP; Fri, 14 Apr 2023
 03:07:57 -0700 (PDT)
Reply-To: sharharshalom@gmail.com
From:   Shahar shalom <kekererukayatoux@gmail.com>
Date:   Fri, 14 Apr 2023 10:07:57 +0000
Message-ID: <CAN5qXwFjDG9Bea9CmWkYfhAN4ex=iKqPrK3ZZMXO48Wu5jCn7Q@mail.gmail.com>
Subject: =?UTF-8?B?5YaN5Lya?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQrkuIrlkajmn5DkuKrml7blgJnlr4TkuobkuIDlsIHpgq7ku7bnu5nkvaDvvIzmnJ/mnJsN
CuaUtuWIsOS9oOeahOWbnuS/oe+8jOS9huS7pOaIkeaDiuiutueahOaYr+S9oOS7juadpeayoeac
iei0ueW/g+WbnuWkjeOAgg0K6K+35Zue5aSN6L+b5LiA5q2l55qE6Kej6YeK44CCDQoNCuiCg+eE
tu+8jA0K5rKZ5ZOI5bCU5bmz5a6JDQo=
