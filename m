Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3389464C770
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbiLNKwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbiLNKwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:52:01 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505DB1C40A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:52:00 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id f16so6243468ljc.8
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/YQmPfaNN2xvCaGQ4ZNNpbl3kHI7ba/jcD2wLQvQQJU=;
        b=eG1lqMH3jtdZSNepZOXPSZYNCQ0YRDgU6DGMwzYYvma62/QdibSd2QVEVW3iyJCAhA
         mMEmg7GJIaRKKrZlAZdY0VFVYFjRC8/VjL2fZIDA1eVZm84hFQgbY6T+VWYacyFifrJ4
         2b5/TauIYzN/pF24v/Arm/p4QQy6szCEqzuRd4rXPRuqVUsX7GvNL3OEmyPa+YHG0eT2
         37DBoaPGGMph6WLbgyrlBVkHh5jMUmCwcd/s8KSrWEYvu2D1/hMnEMsXHeKmYnjrpTGM
         tRSC+/3HV/Y53xyCM63Dnnh9J80eHITIl7/ox+GasGstfzOd8g9t+/PNSKJNwCY6yTMD
         mqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/YQmPfaNN2xvCaGQ4ZNNpbl3kHI7ba/jcD2wLQvQQJU=;
        b=GNpk+4WYnCPgO8w4MgrFMBXEPyaVHlug3qPS3iiY2z6jgAW3c7HvYRvV2kQcBt8hOv
         6rEZFOcMfNz/zBSvoJaQUIOSPfSI2i4cnWpWafSeta5za5gNWMOUToH/bgbXMNiQ66EC
         N+9epd6nrcOzYmW6GGv3FJEFNads6vI4fJpnx37gCgU0L9guh2J2SmJIVPIIerp6iB5G
         NubFbqTZ6ug5cag5mt8+WxPE336N0lIVrtHPOlSgX3YOLyJ6gmlkwQSDfHdP4XNmX5KX
         hlu5VzcCs154RKgnF0SaZ/54iqOWM39VLOCo5d48ikg6lbSSUN3z/UWDdOur0HyRCepj
         GGTA==
X-Gm-Message-State: ANoB5pnshWrrvy2KxMQ7pbbmdVI7yNsdjAkpal8xf08J8nwjjhuO7LgX
        4Vo5DXYQY3zLMKrCK3xaWkoMWce/iP1y6xrZFBA=
X-Google-Smtp-Source: AA0mqf6Mr6vGcUOme9R9woDycsAMS2RVq669W8gEwwtzoSuknlL1CdEkaH0DFkuS8Gut2N3tkC+FYMML1mcrxLQtt8A=
X-Received: by 2002:a05:651c:1074:b0:279:d60:ee7c with SMTP id
 y20-20020a05651c107400b002790d60ee7cmr28350448ljm.305.1671015118450; Wed, 14
 Dec 2022 02:51:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:b888:0:0:0:0:0 with HTTP; Wed, 14 Dec 2022 02:51:57
 -0800 (PST)
From:   M Cheickna Toure <metraoretk1@gmail.com>
Date:   Wed, 14 Dec 2022 10:51:57 +0000
Message-ID: <CAMJ9kautPPpwpqLN-RgO0HvZFe_qM=kHSnp8shKT8zG428ZREg@mail.gmail.com>
Subject: Hello, Good morning
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
Good morning and how are you?
I have an important and favourable information/ proposal which might
interest you,
I will detail you as soon as I hear from you, it's important
Sincerely,
M.Cheickna
tourecheickna@consultant.com
