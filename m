Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0172CF7AC
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 00:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbgLDXpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbgLDXpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 18:45:18 -0500
Date:   Fri, 4 Dec 2020 15:44:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607125492;
        bh=t1iAV5AIC3nrJes6h0m7zblB4Bw7MJPcnXdRTGhhU+g=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZXfIOdp0eRvROycO9EJestm1joqnRfhwchN+u0AxHiLuIzM6QndtVtbXPhBwu1s6t
         5Axb0Lyf8Si4IvJwukiIX1ZmtOaiRQFuxJ34u+YIRbq+VH36OqKSRuVzMCqHOMY6JJ
         LiLHvBXZs3SvORC7Y+kE1VSJeBiWeYL5YQjUACKVMDEza0qPisjwkRYyoEuLBp2hqL
         x4OLfixlA+cDyUE7wgxZsMWCpZtVPhErhaUdd6/9qetjfVl+V6c2sln8BwTAl2yB+I
         kcp2pzZYLR/NfBoelqt54kAL+CQuacs2y2v4Ws/PGed5e7TxSnSjrFZgwof10aNAM/
         9nx27TFgyllog==
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Eelco Chaudron" <echaudro@redhat.com>,
        "Wang Hai" <wanghai38@huawei.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] openvswitch: fix error return code in
 validate_and_copy_dec_ttl()
Message-ID: <20201204154451.011d9034@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <40A832BA-4065-4FB2-9C33-D41CF4B336CF@redhat.com>
References: <20201204114314.1596-1-wanghai38@huawei.com>
        <40A832BA-4065-4FB2-9C33-D41CF4B336CF@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Dec 2020 13:07:48 +0100 Eelco Chaudron wrote:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Changing 'return start' to 'return action_start' can fix this bug.
> >
> > Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action 
> > netlink message format")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Wang Hai <wanghai38@huawei.com>  
> 
> Thanks for fixing!
> 
> Reviewed-by: Eelco Chaudron <echaudro@redhat.com>

Applied, thanks!
