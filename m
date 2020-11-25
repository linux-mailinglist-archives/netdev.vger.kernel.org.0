Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C230F2C480F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgKYTLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgKYTLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 14:11:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7531B206F7;
        Wed, 25 Nov 2020 19:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606331470;
        bh=0RN4shJnl5y7ttCAUAiozpZMxJL0BXI36LE5jWZVQx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iZGgteFDaESgmt/vM4JVL7u/eK6u2RCxo2vrJBUlh/M3GhGcRS7ValjrzedvGCTDJ
         sibs5/6Y3lp1FlCE94s8JrCVG7/falZTznwKvaPSxv9+qWGnf7oyTEkqOGGPaFO0t6
         ZYxss0YCRAnhWrVT9E6TLCz1F9ayVF964VSsnBfs=
Date:   Wed, 25 Nov 2020 11:11:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com
Cc:     wenxu@ucloud.cn, netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        vladbu@nvidia.com
Subject: Re: [PATCH v4 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
Message-ID: <20201125111109.547c6426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1606276883-6825-4-git-send-email-wenxu@ucloud.cn>
References: <1606276883-6825-1-git-send-email-wenxu@ucloud.cn>
        <1606276883-6825-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 12:01:23 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in cat_ct. But when several
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

LGMT. Cong, Jamal still fine by you guys?
