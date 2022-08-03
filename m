Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27710588F20
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiHCPKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbiHCPKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:10:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED171F62A
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:10:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59872B822B0
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 15:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ABEC433C1;
        Wed,  3 Aug 2022 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659539405;
        bh=oOU918KuKRDmTdEsfJEeYqYoWoZ3iJrC6e7HEmdVn40=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XR9vNn/ZDIQywHsLG2zTb3y3Af9N/wHYtf5bPbqj/DzkQ7Z93LPu6X5egd2eKrxi7
         jsFXUlGZALS5N7DCZ3h2zt9rgiqzn2N4NfGg1oQwtSyU4UngA4+X3nB8hOaHM5cSvB
         6Mkz+1AuDech4OP2aHM2M8VqXF/7KqLC/nlAJE3oEiBNYbWbjn7DDnGwyNuI3lG6hs
         rmwyMOYnDeRnZ+ZSxCcw05oqaSniHVAq1Xf8w/ED4GRICAlXzMGCPJRKrhTJbA17zg
         F9LKMKNv9emxHofnpadNUc5bBSpy9YxmHfZDkkI0QLKnIfvK3h1SO/mTgslCKxl90D
         UlXn7RCkUr2zw==
Message-ID: <d475db70-5653-849d-37a8-65082698dcc6@kernel.org>
Date:   Wed, 3 Aug 2022 09:10:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute2-next v5 1/2] devlink: update the devlink.h
Content-Language: en-US
To:     Vikas Gupta <vikas.gupta@broadcom.com>, jiri@nvidia.com,
        stephen@networkplumber.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
References: <20220803091025.30800-1-vikas.gupta@broadcom.com>
 <20220803091025.30800-2-vikas.gupta@broadcom.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220803091025.30800-2-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/22 3:10 AM, Vikas Gupta wrote:
> update the devlink.h to comaptible with net-next kernel.
> 
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> ---
>  include/uapi/linux/devlink.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 

always send patch sets against top of tree -- iproute2-next in this case.

This patch is not needed as the header file has already been updated.
