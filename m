Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D248264E1F6
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiLOTse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLOTsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:48:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC63532C6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:48:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF16E61F0F
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045DDC433D2;
        Thu, 15 Dec 2022 19:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671133710;
        bh=HSHUPbNvYgwPR2IIeq/Avd8BoxADtwTgnHKti/V2agc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XF2/NjpV0EK13EgVtV1REhUh1lVgHlOmMS2YzMuHmGQmUfGwAHaAkvZxxx0xgsCRh
         Acbk+RbNIQ7pdNhXh7xxyrqJowhgHNp/TEVlvvo/zvX+s29KighmCxzNdD+PbAGQD0
         9kQ31wT4+5nPkV7CAysG/bG2hnpO8cy6zhXFGsBNNA/vZnftKwIA/ZsERUNw0sM5x2
         TcFm4G9J5CldbBD3mWJsgq4zawAj7ltAc+xuncGMd6+jLN/sxdOb4juicbKYBunrOO
         5eApJxvK8Aprx77v27WkpP6aP0ylGRJlcU3fZILFwpMIsUE4jQULIAIgs2yrbPqhXn
         rHU3JlrmWX7yw==
Date:   Thu, 15 Dec 2022 11:48:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <leon@kernel.org>
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated
 directory
Message-ID: <20221215114829.5bc59d7a@kernel.org>
In-Reply-To: <c7c98e4a-5f41-2095-c500-c141ea56a21a@intel.com>
References: <20221215020155.1619839-1-kuba@kernel.org>
        <20221215020155.1619839-2-kuba@kernel.org>
        <Y5ruLxvHdlhhY+kU@nanopsycho>
        <20221215110925.6a9d0f4a@kernel.org>
        <c7c98e4a-5f41-2095-c500-c141ea56a21a@intel.com>
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

On Thu, 15 Dec 2022 11:29:02 -0800 Jacob Keller wrote:
> >> What's "basic" about it? It sounds a bit misleading.  
> > 
> > Agreed, but try to suggest a better name ;)  the_rest_of_it.c ? :)
> 
> I tried to think of something, but you already use core elsewhere in the
> series. If our long term goal really is to split everything out then
> maybe "leftover.c"? Or just "devlink/devlink.c"

leftover.c is fine by me. Jiri?
