Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF84412A7
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 05:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhKAEIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 00:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhKAEIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 00:08:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C8CC061714;
        Sun, 31 Oct 2021 21:06:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id y1so10712314plk.10;
        Sun, 31 Oct 2021 21:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ELMr6WyNMGxalt1MQjiRGFC+4U6njkBfuNwg+LRAF8=;
        b=WVLMapV1T0IAr7m9xayppPJb4u0srIwMvQvChjsksd943YvtYEr5En9ZeTeLWejOB9
         b4aW7qX7Ufxd9FaWo1sqeKVx+N7634jUWymSe1vZGOmvqc2ztCrPV9nAyX9nCY3GFiGU
         2AsDGrpB5PPPvEComGaj1MN6Ydd2p+AUlZtVyPPd9EIsfOJAh4Fe/8AJYEsBshaBKH69
         f173hnijcy2DytDJ678AGoIjvjYCJgyfS/+dB99nlwXY8D+RTTcgnpsz/kxxOconH61j
         oCfZFzGVsIqL6XvOlrF/WkMMirES9mizk6VRw7x+7H1ElcB8n6v/T5wkD3Ee3eCC9BQV
         47mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ELMr6WyNMGxalt1MQjiRGFC+4U6njkBfuNwg+LRAF8=;
        b=pv0zJjBvY4ngNjuqp/fx4EIwrD1deucxMW8suIBLsU5+NPncWaPOq8h48KJzQ8Us6N
         H9U+3WYOSkncGlXCk1UrEQNy+WKfVWEfdQ63sCiZO0p3sGylnuW70wh8lBJG+uN4QkGH
         y4ZpWvYRAQqgxAFeC/rnGgCZj0ATIxQgmnFNX79w8SsxYNly6uuhp8+Q9McAfgwqGadK
         afWS19X2rLTV0QKhsihu+x7LIWYm6UWnGMs0dGz3QPncbXsUx35EPGN6pyFJQA25qGL5
         Lytagum5fv+ve2DKObJkwBmjnkcOi9bhH//yllT0JZpBBINxnTh120b9q2b0TcWvoKv7
         hbug==
X-Gm-Message-State: AOAM5319RFY6BpWE4c+tZwQxU68VAnZhHeQzKuNGeINE72LMcCJPiWJ9
        IQgGgaUn8NdFaFg2ogEFj/IMS3MyVds=
X-Google-Smtp-Source: ABdhPJzreZRk1XBh9EarBMTCJtAqjXvEFmDA3VRC8QgMyox+qSx7gy2JsXFLbgs3S0KYKWabCQd/xQ==
X-Received: by 2002:a17:90a:4fa1:: with SMTP id q30mr26757311pjh.12.1635739581086;
        Sun, 31 Oct 2021 21:06:21 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v13sm11132231pgt.7.2021.10.31.21.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 21:06:20 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/5] kselftests/net: add missed tests to Makefile
Date:   Mon,  1 Nov 2021 12:06:04 +0800
Message-Id: <20211101040609.127729-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftest to another folder, some tests are missing
as they are not added in Makefile. e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

These pathset add them separately to make the Fixes tags less. It would
also make the stable tree or downstream backport easier.

If you think there is no need to add the Fixes tag for this minor issue.
I can repost a new patch and merge all the fixes together.

Thanks

Hangbin Liu (5):
  kselftests/net: add missed icmp.sh test to Makefile
  kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
  kselftests/net: add missed SRv6 tests
  kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile
  kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile

 tools/testing/selftests/net/Makefile | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.31.1

