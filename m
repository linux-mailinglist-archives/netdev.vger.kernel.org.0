Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5CF48D8D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfFQTIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:08:55 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:44933 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfFQTIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:08:53 -0400
Received: by mail-pg1-f182.google.com with SMTP id n2so6307644pgp.11
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=rnvedP+27FpjNnYtAjFGpiRqsnOOK2nmaRaeNdbtb1o=;
        b=vBsNL4xA75AArFv43xH/ZFWaTuVytMM6eqHpZ1tXM+VDVoEy5yMQripNDjto8EE4gy
         sLy8/DOabehrCXI85ff0a+D2MFJfY75cflKwRSSagC0yV0ctc+HzbxAa9ddgOJ1KFbz5
         xziO5rtypSlZ2XccylDBALkxodIipsANhVV2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rnvedP+27FpjNnYtAjFGpiRqsnOOK2nmaRaeNdbtb1o=;
        b=adfwUj11fvmNihKBz9DXl4kwGxlWB0DbZObeJDOR95yL5QN/KVanFZb9pJL0jmNQCC
         RPqcQ9W2kDxDVy+V8FjEfjoLFyJAj2bt26mT2/sLXjpo+B+OGasXw/17opHhl02tOMsZ
         UUVrAGAOqBdxV5aG8vWFRFpIeYFkoilWtqrryVEIaH6X+ygJgm0PdaMxUL00dMT9t/pe
         t5dE/96Z/JVU7dKtutpgQSQ6gppnw+SZPUVLehlwKUnHLawulxnnujBVy6cEPTqlLI2o
         /g39BJGvGOTdn9zcZyz9PBpDTjBd/QHyGEb59k2liGHjd36lvK5Mk3bMvjC1qj6j09nC
         6vBQ==
X-Gm-Message-State: APjAAAW8ZOtc/hwaVEG/9ESOZFBTHMOcQYuPcIWm1Ycu/ikHQgcMItOz
        CmWeNtjbIxsK1xs9KhhUUK6k2jkq02U=
X-Google-Smtp-Source: APXvYqwwGimRXjyilSR/k74EsjGUAgN/gKKO8YMsV/GXu+UiCTnuTOfgehMR7Sr7m7f0NsT6WX/TrA==
X-Received: by 2002:a17:90a:bb8b:: with SMTP id v11mr428903pjr.64.1560798532555;
        Mon, 17 Jun 2019 12:08:52 -0700 (PDT)
Received: from linux-net-fred.jaalam.net ([2001:4958:15a0:24:5054:ff:fecb:7a95])
        by smtp.googlemail.com with ESMTPSA id p43sm111063pjp.4.2019.06.17.12.08.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 12:08:51 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net-next v3 0/3] UDP GSO audit tests
Date:   Mon, 17 Jun 2019 12:08:34 -0700
Message-Id: <20190617190837.13186-1-fklassen@appneta.com>
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

 tools/testing/selftests/net/udpgso_bench.sh   |  52 ++++-
 tools/testing/selftests/net/udpgso_bench_tx.c | 291 ++++++++++++++++++++++++--
 2 files changed, 327 insertions(+), 16 deletions(-)

-- 
2.11.0

