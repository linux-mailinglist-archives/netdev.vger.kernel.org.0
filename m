Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8C32C1797
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgKWVWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgKWVWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 16:22:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 403F3206B5;
        Mon, 23 Nov 2020 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606166565;
        bh=WRvB9EZYAq+H/utN2y981VxF8dmS1rw4I7B1PF4PL9E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lEPgI05J0bNRvH/iR6B4GIJT9thVl3v6DGrGvM4loZar5+A6+CxWpZsbV/CtaCSHb
         TSrVBRLmPjUJXGlb5vEMaB6+Uerhw+hHEPbrjFv1G7WbBk73hdGKMik4c1/lUTB1+x
         VDWbAMc5Kkft38ZsXxDPi/ElYGtzg6bybL8uuaok=
Date:   Mon, 23 Nov 2020 13:22:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: alias action flags with TCA_ACT_
 prefix
Message-ID: <20201123132244.55768678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201121160902.808705-1-vlad@buslov.dev>
References: <20201121160902.808705-1-vlad@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 18:09:02 +0200 Vlad Buslov wrote:
> Currently both filter and action flags use same "TCA_" prefix which makes
> them hard to distinguish to code and confusing for users. Create aliases
> for existing action flags constants with "TCA_ACT_" prefix.
> 
> Signed-off-by: Vlad Buslov <vlad@buslov.dev>

Are we expecting to add both aliases for all new flags?

TCA_FLAG_TERSE_DUMP exists only in net-next, we could rename it, right?
