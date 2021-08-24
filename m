Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE84F3F6C5D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhHXXwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235429AbhHXXwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 19:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E25361247;
        Tue, 24 Aug 2021 23:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629849129;
        bh=Y+YdA+2CMsgqdmmpnQ4ORVcuiQP93MiMTcXGC05a0x8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P76SmD/+8qyjtGB124/Yo5+ywHRqyZ/spCL7h8+blkI86gF0FXQs/HUJJQKpLiLkB
         5RhnTM7hVGcPauQvKe9vziKnZGWmCYjdD+tuW4vpXJ92WHG54t5ZP/mnfUizL8CcQW
         QZdvcpTD9z/yHCQjEDJULv8FWPSkrLXW5tFYHv9FKSDoqnVRncqLZkux0n++Ubo+Qr
         VyG5U5nnrWbBdqppsHYfnIjMAlucgE2zy/ypEtF8GXHuP7mJvPIAjimAfYoIeIKh7a
         Y/F7kc3fbApgHP9tJuRaH+CL0EDx9WuVA7IlO894qEzaDHqNbVTjydrfD5xjE7R+GP
         6sMorJjKV8UPA==
Date:   Tue, 24 Aug 2021 16:52:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Kangmin Park <l4stpr0gr4m@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: bridge: change return type of
 br_handle_ingress_vlan_tunnel
Message-ID: <20210824165208.36944d77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d37ff915-6d94-2d22-9e93-46b374fc47d7@nvidia.com>
References: <20210823102118.17966-1-l4stpr0gr4m@gmail.com>
        <d37ff915-6d94-2d22-9e93-46b374fc47d7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Aug 2021 13:25:20 +0300 Nikolay Aleksandrov wrote:
> On 23/08/2021 13:21, Kangmin Park wrote:
> > br_handle_ingress_vlan_tunnel() is only referenced in
> > br_handle_frame(). If br_handle_ingress_vlan_tunnel() is called and
> > return non-zero value, goto drop in br_handle_frame().
> > 
> > But, br_handle_ingress_vlan_tunnel() always return 0. So, the
> > routines that check the return value and goto drop has no meaning.
> > 
> > Therefore, change return type of br_handle_ingress_vlan_tunnel() to
> > void and remove if statement of br_handle_frame().
> > 
> > Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> 
> Looks good to me,
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Applied, thanks!
