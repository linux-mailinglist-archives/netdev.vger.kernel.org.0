Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147C13461E5
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhCWOwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbhCWOvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:51:39 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD91C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:51:38 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k8so17945681iop.12
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cb9buX9rVxx3ke8opkbwPW3pzZmX0QW+zUHbN7SWfEs=;
        b=u/KA+2in1+Gw7yMSCi+cPIqS1rLeXpjMr2eRniAGVeMkktaYTF5aCZ20ohFhR2uqmZ
         KVEMVZSSV8zPWbzmcYmElIZ7VRPc2vR5FapKyBVG5pBxDvp2+LuLjhzvchrBsEz996wO
         MHUBdkwbZZi6+YQNIfESTDX+cjdcdr0tok1/2JGY+d/4j0YgV64Nye1m7SvMSe9Oaazv
         Y/fZ1mfDoJbSRNlHJleowGI0IxDcIigCP++sElflm30DILobWKQNMlljQC/7d5MwkuEv
         aN1C91sQMv0xNF7fjaumTGTzBeuf/oLsZyx2mUeU6Kv9XWZUSsCvX4r7cn0VD9kL99NT
         67Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cb9buX9rVxx3ke8opkbwPW3pzZmX0QW+zUHbN7SWfEs=;
        b=q7DAI9pFKnZtoR/GqdUSwKgX7MmMD47EC9Prf52hN7aRu7ogs0mwC+0AhSJSKrr4BK
         2DeErozitTDa2JMWRT/si2YURO2W0SwjdsobxbSHdVJVQBFltRHcO9dzklSUM/kjUmsf
         I597W4ACBSwqdaGGckWh/UFTxYxxi5p4vHkSsMZLXbkUTPdbImqUgql9pdvGHg70DraW
         pQl5Nsnvfot2fidbCRQbxTBqmyc6pJHS6GIYl6cfYD2kYIj1P1W44/tzxfZPYTWOYxYw
         1S0N7H/fFUbWudgJEm/joAZSu2lVBNssYF0YMWxdhXmDYObthcYn3ELShz6czADs/PHU
         r/ZA==
X-Gm-Message-State: AOAM532XN2sQuSMSQTJpTNYlhFJc8OPbhpICm0oELyyPt2M6L+K5STUm
        STIhGOMRwW71IKJP2BWp3/+41tPg9Pubr1N6
X-Google-Smtp-Source: ABdhPJwvYBU/GUSjVChANxP+L3GLJCcd2Q3GRUSXivKqN5rqQ81SrXdkHMwdPiQdcmHxJZxJS5akeA==
X-Received: by 2002:a02:9048:: with SMTP id y8mr4825615jaf.66.1616511098363;
        Tue, 23 Mar 2021 07:51:38 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o13sm8961147iob.17.2021.03.23.07.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:51:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: versions and registers
Date:   Tue, 23 Mar 2021 09:51:26 -0500
Message-Id: <20210323145132.2291316-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is sort of a mix of things, generally related to
updating IPA versions and register definitions.

The first patch fixes some version-related tests throughout the code
so the conditions are valid for IPA versions other than the two that
are currently supported.  Support for additional versions is
forthcoming, and this is a preparatory step.

The second patch adds to the set of defined IPA versions, to include
all versions between 3.0 and 4.11.

The next defines an endpoint initialization register that was
previously not being configured.  We now initialize that register
(so that NAT is explicitly disabled) on all AP endpoints.

The fourth adds support for an extra bit in a field in a register,
which is present starting at IPA v4.5.

The last two are sort of standalone.  One just moves a function
definition and makes it private.  The other increases the number of
GSI channels and events supported by the driver, sufficient for IPA
v4.5.

					-Alex

Alex Elder (6):
  net: ipa: reduce IPA version assumptions
  net: ipa: update version definitions
  net: ipa: define the ENDP_INIT_NAT register
  net: ipa: limit local processing context address
  net: ipa: move ipa_aggr_granularity_val()
  net: ipa: increase channels and events

 drivers/net/ipa/gsi.c          |  8 +++----
 drivers/net/ipa/gsi.h          |  4 ++--
 drivers/net/ipa/ipa_cmd.c      | 26 ++++++++++++---------
 drivers/net/ipa/ipa_endpoint.c | 42 ++++++++++++++++++++++++----------
 drivers/net/ipa/ipa_main.c     | 21 ++++++++++++++---
 drivers/net/ipa/ipa_mem.c      |  6 +++--
 drivers/net/ipa/ipa_qmi.c      |  2 +-
 drivers/net/ipa/ipa_reg.h      | 40 ++++++++++++++++++++------------
 drivers/net/ipa/ipa_version.h  | 10 ++++++--
 9 files changed, 107 insertions(+), 52 deletions(-)

-- 
2.27.0

