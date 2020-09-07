Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E2525F214
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 05:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIGDcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 23:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgIGDci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 23:32:38 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42146C061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 20:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Gt131uc5X3x7I1V64GtgaStUf8n7gEGWgSFnqCLlg+s=; b=IN/oONUeE3W8g++8ZSqXUc4S70
        Jzpk4CHw/koj22u72j21Bq5SnVOI4eS/g8gUlKIOtH0LZEamU+oJSKB9D8RBxaPU/4TNZlR1gRIvx
        20o5aY7UpWpHiAhbE74Sl9OS/KNYf91eQzd4kgxcDCW3i6hUnLaQHwsTyLzPWqWvP3F8PQ8jg2k5u
        AJk25BkREQB5q5FCKbAx/CwDYQ72uaNXy+5gQDbsuR0UQdyPZTF8QyoKr6VbH+VowSoe1Pa3Pr4MW
        UwnmaqKwAJID7dzv2Xs6vAydsG3+xDqMbJvOJUFHX8g09xGD0XXG8MsLcObCHXUBw4M3U8K1UUdsT
        aLsfJd5A==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kF7tS-0005jn-RP; Mon, 07 Sep 2020 03:32:35 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net] netdevice.h: fix xdp_state kernel-doc warning
Message-ID: <c50a22ba-a6ce-186a-a061-f9326d10914c@infradead.org>
Date:   Sun, 6 Sep 2020 20:32:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warning in <linux/netdevice.h>:

../include/linux/netdevice.h:2158: warning: Function parameter or member 'xdp_state' not described in 'net_device'

Fixes: 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/netdevice.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-59-rc4.orig/include/linux/netdevice.h
+++ lnx-59-rc4/include/linux/netdevice.h
@@ -1849,6 +1849,7 @@ enum netdev_priv_flags {
  *	@udp_tunnel_nic_info:	static structure describing the UDP tunnel
  *				offload capabilities of the device
  *	@udp_tunnel_nic:	UDP tunnel offload state
+ *	@xdp_state:		stores info on attached XDP BPF programs
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.

