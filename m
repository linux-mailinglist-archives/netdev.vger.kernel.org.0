Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D8D12F23E
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgACAgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:36:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:36:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D225B1572D1CF;
        Thu,  2 Jan 2020 16:36:52 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:36:52 -0800 (PST)
Message-Id: <20200102.163652.2010977835864982320.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, daniel@iogearbox.net
Subject: Re: [PATCH net] vxlan: fix tos value before xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102092345.19748-1-liuhangbin@gmail.com>
References: <20200102092345.19748-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:36:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Thu,  2 Jan 2020 17:23:45 +0800

> Before ip_tunnel_ecn_encap() and udp_tunnel_xmit_skb() we should filter
> tos value by RT_TOS() instead of using config tos directly.
> 
> vxlan_get_route() would filter the tos to fl4.flowi4_tos but we didn't
> return it back, as geneve_get_v4_rt() did. So we have to use RT_TOS()
> directly in function ip_tunnel_ecn_encap().
> 
> Fixes: 206aaafcd279 ("VXLAN: Use IP Tunnels tunnel ENC encap API")
> Fixes: 1400615d64cf ("vxlan: allow setting ipv6 traffic class")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied and queued up for -stable.
