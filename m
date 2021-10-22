Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23A1437083
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 05:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhJVDkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 23:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhJVDkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 23:40:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1299C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 20:37:51 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gn3so1999640pjb.0
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 20:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gYOA/e4FrJkhUaSmWemCSnmosjGUV1FXqoiu0H92/oc=;
        b=C9KbkwmSSqUJuPBWNMHUtlghMhT+duTj2MSzIduaJyBdjpBMbvmWGXwAVxD4fGQX/E
         ImUKqbdqldJPn+PBQNFmTMZVgby5FYr2W6ml6NW+ZE7ij+WPHvy+GNT7s1XHE9HhoBjN
         OyEL6eEfKBgazlcRPmFOQlTc3cCSm1FGX6fwNRgeTZUWtE00PUSNGJ3lBena/XkCXY8f
         NqzKcOGW6A+8BwfRD39Z1LsglOtIQyEhgyGRzCwX4i4kDUr5L+U1+MdBVRDP3o/Xp4ZZ
         GhZSKZgLWvCjuXckveH+uZ1Zqr92BfpjpvK8+a69yv+OCc9diXx7uH8KXJZMJiGLcmcB
         0L2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gYOA/e4FrJkhUaSmWemCSnmosjGUV1FXqoiu0H92/oc=;
        b=woqrO9Ph0l6o6FKxvy2VTSm4vTiOuzqcJn7xqgHeR5Ah9DVSQlKSdSF6doDWGsGMJF
         tJ5/Jg50/tiUcrU8Pj9QujBuTPi/YsE5FNNJB2JMN4wiG/bkYrH+sBnLsk9z8tc5nhCJ
         gtzHAfMpSkCdN1iW+uDA5SOwQ8EHAEOvFYraXUgk+wLMm5X+XgJb1CCA62GSt7bXdWpS
         c2n6ilrWROcA4RvCjZT1CzfAEq3Ig7C0cfqjXaLPwON3spBi38q3zvIxFc0dMZvJ7Tvm
         jibZrYd8a/bmprfatIZkb8VdEFwLcNxPT+fnf0k5kUV7zgLkA2GJp4WcDR6mwK4CV3KO
         36mw==
X-Gm-Message-State: AOAM531Ex0wvVxA1Db3nrK+HIBOGG7XphwyF8Cfkv3M82MT5S1DUomju
        68wbhViqLuT8Tu4IcszONxc=
X-Google-Smtp-Source: ABdhPJyKjmnPV7UntaLi/nCU3DpqQcU0sAzDfgPW8ZFjpl9Yu7Eu4mUjmex4x8DKW9sOcUFv9IYsuQ==
X-Received: by 2002:a17:902:aa02:b0:13a:6c8f:407f with SMTP id be2-20020a170902aa0200b0013a6c8f407fmr8709098plb.59.1634873871204;
        Thu, 21 Oct 2021 20:37:51 -0700 (PDT)
Received: from localhost ([23.129.64.158])
        by smtp.gmail.com with ESMTPSA id z2sm4434362pfe.119.2021.10.21.20.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 20:37:50 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/2] Small fixes for redundant checks
Date:   Thu, 21 Oct 2021 21:37:40 -0600
Message-Id: <cover.1634847661.git.sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

This series fixes some redundant checks of certain variables and
expressions.

Jean Sacren (2):
  net: qed_ptp: fix redundant check of rc and against -EINVAL
  net: qed_dev: fix redundant check of rc and against -EINVAL

 drivers/net/ethernet/qlogic/qed/qed_dev.c | 31 +++++++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 12 +++++----
 2 files changed, 24 insertions(+), 19 deletions(-)

