Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FF3470344
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhLJPAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:00:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58768 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhLJPAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 10:00:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E20AB8074E;
        Fri, 10 Dec 2021 14:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE26C00446;
        Fri, 10 Dec 2021 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639148205;
        bh=+uMYm4WJjN8YogEz9+YTtBe/ZPclSEvBz3bD+J7hqFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MgWOk3dyOXHQH5z79TeCzFh+ip4l/zFtY7Kgm/y7xIZHLRseJBLb5Abk4gNNG6ryt
         cvPI7rozMmoQPr+w4yaXAWSqGB1xYGiEJiF+sZ0Kxu/dtUk65w1q2Jr74VURc+ExEH
         A5wMHNEz402GstGmgQSrpb+oFjIZagSSDiEOziJvoRTf9ZtZU57w7ja4Edf9HTHdU/
         0mVRdrP2FaJGlo/iE8lUkQU3MO2IlU6I8exD1JYfGsQ5ht/dyi8JcqJcePClbpIRy6
         +xLEBtCzFNkIPKGUdYO94Zrz6kVALaSlRixggyYwTk2+pkAKTJmCwIUso60pALbu49
         MyURj0aOoqNew==
Date:   Fri, 10 Dec 2021 06:56:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     cgel.zte@gmail.com, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, shuah@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ye Guojin <ye.guojin@zte.com.cn>,
        ZealRobot <zealci@zte.com.cn>
Subject: Re: [PATCH] selftests: mptcp: remove duplicate include in
 mptcp_inq.c
Message-ID: <20211210065644.192f5159@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210065437.27c8fe23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211210071424.425773-1-ye.guojin@zte.com.cn>
        <ab84ca1f-0f43-d50c-c272-81f64ee31ce8@tessares.net>
        <20211210065437.27c8fe23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 06:54:37 -0800 Jakub Kicinski wrote:
> On Fri, 10 Dec 2021 10:58:27 +0100 Matthieu Baerts wrote:
> > Hi Ye,
> > 
> > On 10/12/2021 08:14, cgel.zte@gmail.com wrote:  
> > > From: Ye Guojin <ye.guojin@zte.com.cn>
> > > 
> > > 'sys/ioctl.h' included in 'mptcp_inq.c' is duplicated.    
> > 
> > Good catch, the modification looks good to me:
> > 
> > Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > 
> > 
> > This patch is for "net-next" tree as it fixes an issue introduced by a
> > patch only in this tree:
> > 
> > Fixes: b51880568f20 ("selftests: mptcp: add inq test case")
> > 
> > Regarding the commit message, please next time include the Fixes tag and
> > mention for which tree it is for in the FAQ [1], e.g. [PATCH net-next].
> > 
> > 
> > @David/Jakub: do you prefer a v2 with these modifications or is it fine
> > to apply this small patch directly in net-next tree?  
> 
> v1 is fine. Let me apply it right away and do the edits before I forget
> they are needed..

Actually, I take that back, let's hear from Mat, he may want to take
the patch via his tree.
