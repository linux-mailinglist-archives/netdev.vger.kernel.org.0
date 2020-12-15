Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE602DA612
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgLOCQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgLOCQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:16:09 -0500
Date:   Mon, 14 Dec 2020 18:15:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607998528;
        bh=QvkHCVMW0SB+pTQQ3/pBe4qj9v9HB0Wf38vezPISho8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=uhGQDip1gaMl6Y0ZemqB6XZXFPlCwzPC/jm05va1CItezUfRrgnHySAPWDJtvnGzm
         nqpdemoGNqtsVZfTSjaQjMRuq0Pg6Y9FXTnAjXYXKecgqZqKSLEWpDCqbRGV5jeQJb
         k/LFhtTSUcQagfWvDm8U8g6gri1T4wsxgoAIiMQo9UKPL0fneVaElXi+zQctAFS4ZU
         iY6W+rQhddbSZMyusSuWiwOFt3y+BaXnW+Kizbgmi3QOU0plBLmD1epxpvWxPFZMYa
         1WgAUayfMOfWlIulir2pHeO6vGCPnutI+bSQaOuzZQw6+uAAy28VXD+Wh103uYuNS/
         HPdT/hGcehVyA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, mcroce@linux.microsoft.com
Subject: Re: [PATCH net v2] net: openvswitch: fix TTL decrement exception
 action execution
Message-ID: <20201214181522.6279fbaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160733569860.3007.12938188180387116741.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
References: <160733569860.3007.12938188180387116741.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Dec 2020 05:08:39 -0500 Eelco Chaudron wrote:
> Currently, the exception actions are not processed correctly as the wrong
> dataset is passed. This change fixes this, including the misleading
> comment.
> 
> In addition, a check was added to make sure we work on an IPv4 packet,
> and not just assume if it's not IPv6 it's IPv4.
> 
> This was all tested using OVS with patch,
> https://patchwork.ozlabs.org/project/openvswitch/list/?series=21639,
> applied and sending packets with a TTL of 1 (and 0), both with IPv4
> and IPv6.
> 
> Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action netlink message format")
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
> v2: - Undid unnessesary paramerter removal from dec_ttl_exception_handler()
>     - Updated commit message to include testing information.

Applied now, and will send to stable soon-ish.

Thanks!
