Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6D31030CE
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfKTAj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:39:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKTAj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:39:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3EC8B144B3060;
        Tue, 19 Nov 2019 16:39:26 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:39:23 -0800 (PST)
Message-Id: <20191119.163923.660983355933809356.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ip_gre: Make none-tun-dst gre tunnel keep
 tunnel info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 16:39:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Tue, 19 Nov 2019 15:08:51 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> Currently only collect_md gre tunnel keep tunnel info.
> But the nono-tun-dst gre tunnel already can send packte through
> lwtunnel.
> 
> For non-tun-dst gre tunnel should keep the tunnel info to make
> the arp response can send success through the tunnel_info in
> iptunnel_metadata_reply.

I know that English is not your native language, but there are many
typos in here and I do not understand from your description how all
of this works and what needs to be fixed.

Please try explain things more clearly, showing how collect_md works
for these tunnel types, exactly, compared to non-tun-dst tunnels.

Thank you.
