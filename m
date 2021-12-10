Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9550E47033E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbhLJO6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242489AbhLJO6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:58:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ACDC061746;
        Fri, 10 Dec 2021 06:54:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9E9DCCE2B6C;
        Fri, 10 Dec 2021 14:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73718C00446;
        Fri, 10 Dec 2021 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639148078;
        bh=Q1K2S4f0nrxeNfaTP4vRuZ3EtV7zVYEqjCEZjFJRS+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Udr8ls2mK7w9ihkao+4Z5vWlqANlkOFX7qwKDb8sSPPTifcf4WXnu7Ymji57LKnjN
         U3UwUDqO9gCgsxG4jYqnyQLvXIv1pvG5GpNGMd9zXq56usxfVC/5RvYot3V6Uc9aMn
         C3N5UlzDdgqcA9pTTKq3mwFXnFF0Dm1rF0dlEz0rVIpuF8Wc4W575g9GyxHKeWOIHr
         XC3l3Vlj6S2zbovSoGfdE+MqzYZKBO+DUTxzq/PC/RU4zhKMtRoVDzaQuy9O1kAWfu
         o2QcVLR73Mmi1+XrtBs49ETohfnN9I3/e8rw3ynFcmQF/toY6TZKqu6m5/ZlgR9+UP
         SXeEevHP+Yyeg==
Date:   Fri, 10 Dec 2021 06:54:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     cgel.zte@gmail.com, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, shuah@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ye Guojin <ye.guojin@zte.com.cn>,
        ZealRobot <zealci@zte.com.cn>
Subject: Re: [PATCH] selftests: mptcp: remove duplicate include in
 mptcp_inq.c
Message-ID: <20211210065437.27c8fe23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ab84ca1f-0f43-d50c-c272-81f64ee31ce8@tessares.net>
References: <20211210071424.425773-1-ye.guojin@zte.com.cn>
        <ab84ca1f-0f43-d50c-c272-81f64ee31ce8@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 10:58:27 +0100 Matthieu Baerts wrote:
> Hi Ye,
> 
> On 10/12/2021 08:14, cgel.zte@gmail.com wrote:
> > From: Ye Guojin <ye.guojin@zte.com.cn>
> > 
> > 'sys/ioctl.h' included in 'mptcp_inq.c' is duplicated.  
> 
> Good catch, the modification looks good to me:
> 
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> 
> 
> This patch is for "net-next" tree as it fixes an issue introduced by a
> patch only in this tree:
> 
> Fixes: b51880568f20 ("selftests: mptcp: add inq test case")
> 
> Regarding the commit message, please next time include the Fixes tag and
> mention for which tree it is for in the FAQ [1], e.g. [PATCH net-next].
> 
> 
> @David/Jakub: do you prefer a v2 with these modifications or is it fine
> to apply this small patch directly in net-next tree?

v1 is fine. Let me apply it right away and do the edits before I forget
they are needed..
