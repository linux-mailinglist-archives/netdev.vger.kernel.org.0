Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C9F6165CD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiKBPNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKBPNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:13:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89D9BF52;
        Wed,  2 Nov 2022 08:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8470061A0A;
        Wed,  2 Nov 2022 15:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C38EC433D6;
        Wed,  2 Nov 2022 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667402007;
        bh=LUnOnW4tgh1XpcCehWlivz450qSNZbyiiku2P0W6OTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AnM6G2z1hbh+Opkvhahn6qXMhZ9rhdy3h9XvsvofPtcQjjqoYn0qynTMfdO8I6aMo
         4k+/mznqkZlfarA4z5uNE9v/2cxzvPohsJfPwabBII1IHintbCPOg4DG4HBRzQ0iAc
         9omlfbPN3NSLRgHdZ/zJURLdMZvVcWlYu2J6Zpv3dpw6ihsy1fmgW8EyIsgzXB1kGU
         3CM/AOd9kszorPMjkGVLnpMKr6EBwKe5CLc+1sO50fq+h6iGBaJ2+HDhiW3qbemvEo
         HXUeLN+IkLhtw9nGuxe1yMPn4Z19ddBui8qAjlZpD8iHteNNr29Ruv3jjb6IYd6RIl
         +jfc3aVwypO8w==
Date:   Wed, 2 Nov 2022 08:13:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 13/13] net: expose devlink port over
 rtnetlink
Message-ID: <20221102081325.2086edd8@kernel.org>
In-Reply-To: <20221102081006.70a81e89@kernel.org>
References: <20221031124248.484405-1-jiri@resnulli.us>
        <20221031124248.484405-14-jiri@resnulli.us>
        <20221101091834.4dbdcbc1@kernel.org>
        <Y2JS4bBhPB1qbDi9@nanopsycho>
        <20221102081006.70a81e89@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 08:10:06 -0700 Jakub Kicinski wrote:
> On Wed, 2 Nov 2022 12:22:09 +0100 Jiri Pirko wrote:
> >> Why produce the empty nest if port is not set?    
> > 
> > Empty nest indicates that kernel supports this but there is no devlink
> > port associated. I see no other way to indicate this :/  
> 
> Maybe it's time to plumb policies thru to classic netlink, instead of
> creating weird attribute constructs?

Not a blocker, FWIW, just pointing out a better alternative.
