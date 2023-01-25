Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF367B8D3
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 18:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjAYRtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 12:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236049AbjAYRtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 12:49:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B662412E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 09:49:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 909A8CE1D93
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 17:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F246CC433D2;
        Wed, 25 Jan 2023 17:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674668985;
        bh=vxWeYFw/L7fQFnPvrpBzjOvIUIgCbto0GZ3yC3l7qak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dAgu0NbKG5Wy4jGee9sRFY4z3M2sotfMZmE09PWvs5b8AEYfrqklR7CpuNcxasqiQ
         53hjUIzDI64ssFcRY7ibgxS4WCXn+JIO1436k8k1ZoNdGixWJv8WCnmkHrdI5BEcS3
         D6HzybSkHSAaxdZbs+6Vg+dJYCBhPfg6xsilKUllx/n5QzqWkWWzpA2G37Zug1aKy+
         aegYjRVUAnR8/bmRmawNw5Cys7JxST9zH7R0Y+r6Guzb1P5PC+BPV/PMpCEEbRULNw
         htG/6wGxvR9wlc1xjcb8OPQcaTBIGxWEkoCWPbXLzVg0A+sxm+M4Pv9LenGXHZOhBV
         NLw3kCy5CqIwQ==
Date:   Wed, 25 Jan 2023 09:49:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: Re: [patch net-next 00/12] devlink: Cleanup params usage
Message-ID: <20230125094944.5e362b76@kernel.org>
In-Reply-To: <20230125141412.1592256-1-jiri@resnulli.us>
References: <20230125141412.1592256-1-jiri@resnulli.us>
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

On Wed, 25 Jan 2023 15:14:00 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset takes care of small cleanup of devlink params usage.
> Some of the patches (first 2/3) are cosmetic, but I would like to
> point couple of interesting ones:
> 
> Patch 9 is the main one of this set and introduces devlink instance
> locking for params, similar to other devlink objects. That allows params
> to be registered/unregistered when devlink instance is registered.
> 
> Patches 10-12 change mlx5 code to register non-driverinit params in the
> code they are related to, and thanks to patch 8 this might be when
> devlink instance is registered - for example during devlink reload.

For the first 9:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
