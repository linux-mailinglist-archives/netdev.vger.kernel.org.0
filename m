Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAB539362E
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 21:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhE0TXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 15:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhE0TXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 15:23:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F070600D4;
        Thu, 27 May 2021 19:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622143305;
        bh=HdgeWXm2oqrmiwWhjn2rbiLTCJCom2GcNMlSHtMaWJw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VwO6wtXjA9AHg22s/NQBeHFBS6q2JvP9EKYdt3vKWL/LylDBzxCChdeHNPfq1BGLb
         vDku4Pks/mR4ZiEkOHzFnfja/G+zG9wf/bGcrTTVWWrqUMHOs2B6URKCwo2GJw5wwk
         RoCfwtjDJwivS4ye5H10ewVHdMRrzY8Sj5eyK2xODmAlzVLZfrYhNqJSbAId2VdYMJ
         M9Az7ylKrfKQSZrQ7jY/Ew+qPUBlvTDmkPpP2+MwZAzazKNWrHzMMKriBEankYVeTC
         1v2jn1XrY0FXexoFfP4MwgwIeIuTT6cp6MqVbcan5mVGdRBFSq0invxtQ62gKUwy4F
         2poju+IUgOM/A==
Date:   Thu, 27 May 2021 12:21:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, frieder.schrempf@kontron.de, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V1 net-next 2/2] net: fec: add ndo_select_queue to fix
 TX bandwidth fluctuations
Message-ID: <20210527122144.2f260a26@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527120722.16965-3-qiangqing.zhang@nxp.com>
References: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
        <20210527120722.16965-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 20:07:22 +0800 Joakim Zhang wrote:
> +u16 fec_enet_get_raw_vlan_tci(struct sk_buff *skb)

Let's perhaps wait for the testing with a repost but both functions
added in this patch need to be static.
