Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD5D33A7AA
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 20:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhCNTj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 15:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhCNTig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 15:38:36 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BBAC061574;
        Sun, 14 Mar 2021 12:38:36 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t9so4634457wrn.11;
        Sun, 14 Mar 2021 12:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4k4FyGgP/BObQspS4aO6lMvu6TUnuO2mVBB8IcJRbqc=;
        b=DddVgw6DNLWnaPBS+yepmkK+EJMsL3jzEGAzV0/uOqRh+84Gb8KMqoHWexpX84+bkd
         vyg8PrHKgHGHaBWNPsptObLIvzQhV5sptYqX+RXFuMDGxNuVeFp6NzXDAsZSciH3FSfj
         NdsoxOvu3xSz8yO9sB0hqjbRBy5q9G6txs2tgY/QJ6MSzGRuxuFEUGaXamC7mpokqCqY
         Q1M90OUr4joAODihqqlTjhDtTtS54PWIrxPlugBDGTFp39m7jjvsHp9pyH7iSMOWLrZx
         eNr8yP3q6Kyt8oO5zeA+bnISSA2Yhd2GHu51zs9CBl1KKf5DO2oNg9I5Efat0/9OwZQU
         VJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=4k4FyGgP/BObQspS4aO6lMvu6TUnuO2mVBB8IcJRbqc=;
        b=iT+ZErGqS0G5iymvaZE21yvkypR5WtL/n+6Ow8c7HFqgnyPOuo6FYWkK5T27hhkqDL
         sALUUmSZXKY0K24Hpfi1QqyiWcl/3opvYB1bV3Cei+C3o1UI4wboP59i02DmHw9yYPcb
         YnYf/amGU3T9PoNfywm0ZrYslSyCn7q3I3fdm1Mgmf/a7pWy45d6dL4CJFXgIZCdb6mr
         OkBDnUeFCEXp06zvGkPI6ccoYT0Mjllcc69KHbVaLvDolxSZY/3iyYKfIFf9QkyH9bCt
         RFwDEDXgrbvOptqyjP5PQitM8nhExqDDFVU7dYLGxGsjb+1A3tRY7iGNAwamm0nQyZeK
         Qs0w==
X-Gm-Message-State: AOAM531JJ3mszNnegeuVY6Q555O/0Ak64az1M8z0vROUtqtkty3mVrJa
        RhTHMsnY7cjENqLDUz/YKIs9zmJ3LIrnMg==
X-Google-Smtp-Source: ABdhPJxQLjRY6UQEjEZ8OqcXUVG9bBkEiktGCphOo3SMXF+fE5bmfxO6BC1Ou0p5m/Mz5fZYcW5MIg==
X-Received: by 2002:adf:fe8d:: with SMTP id l13mr23410893wrr.81.1615750714676;
        Sun, 14 Mar 2021 12:38:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:fc04:867f:ef73:99ed? (p200300ea8f1fbb00fc04867fef7399ed.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:fc04:867f:ef73:99ed])
        by smtp.googlemail.com with ESMTPSA id y10sm16579400wrl.19.2021.03.14.12.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 12:38:34 -0700 (PDT)
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] iwlwifi: series with smaller improvements
Message-ID: <22e63925-1469-2839-e4d3-c10d8658ba82@gmail.com>
Date:   Sun, 14 Mar 2021 20:38:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series includes smaller improvements.

Heiner Kallweit (3):
  iwlwifi: use DECLARE_BITMAP macro
  iwlwifi: switch "index larger than supported by driver" warning to
    debug level
  iwlwifi: use dma_set_mask_and_coherent

 drivers/net/wireless/intel/iwlwifi/fw/img.h     |  4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c    | 10 ++++------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 10 ++--------
 3 files changed, 8 insertions(+), 16 deletions(-)

-- 
2.30.2

