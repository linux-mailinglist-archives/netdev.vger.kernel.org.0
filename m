Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90522665235
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjAKDRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjAKDRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:18 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3CD12AFF
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:16 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jl4so15363949plb.8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CTi3L9lTWxBef3pG4TT3BX1YM1HI21Ia1Q1MD2uQM4=;
        b=tWzEdFJ/djXBRCrXxfJLk9Qkx42AYUEZV0IXiNhTLyJsFfGVT1wunrzzguJBxQbpxu
         53Q21Dhmd0jFxXI46AkfZSwhl/Due/nPJT4/AhNqdJIahhnO1qhEi2yA3RcA7aN7gfss
         GMGVqAMDgFOsW0ir8YOIOYSz8pE4UUrlZIRujo8T3zcNPvYyVOKkPw6CXafCabaO7yr/
         laXeshiT80BjOh/92hq+GQeLjQeVNwlCVzS+CyYK0VQgYv9mjFRNbROjfAAk2lvWvAnX
         b+T9GjaTz1StfN2id7GHA26DGstzoKIaxMy/UAZxaMqedOKGYtmd+sYIPGgcuBogd7BB
         /nHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5CTi3L9lTWxBef3pG4TT3BX1YM1HI21Ia1Q1MD2uQM4=;
        b=igj+qaOSVoHTbsWiPFnV5959LX4tOVSvAKIgyzE507PUQOQTWOTuGrLZqcRE7PqKK2
         Q1rKZCfdnqdMdqAREn32jWtDUMsVLEejd+JGtu22Jzwmd8zagbriKK7DJGMJwd89gIjd
         AC+C4eiWJnnqku2ukThukajbja33f/RVxLw1bacGKgqv93GiVXyCt/RXRO1q25BGj6t6
         y22ma1Z5RD4/VG6Pn6oSuB8dX39qqZpmlXNSxay+QrE1Si1XL2P7o26oNIZVEMAkWXv+
         8KOOJE2ypoRT6rY0oBqJ9Z/uptz/r1zPTwNH+c2IzmJpPG4tkGU5rl3gYrFGM+ONila8
         oyNQ==
X-Gm-Message-State: AFqh2kqFRNeU38YUTa9Ze1kMjDvF0cNP15mC28tOacnMxKMzHYGIkLzN
        uVZv5MJfqPvv3UXifurwR0k6OcUy3wSrkk6+PoA=
X-Google-Smtp-Source: AMrXdXvLMM0MJuIwxo4PM500yPlqIXFhTdZgU/H5YrMYNJEIAREeNeZzsAeg49pLpsSpk6sk9yXFTw==
X-Received: by 2002:a17:902:bb86:b0:192:afb0:8960 with SMTP id m6-20020a170902bb8600b00192afb08960mr37391219pls.3.1673407035591;
        Tue, 10 Jan 2023 19:17:15 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:15 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 01/10] bridge: use SPDX
Date:   Tue, 10 Jan 2023 19:17:03 -0800
Message-Id: <20230111031712.19037-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111031712.19037-1-stephen@networkplumber.org>
References: <20230111031712.19037-1-stephen@networkplumber.org>
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

