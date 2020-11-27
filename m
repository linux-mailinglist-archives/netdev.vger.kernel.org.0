Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B52F2C6CC8
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgK0VA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgK0U74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 15:59:56 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0705B2223D;
        Fri, 27 Nov 2020 20:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606510795;
        bh=bxSjavKX3T7Uc8ajDIKdSScWs0LzCWOafDU4UJ7u/mw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BEyyl4EXiS8DnDtOXaFWcSrzeZZNBzFAHglISBvnThs5Fy16tau6oXcLz4J4YSy8Q
         OSAyYzFuOBuNtItgau91BxEfaX+3S5PcG2lw5fUqG0Dgm1x4tChKjQUEBkLdK0/5B9
         SSdm6W4P3TZDuUtN678fsA7q7lnM9Cwc1dmsadVI=
Date:   Fri, 27 Nov 2020 12:59:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <fugang.duan@nxp.com>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <geert@linux-m68k.org>, <netdev@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM: runtime: replace pm_runtime_resume_and_get with
 pm_runtime_resume_and_get_sync
Message-ID: <20201127125953.49f270d4@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127135256.2065725-1-zhangqilong3@huawei.com>
References: <20201127135256.2065725-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 21:52:56 +0800 Zhang Qilong wrote:
> In the pm_runtime_resume_and_get, pm_runtime_resume() is
> synchronous. Caller had to look into the implementation
> to verify that a change for pm_runtime_resume_and_get[0].
> So we use pm_rauntime_resume_and_get_sync to replace it
> to avoid making the same mistake while fixing
> pm_runtime_get_sync.
> 
> [0]https://lore.kernel.org/netdev/20201110092933.3342784-1-zhangqilong3@huawei.com/T/#t
> Fixes: dd8088d5a8969dc2 ("PM runtime: Add pm_runtime_resume_and_get to deal with usage counter")
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

Fixes tag: Fixes: dd8088d5a8969dc2 ("PM runtime: Add pm_runtime_resume_and_get to deal with usage counter")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
