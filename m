Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1985B8E79
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 20:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiINSAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 14:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiINSA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 14:00:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8B322BD1;
        Wed, 14 Sep 2022 11:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D3F9CE18FF;
        Wed, 14 Sep 2022 18:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AFBC433D6;
        Wed, 14 Sep 2022 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663178418;
        bh=Vj08lwJzZKBJb8ZmEBuk8O2x/avP5v5Djz7cdwCDK44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b/RG9Jbur4JDcUTQxVZ1hfOY0CE5shawGKUZLVlmRO/rPf6JahXngBiOExSn66ZKC
         T8TujIooU9tvUMo7lWOsZtna557g/zM7ZSKUzB/pyMV6GqRcZWzxGRD+SMk0+0ztXd
         ozPNeSWoqRYgkTj68YWECSUAOFoza4jOC5DzbE8gKtNpVTMb8TU63QQ3tOJvFNcCZt
         2fCDycZ59vvdu8kbUi1EJZ6xboyOwq4K5RwtqSbi5nXUnCz7ZiaOFW0T8P5vbgso1l
         AkfWICXr564nZNZhdGKL8hLqjDjVkRDVrYmItm9TwNF5X041g07k5B1DgtbRjGnjAN
         Z9aM5SYNUHV1g==
Date:   Wed, 14 Sep 2022 14:00:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 17/23] fec: Restart PPS after link state
 change
Message-ID: <YyIWsCBYKYyKR5SA@sashalap>
References: <20220830172141.581086-1-sashal@kernel.org>
 <20220830172141.581086-17-sashal@kernel.org>
 <0d6d1182-921e-1da2-b315-427f25228d12@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d6d1182-921e-1da2-b315-427f25228d12@prolan.hu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 03:03:40PM +0200, Csókás Bence wrote:
>
>On 2022. 08. 30. 19:21, Sasha Levin wrote:
>>From: Csókás Bence <csokas.bence@prolan.hu>
>>
>>[ Upstream commit f79959220fa5fbda939592bf91c7a9ea90419040 ]
>>
>>On link state change, the controller gets reset,
>>causing PPS to drop out and the PHC to lose its
>>time and calibration. So we restart it if needed,
>>restoring calibration and time registers.
>
>There is an ongoing investigation on netdev@ about a potential kernel 
>panic on kernels newer than 5.12 with this patch applied. Please hold 
>off on backporting to 5.15 until the bugfix is applied to upstream.

Will do, thanks!

-- 
Thanks,
Sasha
