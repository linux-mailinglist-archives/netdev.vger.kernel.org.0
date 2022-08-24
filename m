Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57495A0126
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbiHXSMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240427AbiHXSMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:12:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096E56CD1C
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 11:12:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91DB461759
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 18:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEA0C433C1;
        Wed, 24 Aug 2022 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661364724;
        bh=C3N2+TqNgls2cuFEhcJnKBfUPjaThWjj4V3zFKEmBw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T7pwhQVlbn07YQP31zecU4P00Os5p1tInXuRK6CquCYWI7VR6t1OUTPeHUKVbh6pi
         I8fzr1xoCvptWKVOGu8Sy/xSDjf4Pevh47IlZZHeMDBQW4m5OkxzI6ThIGmwiHeJNw
         Ue0qiU9iKVm9IhRk2xR9Kcuq+L7Q4ykNX8myR1+XIZvSQze595+cY543Mt3d77iCdJ
         9/eUJZ5m7P+/F3alVPLT2DZUmOxo0m/klMEe9gNwoRIvUOQxmpxP3OVGAIYEvRxMLG
         cfMW2K6CWm1hUBU5FsGMAMzI6kLEGNK4DBn24NPLOLROzWQXaM8GZZG7aPqMeMBZjB
         6jo6W9w9fkrPg==
Date:   Wed, 24 Aug 2022 11:12:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Message-ID: <20220824111202.140ad1fb@kernel.org>
In-Reply-To: <CO1PR11MB508905A2019ED7C98C2CEB6FD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220822170247.974743-1-jiri@resnulli.us>
        <20220822170247.974743-5-jiri@resnulli.us>
        <20220822200116.76f1d11b@kernel.org>
        <YwR1URDk56l5VLDZ@nanopsycho>
        <20220823123121.0ae00393@kernel.org>
        <YwXmNqxEYDk+An2A@nanopsycho>
        <CO1PR11MB508905A2019ED7C98C2CEB6FD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 17:31:46 +0000 Keller, Jacob E wrote:
> > Well, I thought it would be polite to let the user know what component
> > he can pass to the kernel. Now, it is try-fail/success game. But if you
> > think it is okay to let the user in the doubts, no problem. I will drop
> > the patch.  
> 
> I would prefer exposing this as well since it lets the user know which names are valid for flashing.
> 
> I do have some patches for ice to support individual component update as well I can post soon.

Gentlemen, I had multiple false starts myself adding information 
to device info, flashing and health reporters. Adding APIs which
will actually be _useful_ in production is not trivial. I have 
the advantage of being able to talk to Meta's production team first
so none of my patches made it to the list. 

To be clear I'm not saying (nor believe) that Meta's needs or processes 
are in any way "the right way to go" or otherwise should dictate
the APIs. It's just an example I have direct access to.

I don't think I'm out of line asking you for a clear use case.
Just knowing something is flashable is not sufficient information,
the user needs to know what the component actually describes and
what binary to use to update it.

Since we have no use of component flashing now it's all cart
before the horse.

Coincidentally I doubt anyone is making serious use of the health
infrastructure.
