Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBE92A5A6D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 00:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgKCXJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 18:09:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729069AbgKCXJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 18:09:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9DB5223EA;
        Tue,  3 Nov 2020 23:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604444957;
        bh=fIm9Z4c1Bsq6PjgAgjLLY2qRGy3aIGzUoVAniAW+MgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CwUZEr4pLoBnNQvxmMP7gOrxU1dGKy9Tagi1yqK/RSyhI+QWgSNsxoBX1mZHOkJ0h
         +ej4SH3+6u5PYTLz4NJNwMisFObgisC3TSktaEi4/MpnQudiHliU3ZpXKRgSzJ0daV
         vJQw6wyurL5ogst0hOMKJIa+Vg63koIo1OJFYz4o=
Date:   Tue, 3 Nov 2020 15:09:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: merge do_change_param_reset into
 do_reset
Message-ID: <20201103150915.4411306e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201031094645.17255-1-ljp@linux.ibm.com>
References: <20201031094645.17255-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 04:46:45 -0500 Lijun Pan wrote:
> Commit b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so
> linkwatch_event can run") introduced do_change_param_reset function to
> solve the rtnl lock issue. Majority of the code in do_change_param_reset
> duplicates do_reset. Also, we can handle the rtnl lock issue in do_reset
> itself. Hence merge do_change_param_reset back into do_reset to clean up
> the code.
> 
> Fixes: b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

Applied, thanks!
