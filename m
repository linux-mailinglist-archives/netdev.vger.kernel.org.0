Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883DE6E10A3
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjDMPJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjDMPJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:09:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3ABA5D9
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:09:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0FD563F68
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 15:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09315C4339E;
        Thu, 13 Apr 2023 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681398540;
        bh=ZYRDjh91XUedWwjPy6+t7U38/w8vc8z0TjMQNoV8qbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jg83JffNxRRM1vC8G8MI66W7nQ0YT9p9OqMgU6yfFrLyDi9BWmrOnyq1Z2XnoukYm
         mAUJwz9/8bs9E6YTV90RgybNyfBbTQkFHiwDf8J2HRLba16PmtLkx9A9Lhky7gwU+k
         XYEqX7Olc9rDR6t7cfclQTXspIGVej2XqBnQLhTIDRlj0EMU81Wpu46FzbLllwV0J/
         iiODIxT8MGxeUf1sDKXkFceYO9agMDn1qKxu2hnKdCFsvjbgOkGqx1MBhcxzwMCOP8
         WD5DrCw+SskemfpPoBtveak5ZGJlIwJh68oTT46969AE1uhNDdAlOHU9R4aTyjKyoy
         Ny8R07wwN2CaA==
Date:   Thu, 13 Apr 2023 08:08:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 02/14] pds_core: add devcmd device
 interfaces
Message-ID: <20230413080858.26c2f3eb@kernel.org>
In-Reply-To: <20230413083325.GD17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
        <20230406234143.11318-3-shannon.nelson@amd.com>
        <20230409114608.GA182481@unreal>
        <5394cb12-05fd-dcb9-eea1-6b64ff0232d6@amd.com>
        <20230413083325.GD17993@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 11:33:25 +0300 Leon Romanovsky wrote:
> > > This is only relevant here, everything else is not applicable.
> > >   
> > > > +     PDS_DRIVER_WIN     = 2,
> > > > +     PDS_DRIVER_DPDK    = 3,
> > > > +     PDS_DRIVER_FREEBSD = 4,
> > > > +     PDS_DRIVER_IPXE    = 5,
> > > > +     PDS_DRIVER_ESXI    = 6,
> > > > +};  
> > 
> > Yes, they are rather pointless for the Linux kernel, but it is part of
> > documenting the device interface.  
> 
> It is not used in upstream kernel.

If Shannon prefers to keep the full enum, I think that's fine.
Declaring the full interface is often the only way a user can
try to figure out how the API works, as most vendors don't publish
their APIs.
