Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5025D46F457
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 20:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhLIT5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 14:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhLIT5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 14:57:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE54C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 11:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5D7CCE27F6
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 19:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7849C004DD;
        Thu,  9 Dec 2021 19:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639079633;
        bh=fBei59q87FfK6n3a7lmHKqze4sbJr6LFIOq9z0/MkQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AThyXko0KL22wMWp1OSKhKHds1Vbj1m3dBWFWk6oD4EJmCqBkJaT6WVhu3dxT7QCK
         iuKcyu5WPvywV3dzHc6zthFKd0HK8sUGtrNTnrW4yJNbTLW6DVx90V4rVKNcnfRru1
         Ir94Qr820lnJHtBo4LqejwGbwRTG8o3asuMyhh5o2qw6QTkWOMDHCwM3z8I2S1mb6o
         E1zHu2I4Q8eG0ZrBiVTzc3J6/mIvw5djzu3VkzlZxNxQjgbaz+wbFDCzGf8SfUOerp
         MhzHApw2iSpbYcmJxjzD8VpLEoPLgBkUNNKN5dmdUjbKAlySOXNUW99m9itBVsC7In
         bkBSSqNKmXxsg==
Date:   Thu, 9 Dec 2021 11:53:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <amwang@redhat.com>
Subject: Re: [PATCH net-next] xfrm: use net device refcount tracker helpers
Message-ID: <20211209115351.5f4967a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211209092036.GK427717@gauss3.secunet.de>
References: <20211207193203.2706158-1-eric.dumazet@gmail.com>
        <20211209092036.GK427717@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Dec 2021 10:20:36 +0100 Steffen Klassert wrote:
> On Tue, Dec 07, 2021 at 11:32:03AM -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > release dev before returning error")
> > 
> > Fixes: 9038c320001d ("net: dst: add net device refcount tracking to dst_entry")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Cong Wang <amwang@redhat.com>
> > Cc: Steffen Klassert <steffen.klassert@secunet.com>  
> 
> As the refcount tracking infrastructure is not yet in ipsec-next:
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Applied, thanks!

