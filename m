Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E57347952
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbhCXNQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbhCXNPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:15:32 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE846C0613DE
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:31 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id j26so21396449iog.13
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPFA6rVxHKxBQf4a3Xn6w1bxyecBN3XKdCmIzpzW6iI=;
        b=YUN+OMrgxvni1bhoTXWvikyICShXhRAcIYY65R2qWT8dKQ9C2LhB7m2uAovivNnWTS
         mE6S/u3FzHduklf/WYV8yE9Y/OWri7YCehdUpiPcAPyyzropeRmcqJ8YSUwJ5A3p6sXB
         Q3yXE+rQk05eziqAc5ysqpvmusGf0p9cEYQaSBeEWysugZ5t4b79osPH3aPebGwEGZO/
         1rvnGlMV8vo+fCBl3E4ZZFWRw+nmC7nyy6kR1nehlMIunL2E9QA2f9QLnXmA/l7BgmiU
         A3BrrqR9xxW05Sgq8JzuW/JyOF4JL+Wa37BpALJ0IMp7sr8odq2BEtDeHcFUQAODZ0Np
         B/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPFA6rVxHKxBQf4a3Xn6w1bxyecBN3XKdCmIzpzW6iI=;
        b=j6B1i9Zq3Zj6mmyIFnq7miEFV2Ajr1y93SL4YT89C1FSSvkMU8ZCM8VWt6KTJBWg8E
         MvgE6L/rivhtPZh4a3KArpp+9FqvyH2cvpWs0PCMy3gMPd20XiJezBgxQQmJ4nQwwLv+
         zJQ2jEDth/UJ1kYIszJfa3nDXyAQP5ytKIiRmy4mOemkk4KMmNafdONbJQnyeQZokLbw
         PlCv4oq6FxyUn+UFRYE9cJUa6LErHhCeIMMhMV/Ztfyp4M6qUFqav9gp7nTIPfp8WiF2
         fSG1oLTBAdIZe5d9hsg/fbRFvTtxRx8xjnky2ovtYmLjsjr3ImXeHig1sABNRMLsxoAX
         DhtQ==
X-Gm-Message-State: AOAM532spxixCipZkQaFnrFRarRcVpYOrcHg80vxJcU3xwLjBXEMjm/D
        3jsmpcnhCC0paHqeIhkVftaFAg==
X-Google-Smtp-Source: ABdhPJw5nl75LHisWPGEDM7ykRNxz1p6iL7XlaPCh2TtwZVdsbyrweDkGyv7pUd9gGuTMW/4xNo7Eg==
X-Received: by 2002:a02:ab94:: with SMTP id t20mr2883601jan.49.1616591731092;
        Wed, 24 Mar 2021 06:15:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n7sm1160486ile.12.2021.03.24.06.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:15:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/6] net: ipa: versions and registers
Date:   Wed, 24 Mar 2021 08:15:22 -0500
Message-Id: <20210324131528.2369348-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 2 of this series adds kernel-doc descriptions for all
members of the ipa_version enumerated type in patch 2.

The original description of the series is below.

					-Alex

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
 drivers/net/ipa/ipa_version.h  | 29 +++++++++++++++++------
 9 files changed, 121 insertions(+), 57 deletions(-)

-- 
2.27.0

