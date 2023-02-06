Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECDF68BCE4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 13:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjBFMdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 07:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBFMdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 07:33:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882F91F5C7;
        Mon,  6 Feb 2023 04:33:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23E1960EC6;
        Mon,  6 Feb 2023 12:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335ACC4339C;
        Mon,  6 Feb 2023 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675686819;
        bh=5WVlaS3/zFQwln7s9uVxC5sIfgIbVY6ccLu0N5dICE8=;
        h=From:To:Cc:Subject:Date:From;
        b=KV84+dekaKRQvIz4BSu62j6V8e16X1/TA8v1DQedtN3m+3V0lWSudVmFJ8JqWK3Qa
         0+rOwzIPeQg9k6sFUbCCOBL4QrrgJKtuepbUVCE5zlzLXe4YO0677JDoO2NkA5u24M
         vjj5TwbRlHPnAnxc1W0nwm1WgzM280SkMnJfLJPsy0Ho6HASfty2RrOAZBNC0ySqp+
         RCnJIOyK1ULgeiR4RPLOCo5BEjA/3GM1ggOhmDft9u1Jyaf2nc+/jDCivn3d88PY02
         ghdMgkrpj9iqSn+mwSxj5/ntywtiKilnMI6S5vb6N9O3Kz80z+kjDJ+XxbOeo/8tyz
         F0DHcAPzHm4+A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, sfr@canb.auug.org.au
Subject: [PATCH bpf-next] net: add missing xdp_features description
Date:   Mon,  6 Feb 2023 11:34:40 +0100
Message-Id: <bec12badf6eea84c426bb51f1eb249b2e8c6a421.1675679509.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing xdp_features field description in the struct net_device
documentation. This patch fix the following warning:

./include/linux/netdevice.h:2375: warning: Function parameter or member 'xdp_features' not described in 'net_device'

Fixes: d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0f7967591288..645787259172 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1819,6 +1819,7 @@ enum netdev_ml_priv_type {
  *			of Layer 2 headers.
  *
  *	@flags:		Interface flags (a la BSD)
+*	@xdp_features:	XDP capability supported by the device
  *	@priv_flags:	Like 'flags' but invisible to userspace,
  *			see if.h for the definitions
  *	@gflags:	Global flags ( kept as legacy )
-- 
2.39.1

