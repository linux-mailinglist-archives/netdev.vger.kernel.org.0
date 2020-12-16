Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1253F2DC84E
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgLPV0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:26:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgLPV0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 16:26:48 -0500
Date:   Wed, 16 Dec 2020 13:26:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608153968;
        bh=XXxpaWRAfrL5uGgS2aOD5RVOf7QtzTzjiBIf/1QSx4M=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=WUh1NC0NYTlSbXGvTMUgTLQUDvrqd02VO/sUt0BVgaWpmdbGD11SCv1byiaX3pPWi
         D3w7cYlSfJanGMqWtvbgccAIzmYDDa/XOOOzeJOHRCa0cFkhg66hi1rm9aINkNrBhw
         91RHVX/d64QIi8h5E+LQBC4kh7ygszNHRIbA+aul/DkoP9PEmgtHzVoe0UKCZ4aOjP
         0lMNjuL2BCszddmN3MMDTkmhPs6BzvtV8rda+KpLCSHotl0I+Oik5J63708aXdkUp9
         OWGaXJnw+y6KMqdGjr0n6gdqDx2jvmobXmWg6L/YdwuMWyEDTge4nGLJa2mN7cLEg2
         +jU21PJq/F0fw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ibmvnic: merge do_change_param_reset into
 do_reset
Message-ID: <20201216132606.27201e16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215083008.85601-1-ljp@linux.ibm.com>
References: <20201215083008.85601-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 02:30:08 -0600 Lijun Pan wrote:
> Commit b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so
> linkwatch_event can run") introduced do_change_param_reset function to
> solve the rtnl lock issue. Majority of the code in do_change_param_reset
> duplicates do_reset. Also, we can handle the rtnl lock issue in do_reset
> itself. Hence merge do_change_param_reset back into do_reset to clean up
> the code.
> 
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
> This patch was accepted into net-next as 16b5f5ce351f but was reverted
> in 9f32c27eb4fc to yield to other under-testing patches. Since those
> bug fix patches are already accepted, resubmit this one.

The merge window has started now, and we're merging net into net-next
pretty much every week, so this could have been done sooner. Let's wait
for net-next to reopen.
