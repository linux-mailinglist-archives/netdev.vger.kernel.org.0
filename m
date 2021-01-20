Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241772FC645
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbhATBIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:08:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728363AbhATBIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:08:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEB8623108;
        Wed, 20 Jan 2021 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611104859;
        bh=ZTOqE5+SmJ+G62M/0zsxFEMQ10bW0OVdJLl3qhWqrVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EHymunlDb4ah4kr20TEd6EuOdnM4ruOPQ1DWFdvIgPGqZvSQF11Xz+WiVgdXUyvvR
         MAxPdUEO/lc1J7PMP76rf89DGSXo1mLBE2TVfjp5dmgRQI8cAXlTmn7sWlJrA4O9nd
         pp8+DoHUaJpYtScVJMS7yP1gELsYEET7vUY3U7WebfAh6Fs9Lpf2PwiPGKIDm054AD
         W2nqbKmNx3sOj7Aa2Jat5m3GUd1xPc50vSX6D012mNpH/+Gn8GxqcXlMTiJnQ/rOXa
         oxOQLrM0FsvFEuu32siDcEBmXbtMDs1OcjUq6eBAizJ/NCudH2rbj12f4Ht3qY1ecC
         fJiTJl/wMGOwg==
Date:   Tue, 19 Jan 2021 17:07:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Antoine Tenart <atenart@redhat.com>
Subject: Re: [PATCH net] selftests/net/fib_tests: remove duplicate log test
Message-ID: <20210119170737.0e92f9d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <03dfec85-56db-b3a6-5fbc-c97868cd8cbf@gmail.com>
References: <20210119025930.2810532-1-liuhangbin@gmail.com>
        <03dfec85-56db-b3a6-5fbc-c97868cd8cbf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 20:03:12 -0700 David Ahern wrote:
> On 1/18/21 7:59 PM, Hangbin Liu wrote:
> > The previous test added an address with a specified metric and check if
> > correspond route was created. I somehow added two logs for the same
> > test. Remove the duplicated one.
> > 
> > Reported-by: Antoine Tenart <atenart@redhat.com>
> > Fixes: 0d29169a708b ("selftests/net/fib_tests: update addr_metric_test for peer route testing")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  tools/testing/selftests/net/fib_tests.sh | 1 -
> >  1 file changed, 1 deletion(-)
> >   
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
