Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AB43818E7
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhEONHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 09:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhEONHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 09:07:50 -0400
Received: from mail.manjaro.org (mail.manjaro.org [IPv6:2a01:4f8:150:448b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9357C061573;
        Sat, 15 May 2021 06:06:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.manjaro.org (Postfix) with ESMTP id 01FD63E63070;
        Sat, 15 May 2021 15:06:36 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at manjaro.org
Received: from mail.manjaro.org ([127.0.0.1])
        by localhost (manjaro.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rIzB_Mwk7_lT; Sat, 15 May 2021 15:06:33 +0200 (CEST)
From:   Tobias Schramm <t.schramm@manjaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Johan Jonker <jbx6244@gmail.com>, linux-kernel@vger.kernel.org,
        Tobias Schramm <t.schramm@manjaro.org>
Subject: [PATCH 0/1] Add missing compatible for RK3308 gmac to snps,dwmac.yaml
Date:   Sat, 15 May 2021 15:07:22 +0200
Message-Id: <20210515130723.2130624-1-t.schramm@manjaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In [1] support for the gmac in the RK3308 was added. Unfortunately the
patch missed that the new compatible introduced needs to be documented not
only in rockchip-dwmac.yaml but also snps,dwmac.yaml.
This patch fixes that by adding the compatible to snps,dwmac.yaml, too.

Since the previous series was applied to net-next already I'd suggest
applying this patch to net-next, too to fix potential dt check errors.

Thanks, Johan for notifying me of this issue.

Cheers,
Tobias

[1] https://lkml.org/lkml/2021/5/14/374

Tobias Schramm (1):
  dt-bindings: net: dwmac: add compatible for RK3308 gmac

 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 1 +
 1 file changed, 1 insertion(+)

-- 
2.31.1

