Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC06165CBE3
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 03:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbjADCbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 21:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbjADCbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 21:31:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7239393
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 18:31:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 329A46157D
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 02:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9B8C433EF;
        Wed,  4 Jan 2023 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672799501;
        bh=QqgE1oQqo3G/oi0keBML00ubQ4HlzqluziwmmgnbKug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GVVjDHUOaF6chxmg0M9GNFz1juEgwEcckRJhbQg+79UR7LRVtWxC35Bu9K15YQPYQ
         vetaks+PYwa4/Z/fcXMpXrYgbtMkQu++k0ckpcHyUzh0g3S96d5ZsEM+wyqLlUYJ7A
         5XxHs2zTJ1fS9Aje2W+5IJGySLisj7GZd2dDaA0DuSqut13+qIoH0A0UsABvXS1GAF
         lFxqNDK5xonpDu8pnAUOb3FlJcrSxOlzfA9hBC87dgT10L/j05p5o3icBmsZXjMQRX
         qy3rnXel7u0uxF6Wq1VCKQ3ADBzB0h+jlHwopHmNYHc45txYfYlyjdR7Pob0uA+4KI
         N7rd30gEALHZw==
Date:   Tue, 3 Jan 2023 18:31:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 01/10] devlink: bump the instance index directly
 when iterating
Message-ID: <20230103183140.50568412@kernel.org>
In-Reply-To: <Y7PatJruZVTEz7Pb@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-2-kuba@kernel.org>
        <Y7LbF0+aRjT6AkZ+@nanopsycho>
        <20230102144813.1363cb38@kernel.org>
        <Y7PatJruZVTEz7Pb@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Jan 2023 08:35:16 +0100 Jiri Pirko wrote:
> >> To be honest, this "we something" desctiption style makes things quite
> >> hard to understand. Could you please rephrase it to actually talk
> >> about the entities in code?  
> >
> >Could you be more specific? I'm probably misunderstanding but it sounds
> >to me like you're asking me to describe what I'm doing rather than
> >the background and motivation.  
> 
> "We" is us, you me and other people. It is weird to talk about the code
> and what there as "we do", "we use" etc. It's quite confusing as the
> reader it not able to distinguish if you are talking about code or
> people (developers in this case). I'm just askin if it is possible
> to make the descriptions easier to understand.

Actually thinking about it again, this patch is not strictly
necessary. I'll rewrite the commit message to just say it's a
simplification based on the fact we don't have multi-index entries.
