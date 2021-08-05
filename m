Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F5E3E1A1C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 19:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbhHERLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 13:11:22 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:33356 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhHERLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 13:11:21 -0400
Received: by mail-ej1-f50.google.com with SMTP id hs10so10850343ejc.0;
        Thu, 05 Aug 2021 10:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yqeDSob7HIuOI4ueZc+RMNusQFLNaSctLWi/bXqPb8c=;
        b=AKd1MQUlaaExiFx2Ij7zczLzav2E/v7K6JBn72NFM4Rby5eU7NN/hdTRQD9G6J6kmR
         UkCo7qfmKSTHr8El3xcOCoEADxeld1eCFBe4uw6XoLz5CpYdX1pYJ+g/u1qUxdN7IXpE
         UgghEMSnmOhslCGJuSJGc5iEnKn3V3PIRPYG+Dmzggn2VOtPqm8slyJ9XVorT61sGwZ8
         eDC2TAwknzW//3E3TP4FmPIzoAqqXxpq4T69sCFHMhcFVsxLgyQijFgL2L7DP4Tcg4i1
         pZOQJBB9BvRrj9dE5XCpUJKeZ1IE0PvT4CzxWX0hyb9yjE8mRGvLgNemDCvsTDQ7P7Ad
         OmzQ==
X-Gm-Message-State: AOAM533JnWxRRVZikvr3ehPVpW7BHcOG45qY4eKRZP3G6EH1YYR+qAml
        li7opgSTQ5AYiYLlJB2mMh+9ukegDQcrUA==
X-Google-Smtp-Source: ABdhPJzOt7h8Ts/rtwH8i//E2eVSSs7njgwdY/EGwSJjuTh+ygS+TwV1EU8xqN6BuKXTaUGjvIbWBA==
X-Received: by 2002:a17:906:31cf:: with SMTP id f15mr5978445ejf.272.1628183465438;
        Thu, 05 Aug 2021 10:11:05 -0700 (PDT)
Received: from msft-t490s.fritz.box (host-80-116-27-227.retail.telecomitalia.it. [80.116.27.227])
        by smtp.gmail.com with ESMTPSA id n2sm2592655edi.32.2021.08.05.10.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 10:11:04 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFT net-next 0/2] stmmac: recycle SKB
Date:   Thu,  5 Aug 2021 19:10:59 +0200
Message-Id: <20210805171101.13776-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

I have two patches to enable SKB recycling in stmmac. Unfortunately the
only stmmac hardware I have behave very bad, so I can't do decent
performance tests.
Can I get some feedback for this series?


Matteo Croce (2):
  stmmac: use build_skb()
  stmmac: skb recycling

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 
2.31.1

