Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA133E89
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFDFqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:46:52 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:44270 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFDFqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:46:52 -0400
Received: by mail-wr1-f45.google.com with SMTP id w13so14330015wru.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 22:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BX7v9JyLv4U7ibb8wbD+6AfXp54tgL6R5iGNEJ+H7V8=;
        b=uqskanD6DnYPYjUdjfCrqibonMXxI0H8FOVwlNjNqXoqqUM8oiQ73ZUqIQcJ/F6ccG
         nB3ikQKS/iUWRPhYHhwspIsBRtE9Qo0fCpznMlilwdk4nlyxEf5nu2l0ep8nrxFp96Nf
         7aB6KNmsu9f4bFATdZVWS/nu6nZgUVpm1mmBuUdDk5PihNFe0aeIKG1CR0nT7WGFR358
         5wuceoWtcNUp7l7FJajLZarqIn5GbbXkDxSQ/yg+PlJsHLustPPc6ish7LUvveBK4rJ5
         G1eWYQYXTD1mDGWSOaVo2o3iYTmTt+610HjLaqq1vDZLhUR9f17h/Gz7DoYnTM3RHJJV
         c5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BX7v9JyLv4U7ibb8wbD+6AfXp54tgL6R5iGNEJ+H7V8=;
        b=qetl9T5uwjjcooGg+w+7itHT//CQkeLgJ6KLcI4cIqDy+BiMQRUP3JsPK38bEc3SMz
         VF93ldkxPmMypvTXTecLUanYotLGwrR8CaAp091iUjeNCoJSXAk6AIm6EEAGi3vxT9n+
         wgTxNcD8mGUQp+oGNJBk/XJhmIqgrjLgzgPYwLZUJBEgpzpctHX2mVB0ceeBtxzKocgj
         pLtL8OVMEQFB8y7FyzzXKHIeayIf56EIO8+UxkcACqLbYyAgkX1P1RKHcMKP+pvsx3+j
         J5Js0Uz1ZFrCpEISIcLalWq9USyWf5qDmx0Xq/iwrpbGFYmlI/qpxEgAkjz+xP9ubr+q
         OnBw==
X-Gm-Message-State: APjAAAUfafqDy0DrQbfqvZKIJ2Yai6aDCCWb9Q7pHHroLk8HefmsCz1o
        XHaheSyie5RESdZbfx8aKXVMmJRZ
X-Google-Smtp-Source: APXvYqw7X4uuc6TzT9K1mE3+OsfjwKg7Oi9A8r9KAfpCF8MA5ehMncZbtW2bg1Uria8F4aqM0vZBsA==
X-Received: by 2002:a5d:518c:: with SMTP id k12mr19050637wrv.322.1559627210068;
        Mon, 03 Jun 2019 22:46:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:15c:4632:d703:a1f7? (p200300EA8BF3BD00015C4632D703A1F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:15c:4632:d703:a1f7])
        by smtp.googlemail.com with ESMTPSA id t6sm7847879wmb.29.2019.06.03.22.46.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 22:46:49 -0700 (PDT)
Subject: [PATCH net-next 1/2] r8169: rename r8169.c to r8169_main.c
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
Message-ID: <f2432f11-b305-656a-36d8-bdcee6a7960b@gmail.com>
Date:   Tue, 4 Jun 2019 07:45:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3e2e0491-8b0f-17e1-b163-e47fcb931eb5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of factoring out firmware handling rename r8169.c to
r8169_main.c.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/Makefile                  | 1 +
 drivers/net/ethernet/realtek/{r8169.c => r8169_main.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/net/ethernet/realtek/{r8169.c => r8169_main.c} (100%)

diff --git a/drivers/net/ethernet/realtek/Makefile b/drivers/net/ethernet/realtek/Makefile
index 33be8c5ad..c36cd2167 100644
--- a/drivers/net/ethernet/realtek/Makefile
+++ b/drivers/net/ethernet/realtek/Makefile
@@ -6,4 +6,5 @@
 obj-$(CONFIG_8139CP) += 8139cp.o
 obj-$(CONFIG_8139TOO) += 8139too.o
 obj-$(CONFIG_ATP) += atp.o
+r8169-objs += r8169_main.o
 obj-$(CONFIG_R8169) += r8169.o
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169_main.c
similarity index 100%
rename from drivers/net/ethernet/realtek/r8169.c
rename to drivers/net/ethernet/realtek/r8169_main.c
-- 
2.21.0


