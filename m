Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585C52AA206
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgKGBaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbgKGBaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 20:30:30 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B01A320720;
        Sat,  7 Nov 2020 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604712630;
        bh=vF0C8wz4M/uY4AHsyooxIkvLo7CRA7A8pr3KQ0xdG0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PdjWOpRtK7AjxbOkGxdiGSBetvTzSBlz1XEIUgWKYBIR+GPyNW8By8l8bUylXex6k
         IEChhmaEA1vk3ZTrfSOG1eV5Mv1lMGQX9yj7jpnfzsSjGw+qI1DeGwdDAhXj860q1N
         fJWzmNmy8jw4KFDy8ocFw/Qf4D6lI9u+Zx4wA6RM=
Date:   Fri, 6 Nov 2020 17:30:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next] Revert ibmvnic merge do_change_param_reset
 into do_reset
Message-ID: <20201106173028.2490f7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106191745.1679846-1-drt@linux.ibm.com>
References: <20201106191745.1679846-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 14:17:45 -0500 Dany Madden wrote:
> This reverts commit 16b5f5ce351f8709a6b518cc3cbf240c378305bf
> where it restructures do_reset. There are patches being tested that
> would require major rework if this is committed first. 
> 
> We will resend this after the other patches have been applied.
> 
> Signed-off-by: Dany Madden <drt@linux.ibm.com>

Applied, thanks.
