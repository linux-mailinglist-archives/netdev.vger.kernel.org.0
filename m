Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E44B49DA86
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 07:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbiA0GS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 01:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbiA0GSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 01:18:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE5DC061714;
        Wed, 26 Jan 2022 22:18:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B00A6618BF;
        Thu, 27 Jan 2022 06:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D72EC340E4;
        Thu, 27 Jan 2022 06:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643264333;
        bh=JWnQY8Vldoj9hxONqmQ+vJa9OiQSxZzxdDUkq1+N79E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FAUl2LzrWlpwEP112G3UU/39C9EvdSXdFCcHOazdmJP/tuo4Zyb0jHXYwnI+UDR7z
         Pipxzbt4zwcnyx0MXGLn7K3JbNCXObtFzXskYntgIX4Go/o/e4wExnoTSbUoxRrcyN
         u9Z4WJaRytHg3Yd/Ozz0Zs624LNPcFApptbeUJKprSjda/pXX8gvTWcV7TIko1/ON/
         e8mwTpisrMovyaU8ZE29xqenWofn3JHmsKCzpViEWbtScxQHQS0k5dUfNjWSDmQ21Q
         pFJLpc6inFqrcWFsnEHGAORrtRURBa6JY+WyT47t8BEqnilplvqJJgIeL/YtksZnd8
         s1q2HSiFL8vKg==
Date:   Thu, 27 Jan 2022 08:18:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net/smc: Spread workload over multiple cores
Message-ID: <YfI5SE4P+NPZVkaE@unreal>
References: <20220126130140.66316-1-tonylu@linux.alibaba.com>
 <20220126152916.GO8034@ziepe.ca>
 <YfIPLn2AX774b6Wl@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfIPLn2AX774b6Wl@TonyMac-Alibaba>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:19:10AM +0800, Tony Lu wrote:
> On Wed, Jan 26, 2022 at 11:29:16AM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 26, 2022 at 09:01:39PM +0800, Tony Lu wrote:
> > > Currently, SMC creates one CQ per IB device, and shares this cq among
> > > all the QPs of links. Meanwhile, this CQ is always binded to the first
> > > completion vector, the IRQ affinity of this vector binds to some CPU
> > > core.
> > 
> > As we said in the RFC discussion this should be updated to use the
> > proper core APIS, not re-implement them in a driver like this.
> 
> Thanks for your advice. As I replied in the RFC, I will start to do that
> after a clear plan is determined.
> 
> Glad to hear your advice. 

Please do right thing from the beginning.

You are improving code from 2017 to be aligned with core code that
exists from 2020.

Thanks

> 
> Tony Lu
> 
