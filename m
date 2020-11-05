Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00552A899C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732498AbgKEWTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbgKEWTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 17:19:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5524020719;
        Thu,  5 Nov 2020 22:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604614762;
        bh=XMA6Yhs1bUQEaybFHgD0ThVAW9oy2GgK0w/zRt0yznk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ksBefqql+2pt62lD9rVwI69vY8AisCexBwPTSgcJCEUbxzh5VEe13164ebm2PTJtX
         yGaeneDyaCrtrQ5zlhMCJimSFmqraWbLXih3cfGOG068Z/f3J4JFoKpZ4jioVl8JU2
         2hZIBHj/IfWLKrRYUC82udPiEoR0lFWH3MQ199IQ=
Date:   Thu, 5 Nov 2020 14:19:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     marcelo.leitner@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201105141920.1c4a30ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604572893-16156-2-git-send-email-wenxu@ucloud.cn>
References: <1604572893-16156-1-git-send-email-wenxu@ucloud.cn>
        <1604572893-16156-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Nov 2020 18:41:33 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
> 
> This patch add support for a xmit hook to mirred, that gets executed before
> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> The frag xmit hook maybe reused by other modules.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

CHECK: Please don't use multiple blank lines
#53: FILE: include/net/act_api.h:258:
+
+

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#186: 
new file mode 100644

WARNING: line length of 95 exceeds 80 columns
#224: FILE: net/sched/act_frag.c:34:
+		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci & ~VLAN_CFI_MASK);

WARNING: line length of 81 exceeds 80 columns
#314: FILE: net/sched/act_frag.c:124:
+				     netdev_name(skb->dev), ntohs(skb->protocol),
