Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDC1623B8E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 07:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiKJGAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 01:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKJGAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 01:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5006923E92
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 22:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD6FE61D6A
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AA5C433D6;
        Thu, 10 Nov 2022 06:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668060021;
        bh=lKXbWYhcVeuR6B/yWYHf2f2ufFwMEr1XFPG+9GHdkzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZdgG3aC8eratLFAvNkCDzkomSd8uXZB5Z2gKFCvurpbW07uIQ+X2rxZNMy8AGyMGk
         4G51nmCLfUsGd4qucbWRP8Ysh0BiCpAyBTu7iHwzYe99ac7yByOLH933kVoTyKRNQv
         +Q/X66ss7eyJpDbAPmSyY8L4uKHPZqjBJPDuoKELr/bFPO1ROwkb+hHseOmjABrYiE
         vaEwoIzbo2xNw69pLQyzA1cSFaEM+ShMGx9bobEH7vERYZCalLWqnXE9yc8jEzNrN3
         2CtMn5ZZR8elWyj38DGyNbY2kI/rJcF7602079339J0fu8tifYt7DTz6Mh3eR4iKRI
         WaxXCcjujn2+w==
Date:   Thu, 10 Nov 2022 08:00:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jonathan Lemon <bsd@meta.com>,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] genetlink: fix policy dump for dumps
Message-ID: <Y2yTcHjGLVp6mOAG@unreal>
References: <20221108204041.330172-1-kuba@kernel.org>
 <Y2vnesR4cNMVF4Jn@unreal>
 <Y2v4fVbvUdZ80A9E@unreal>
 <20221109121118.660382b5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109121118.660382b5@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 12:11:18PM -0800, Jakub Kicinski wrote:
> On Wed, 9 Nov 2022 20:59:09 +0200 Leon Romanovsky wrote:
> > > I added your updated patch to my CI run. Unfortunately, the regression
> > > system is overloaded due to nightly regression so won't be able to get
> > > results in sensible time frame.
> > 
> > Tested-by: Leon Romanovsky <leonro@nvidia.com>
> 
> To be clear - did you test as posted or v2? Or doesn't matter?
> I'm wondering how applicable the tag is to v2.

I tested this version https://lore.kernel.org/all/20221108154426.3a882067@kernel.org

Thanks
