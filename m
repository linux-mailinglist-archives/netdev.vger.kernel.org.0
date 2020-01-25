Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C835149586
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 13:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgAYMm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 07:42:26 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40518 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAYMmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 07:42:25 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so2160578wmi.5
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 04:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Pe9vhSxqqpdyWQvCqBsJudBI73I400SpXMYJPxOUWOE=;
        b=jZoAXMemGUtIYvgcO+QdUkP3ZdKdJig1F1zO1PhABRJKLtr5wAqXjVt98ucM6+5jr5
         5TuueG+Z5mBMfUf2Hb9HXkXHburSMQkORabWN9kanRpRTfw364yUMqsKh7AtRDVaox8p
         vDDfP4v11ZWQ8YuUsfyytXFM67vM/SqHJ9ySSDnhTpBwXj6nYjXVyCjSfqn32228eAQt
         DIvIEo7b9t325jAUYSzFT7Mtv/Z/dK1LuWBTQ3dZ/UonlL3IlSadJtlku+9KyS94Eksi
         6ZAKK408mj6bXfX7+GU3Xnq1O91iRlo4vWs2IKIJqllyGxiGnV8089xViiHPrefRimoQ
         QVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Pe9vhSxqqpdyWQvCqBsJudBI73I400SpXMYJPxOUWOE=;
        b=rF24c7zCdH2zM+kKSn409Ebw+M3SNNAFm1qmzrg5IcZuXkQVKnlNuTx6IpD2wr1XGb
         99pQmzCtF6MZeFnXvu5bgQhJghZVcnhQC6OzrN+JA6IYh7N1PgtBH84F0ZVyfNA771fM
         rBHV/mPJVddAe6L9NkY2ca4/nBW8gtfvrpq1cGfRIJwQ/NDFDAd5rBFscZMbP1fGqb9Z
         9ivGl00C4ywHhZ/LPeY+qSsXrtRAbmNlop883I1EjqqlfFFsb4ejwAJvgA9Uk61CkbC+
         fJ0+kTtYECKLK745xqyn0N5R0Cc0n04gnMYa8xqIez+ySYqlboYCctv8pf7b4MtVy2NB
         ynIg==
X-Gm-Message-State: APjAAAWcn4Gc+apYMZevcDzUEmUaF6saiQO9Cy92j56UDIRTpK2dseIy
        t4tVmYZ0+zWIcx7FwP4lOVJbedP1
X-Google-Smtp-Source: APXvYqwdFmY68JgJ7zqJ82CFDiFaKQgvUqnh+4NPonf+fuN8d6M0/QkXPR4OVqfMjC+4VYbUII0ZTg==
X-Received: by 2002:a1c:cc11:: with SMTP id h17mr4217847wmb.19.1579956143363;
        Sat, 25 Jan 2020 04:42:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f36:6800:8c0e:3e2:726b:8b6? (p200300EA8F3668008C0E03E2726B08B6.dip0.t-ipconnect.de. [2003:ea:8f36:6800:8c0e:3e2:726b:8b6])
        by smtp.googlemail.com with ESMTPSA id h8sm12800208wrx.63.2020.01.25.04.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 04:42:22 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: remove eth_change_mtu
To:     David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <f6c76898-a0ce-b2ce-3f51-bb12d0010c05@gmail.com>
Date:   Sat, 25 Jan 2020 13:42:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All usage of this function was removed three years ago, and the
function was marked as deprecated:
a52ad514fdf3 ("net: deprecate eth_change_mtu, remove usage")
So I think we can remove it now.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/etherdevice.h |  1 -
 net/ethernet/eth.c          | 16 ----------------
 2 files changed, 17 deletions(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index f6564b572..8801f1f98 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -43,7 +43,6 @@ __be16 eth_header_parse_protocol(const struct sk_buff *skb);
 int eth_prepare_mac_addr_change(struct net_device *dev, void *p);
 void eth_commit_mac_addr_change(struct net_device *dev, void *p);
 int eth_mac_addr(struct net_device *dev, void *p);
-int eth_change_mtu(struct net_device *dev, int new_mtu);
 int eth_validate_addr(struct net_device *dev);
 
 struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 9040fe55e..c8b903302 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -335,22 +335,6 @@ int eth_mac_addr(struct net_device *dev, void *p)
 }
 EXPORT_SYMBOL(eth_mac_addr);
 
-/**
- * eth_change_mtu - set new MTU size
- * @dev: network device
- * @new_mtu: new Maximum Transfer Unit
- *
- * Allow changing MTU size. Needs to be overridden for devices
- * supporting jumbo frames.
- */
-int eth_change_mtu(struct net_device *dev, int new_mtu)
-{
-	netdev_warn(dev, "%s is deprecated\n", __func__);
-	dev->mtu = new_mtu;
-	return 0;
-}
-EXPORT_SYMBOL(eth_change_mtu);
-
 int eth_validate_addr(struct net_device *dev)
 {
 	if (!is_valid_ether_addr(dev->dev_addr))
-- 
2.25.0

