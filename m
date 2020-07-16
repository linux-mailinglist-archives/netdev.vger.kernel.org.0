Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE02222D5F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgGPVGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgGPVGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:06:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAA47207DD;
        Thu, 16 Jul 2020 21:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594933564;
        bh=0OGp5jt38BwSDYZlDxWMbGbrMFb7svBskFO9ftJ6/ws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VYsCV73wVHMIzzLWtsqvUDlmUNY2qbo+diEhcLImfD+6+HhNdnsM2cyt8sPG4oAc2
         cjYwDgbfqEKMiokfkxCUsUpQX4c8F8M38E1OvRjFjtxXQCgem5FGuWUHX6O3oRJGpf
         8gftfLx7jQ3poOuMew58AXhuQHe5UoVpbdxpVMRs=
Date:   Thu, 16 Jul 2020 14:06:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200716140602.2a23530b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87a6zz9owa.fsf@osv.gnss.ru>
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200714162802.11926-1-sorganov@gmail.com>
        <20200716112432.127b9d99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87a6zz9owa.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 23:38:13 +0300 Sergey Organov wrote:
> > Applied, and added to the stable queue, thanks!  
> 
> Thanks, and I've also got a no-brainer patch that lets this bug fix
> compile as-is with older kernels, where there were no phy_has_hwtstamp()
> function. Dunno how to properly handle this. Here is the patch (on
> top of v4.9.146), just in case:

I see, I'll only add it to 5.7. By default we backport net fixes to
the two most recent releases, anyway. Could you send a patch that will 
work on 4.4 or 4.9 - 5.4 to Greg yourself once this hits Linus's tree
in a week or two?
