Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6D16A6E14
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 15:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCAON6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 09:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjCAON4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 09:13:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7D62D179;
        Wed,  1 Mar 2023 06:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B8ABB81014;
        Wed,  1 Mar 2023 14:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E34C433D2;
        Wed,  1 Mar 2023 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677680028;
        bh=0te5hmV7EcVOlF+NZja1nw/vmA7EjMWYkMeiCNAwGbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SCq9blgPmGSLWpqCoMzJssPWe5TSO8QTTjlbu48IfsZPD/mJhObN33vYTgQeln7Mj
         yoTZJH5W8NNwgXagg30BTrK6Z9xyIBm75+9mDwEpNTZKzeaKfPZfpORD0LSp00hjdc
         yr7PeQQ+5AxTkVlV3ydW5vKjYcY1168z8PvzR0DWQymHZI+jIlh2RoM6S3Fkfo1fSi
         Dqjg+fs6FZu+g1lyKdnfihiScfej3pzINUMeowksGpQVbq0mujw6Ikt/hzLxAou1YW
         ADkNXb1VcWFrXPgvYP+ULIjtVMz0MPT3EAOphR9H24H9cExjnAu+/viQLTORCFeVpY
         3dU4GG/ATDXIw==
Date:   Wed, 1 Mar 2023 09:13:46 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        idosch@nvidia.com, jacob.e.keller@intel.com,
        michal.wilczynski@intel.com, vikas.gupta@broadcom.com,
        shayd@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.2 51/53] devlink: health: Fix nla_nest_end in
 error flow
Message-ID: <Y/9dmsqrc8VbajFQ@sashalap>
References: <20230226144446.824580-1-sashal@kernel.org>
 <20230226144446.824580-51-sashal@kernel.org>
 <20230227101300.33bbedd1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230227101300.33bbedd1@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:13:00AM -0800, Jakub Kicinski wrote:
>On Sun, 26 Feb 2023 09:44:43 -0500 Sasha Levin wrote:
>> From: Moshe Shemesh <moshe@nvidia.com>
>>
>> [ Upstream commit bfd4e6a5dbbc12f77620602e764ac940ccb159de ]
>>
>> devlink_nl_health_reporter_fill() error flow calls nla_nest_end(). Fix
>> it to call nla_nest_cancel() instead.
>>
>> Note the bug is harmless as genlmsg_cancel() cancel the entire message,
>> so no fixes tag added.
>
>Not really a fix as described, let's drop.

Gone, thanks!

-- 
Thanks,
Sasha
