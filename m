Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE18379496
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhEJQxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:53:54 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:40629 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhEJQxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 12:53:53 -0400
Received: by mail-ed1-f42.google.com with SMTP id c22so19512144edn.7;
        Mon, 10 May 2021 09:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I5mlqDJIauC1akmn+zhMzGaD7Guz6PGhqXO+TRRycxQ=;
        b=Z1pKwA4nOpInkwu6Q0hqI8WhzJJygquEIkJ9lOLWuw52DT9BmwSaUg86dFxPrfNgf4
         ZghezPSv+ssX2hqeU8AnOjQR60Ad80TzcQmtcDz8KtTh78dXt6ZHGJwmv/w8eb0usyMK
         1mW8WpoT3aC+iNXnxGkupDNhXAgy244bXCfUVAr00D/aXsqQ9/djtz7Eb/aGxHNSGEJT
         bAmBfwbDXbC9d6TEqfjTdZB4eekFuxZYndwepzZUrQIyO8sPQWMWpiSwpTPVwuodlgNX
         KmDD75XVg8zDARlwpAb9opCuuQEIAfqZDWooEtZLM1P8A30iWQHSrcoHa4eQmpf3kG+l
         RMrA==
X-Gm-Message-State: AOAM533wnWYTuXV8Jsr8QbDqgcZ05BtQQoyXpMcWN6C8qA+DbZxIv6O5
        Q4pJCtSgisfMHMgtg6uGnGs=
X-Google-Smtp-Source: ABdhPJzitAGG8fa8ma5XfH17IMdze+ymQfzvW9JtCMFmM8TQ3yiNLJVMespKHY/BpAAFedg03xliuA==
X-Received: by 2002:a50:bb27:: with SMTP id y36mr30747948ede.365.1620665567105;
        Mon, 10 May 2021 09:52:47 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id t7sm11930469eds.26.2021.05.10.09.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 09:52:46 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] mvpp2: resolve two warnings
Date:   Mon, 10 May 2021 18:52:30 +0200
Message-Id: <20210510165232.16609-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Just two small changes to suppress two warnings.

Matteo Croce (2):
  mvpp2: remove unused parameter
  mvpp2: suppress warning

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++----
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c  | 3 ---
 2 files changed, 4 insertions(+), 7 deletions(-)

-- 
2.31.1

