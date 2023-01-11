Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A346B666312
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbjAKSwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238088AbjAKSwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:32 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9D13630D
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:31 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cx21-20020a17090afd9500b00228f2ecc6dbso741611pjb.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CTi3L9lTWxBef3pG4TT3BX1YM1HI21Ia1Q1MD2uQM4=;
        b=7Vk4NNRGjsKgkeH05OJQTuSOV+WFX1P6mgpbkArw9r6AqX7wfRfO4ibaRgT626oP4Y
         ca+mqudS+F88sX3z4pHmWZh0eE9PEgpuchKIZz0ASMgXemG/O8SyAsWIYjVzmkg83xPB
         fn0LE4w6zwJAsut2is4rLD5Mgz5DEKE9THIZJozfAOJ0ahxRUA+2IXfggM7eyrLnoGaR
         95JKgSzz7zT+050qdG+PXV8X+Dt/KWGrWS24+P0doDIQiATmSKZLViuppjvZmuDkRXOR
         8HyLWfIHDM39wEHtN0JWAKN/QlkpEvcD3dcD39htcAm986Tp1az67zWPbZt17byN1MzP
         jByQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5CTi3L9lTWxBef3pG4TT3BX1YM1HI21Ia1Q1MD2uQM4=;
        b=Z+KWSGcymfdkyRPwJD6ygC5tdo0PPqgR13JApixsJ9QeRX4wiTk1hU8MzLMGFjeIQf
         +XUhH7mhQRgtB9aMwS+oTVxnWNq2IcE73EUe6o9xf8Xx0ifFYP7UupEPM0FzgeFsx5yr
         TTxS254EYREPzJggdM5V2wWm8dvwQTzgpfv/UzQJLhkYNhdxFE0/O2yWmEZCcCK/kr9d
         GZW1ZSBe8eDR1ksrbNqintxILK2cnUdw8wsWhSL3SCbjpegQTGsAe7O46WVhdiQOStTG
         2LQYWScBTSBhtzngR/3CZ45flMgDzN5JaJTZJhhAy2Ht/e5ng2C5ZWjQzhOB5yuoOz2+
         ewVg==
X-Gm-Message-State: AFqh2krSRCREcMatgbWEs4LkHGiRLu05AskE6CaFmc7kUXafmynq71vj
        sZsTetMHPmw3Sr0XNdMqYDOQyAKYm4a0wa3AwSs=
X-Google-Smtp-Source: AMrXdXsL+jKqe943VPDj9g8A3oD53Mjp8PJ/ZuOB6zYEvHs3n0aGSZRRJ0zZRc91G2nJ2lcMdPUp9w==
X-Received: by 2002:a05:6a20:4ca1:b0:af:f80a:140f with SMTP id fq33-20020a056a204ca100b000aff80a140fmr73161464pzb.8.1673463150578;
        Wed, 11 Jan 2023 10:52:30 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:29 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 01/11] bridge: use SPDX
Date:   Wed, 11 Jan 2023 10:52:17 -0800
Message-Id: <20230111185227.69093-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111185227.69093-1-stephen@networkplumber.org>
References: <20230111185227.69093-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace GPL 2.0 or later boilerplate text.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 bridge/monitor.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/bridge/monitor.c b/bridge/monitor.c
index d82f45cc02d1..552614d79902 100644
--- a/bridge/monitor.c
+++ b/bridge/monitor.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * brmonitor.c		"bridge monitor"
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Stephen Hemminger <shemminger@vyatta.com>
- *
  */
 
 #include <stdio.h>
-- 
2.39.0

