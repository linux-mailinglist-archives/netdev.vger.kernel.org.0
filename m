Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A855A1E05
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiHZBOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244166AbiHZBOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:14:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1794DB52
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 18:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E667B82F5B
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF10C433C1;
        Fri, 26 Aug 2022 01:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661476488;
        bh=VfObAsnlaZ9IlMnKfJKaygNpef2m24IjFfbyedvcjac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k8nCBT04PRExcRk1Di/0XRw/iujp/GriPbMhqjIbjEZHvjUfu//XIFxeKmkgWRRfs
         c5O1cDlFis//YY1A7FQJ9dArDFwL7Tt0qCg8zl4ep3ELqLMpnMvJ9jAnnIS6XMvuCm
         ZPXPLwTYuQ8XHBzc4qO3udEOzkvEKwTZ9qB3OrF7pSPlB0AC9/Nq9am0hiE5A9SHaL
         HE+wJowL9t+ki1SB8aB3imrG2wu9dZ4zKSM7E8L1gODxr609+IY6eqS9LUWx4tJeRD
         /Ntr30dSbMnxbaWj3qZrg9fS9tIrBowcMP+P9vCD495nIqTreiwbslkjf2//0fUu19
         DC4DT8UI11wyA==
Date:   Thu, 25 Aug 2022 18:14:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: add RNLT lock assertion to
 devlink_compat_switch_id_get()
Message-ID: <20220825181446.6d84048b@kernel.org>
In-Reply-To: <20220825112923.1359194-1-jiri@resnulli.us>
References: <20220825112923.1359194-1-jiri@resnulli.us>
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

On Thu, 25 Aug 2022 13:29:23 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Similar to devlink_compat_phys_port_name_get(), make sure that
> devlink_compat_switch_id_get() is called with RTNL lock held. Comment
> already says so, so put this in code as well.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
