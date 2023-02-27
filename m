Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF326A4957
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjB0SNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjB0SNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:13:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22369C665;
        Mon, 27 Feb 2023 10:13:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B163D60EEE;
        Mon, 27 Feb 2023 18:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC90C4339C;
        Mon, 27 Feb 2023 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677521582;
        bh=vqTBPpKr6g0Yp3ju7MbBLPw/lEHXwbTbtU7CknJ0k9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RD9zllS/cicBuQuh9FGvaIzKkNgHvCZOzwOU/4X4m18XnrErbErWKPq7o3cxTM9bh
         LPfWWMtxBbEWBIeFTzFfqgpAsJH0uydatS+ClEQ3fGjFY46K0tRXa1L31jrkx0+tk3
         /j2H9eJCMBtjIPENy8jx3gNrBXjav0hnrQLzvx4OROXtTDO0rT/cM9++iUpRFkilSV
         XRRm8elYMLhp148Cjea7TBAKBLDY/nPHdIrlJboqaeb7oenbS/7EU2EkRXcPEtAGzN
         uPZRFY0OiOt5dk2DcvxOy5JqEZzCVx5O0Q17RZRx7LPKKGsnk0Rff00sXZxTH8wOSC
         tpgH2bOJQ9hFQ==
Date:   Mon, 27 Feb 2023 10:13:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        idosch@nvidia.com, jacob.e.keller@intel.com,
        michal.wilczynski@intel.com, vikas.gupta@broadcom.com,
        shayd@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.2 51/53] devlink: health: Fix nla_nest_end in
 error flow
Message-ID: <20230227101300.33bbedd1@kernel.org>
In-Reply-To: <20230226144446.824580-51-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
        <20230226144446.824580-51-sashal@kernel.org>
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

On Sun, 26 Feb 2023 09:44:43 -0500 Sasha Levin wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> [ Upstream commit bfd4e6a5dbbc12f77620602e764ac940ccb159de ]
> 
> devlink_nl_health_reporter_fill() error flow calls nla_nest_end(). Fix
> it to call nla_nest_cancel() instead.
> 
> Note the bug is harmless as genlmsg_cancel() cancel the entire message,
> so no fixes tag added.

Not really a fix as described, let's drop.
