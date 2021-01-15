Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9202F78EB
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbhAOM3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbhAOM3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:29:40 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DC6C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:29:00 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id n2so580539iom.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vc09DY2r3H1y9mxbKEtSIgPLT8cjCGScO9uOxFbsFz8=;
        b=W8uDvDshnOankE0iaEopM58bGH79S1yK2wmxrIC7+A5LkBT2DE+JjlH4SMUbgrtNKV
         j8vhbpQif7AepucBkDTaKNCWaguR5bRs3Rrb4FaUiNOqnUbiiIw0E4K5n1iWDvac21+W
         uRP5wYmE46IZKdL5BzcrD01BO4QgsUl019WdWvZc/jusfaAo1lSaywBdCgNZb6jzkzG1
         udJPGxMEABDQL15QBKSKair2l8xy5d8vmvU7Vytmvs1AUiZsrXNxg6XGyejQkz/40Esr
         lpXis2uop0d4sNZPK0f7oFpriDslhnMpUdWf3IDeR24D6l9o53ZO9Q3EXj2Mfw1fHySr
         Eogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vc09DY2r3H1y9mxbKEtSIgPLT8cjCGScO9uOxFbsFz8=;
        b=PIsl8A9IY7s+6a72FCfYwAiJkdGKBipZhxes6vmah0oDKntaSSckNKq06GBbFIme52
         t0g9s5WyXjUOEWQoEnxWBv6pmgLdSM2Z5jidRFoAiCK4r7Y7WET9SBgKotN7hcBWKjsc
         Vscj+rUsufwGnVTXZ8fL/K5M0JLRPMcycE1S2e2kn0W9zwk4K+zjBbIRLF4SYTT2Fdgb
         a9D+qQC96EMkCeJeAxNm8yCFZ0JxUEuGFXUfGMsOPOTLOCegNsH9uMCPJQgp2gcblCsd
         seYFVw/ykDOmJaQue84auxX2/0g+217J4YujI5tTVUGBZ6VOwcX7oh98FFUeCLyLQw9I
         OQxQ==
X-Gm-Message-State: AOAM533J7aYRY++vkeYfWNkxLbbWUB6IF0rrUPCDrK8iwAWYzMin72L4
        rE5MR3s/9/RroTIwvMZShqLYfQ==
X-Google-Smtp-Source: ABdhPJxJ8D0/NMCx8evr3t9mxKbCWncCYnD55AjoQ6M4fuxAcG4eITrhWSrc1msB6iYZJYk9HnSTVA==
X-Received: by 2002:a02:caac:: with SMTP id e12mr9845527jap.45.1610713740070;
        Fri, 15 Jan 2021 04:29:00 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a9sm3828509ion.53.2021.01.15.04.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:28:59 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        robh+dt@kernel.org, rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2 net-next 0/4] net: ipa: remove a build dependency
Date:   Fri, 15 Jan 2021 06:28:51 -0600
Message-Id: <20210115122855.19928-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob, for some reason I can't find in my mailbox your report that
the binding caused a problem.  I only discovered it when looking
into why the series was not accepted yet.

Version 2 includes <.../arm-gic.h> rather than <.../irq.h> in the
example section of the binding, to ensure GIC_SPI is defined.
I verified this passes "make dt_bindings_check".

The rest of the series is unchanged.  Below is the original cover
letter.

---

Unlike the original (temporary) IPA notification mechanism, the
generic remoteproc SSR notification code does not require the IPA
driver to maintain a pointer to the modem subsystem remoteproc
structure.

The IPA driver was converted to use the newer SSR notifiers, but the
specification and use of a phandle for the modem subsystem was never
removed.

This series removes the lookup of the remoteproc pointer, and that
removes the need for the modem DT property.  It also removes the
reference to the "modem-remoteproc" property from the DT binding,
and from the DT files that specified them.

David/Jakub, please take these all through net-next if they are
acceptable to you, once Rob has acked the binding and DT patches.

Thanks.

					-Alex


Alex Elder (4):
  net: ipa: remove a remoteproc dependency
  dt-bindings: net: remove modem-remoteproc property
  arm64: dts: qcom: sc7180: kill IPA modem-remoteproc property
  arm64: dts: qcom: sdm845: kill IPA modem-remoteproc property

 .../devicetree/bindings/net/qcom,ipa.yaml     | 15 ++------
 arch/arm64/boot/dts/qcom/sc7180.dtsi          |  2 -
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |  2 -
 drivers/net/ipa/ipa.h                         |  2 -
 drivers/net/ipa/ipa_main.c                    | 38 +------------------
 5 files changed, 5 insertions(+), 54 deletions(-)

-- 
2.20.1

