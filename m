Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4897E2CEE7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfE1SrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:47:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35985 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfE1SrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:47:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so11520627pgb.3
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=cGc7AzHIWb52T88+bfjjefIMYH/WgJgz52/xY4DYYK8=;
        b=LdfwSAPBxBcJwmhMJQOxmloW3OxDFPmTupuWq8PqpCS31kUqpDSncrwkglC/PB2b9s
         EbAz7vik75nSZ6urGTsNx62NUGFwDr7i+S2FGdGvrA8NYTUaB7zqhNo6Va/lnfHChQxg
         JjzwqodY54W/b1C3rtSByXmDgvAHSgO6ndjQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cGc7AzHIWb52T88+bfjjefIMYH/WgJgz52/xY4DYYK8=;
        b=BIV/p8fJGDzVqN60ZDTLci/4h3IrJqcRM3qhm8IF2tEMOzDHNJalmvxNavognxUTUo
         y1+/wW0IX47v3jzbiqbWcMcwCeZ/yBw33R8zA+7gvCwPDQEo/3oz2QJRJcoVec73fDFV
         IrxBInxCv+A3LLoxGtCOb2My23aZLWO4JTSzD4SnOCh8zWv+9eFOEHd1ipBVS/iiW4Lh
         dqfMdTOqebftzLyDM5yiXL5lOyKsyRh9arCeixnN7FxfKwuGOTBolnrmScmjcx9yrL1M
         wJrPZVhgPoX5jYWZZryoz4iEgPoN+8gPavFDCBVheHl+bT1O68qeBOdPN0S4DlFRI3yu
         uXsw==
X-Gm-Message-State: APjAAAUYgLXOWpzke1T/1E4Wunt509GdicbkkYMGR1sI87dZ7E95eLGp
        jE3R0HzpZOi3u4X74rCKQM3mlQ==
X-Google-Smtp-Source: APXvYqw6foEZcSu0UWBUGZHiUK+cl9+zdMn+NzRD3LctKUAqRLhJHaYeZX5TS6hknJ9xNgIx8lCO/Q==
X-Received: by 2002:a17:90a:2a85:: with SMTP id j5mr7726560pjd.107.1559069237397;
        Tue, 28 May 2019 11:47:17 -0700 (PDT)
Received: from linux-net-fred.jaalam.net ([2001:4958:15a0:24:5054:ff:fecb:7a95])
        by smtp.googlemail.com with ESMTPSA id m6sm3323766pjl.18.2019.05.28.11.47.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:47:16 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net-next v2 0/3] UDP GSO audit tests
Date:   Tue, 28 May 2019 11:47:05 -0700
Message-Id: <20190528184708.16516-1-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updates to UDP GSO selftests ot optionally stress test CMSG
subsytem, and report the reliability and performance of both
TX Timestamping and ZEROCOPY messages.

Fred Klassen (3):
  net/udpgso_bench_tx: options to exercise TX CMSG
  net/udpgso_bench.sh add UDP GSO audit tests
  net/udpgso_bench.sh test fails on error

 tools/testing/selftests/net/udpgso_bench.sh   |  51 +++-
 tools/testing/selftests/net/udpgso_bench_tx.c | 324 ++++++++++++++++++++++++--
 2 files changed, 357 insertions(+), 18 deletions(-)

-- 
2.11.0

