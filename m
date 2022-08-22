Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8732859C9F8
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 22:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiHVU3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 16:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiHVU3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 16:29:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C394F6B8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:29:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D37FB818FA
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 20:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F15C433C1;
        Mon, 22 Aug 2022 20:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661200144;
        bh=BVP5E+8pFeMltr4pCC+xp9+E06p56tfop2VR8MMcPL8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E6/UUTZm4QkbQ/J4o6rJ+usqJVaSCxN+Ens92RfJBIp5rSvzjWivd2YoEwrW3EvV9
         8Z+xfN5lDcJMh0qewJFGkJS3/SfHcPmKocWddmpBiVBA9fBvq2oA6C/zgd2vAMw8FK
         Ch10dE7i7bBZKn6mccTWeOo8wFVzsmkIgPJJtOD9mX93etHHNq+12dh1mUlyruuh3g
         nMvvDkmVWR/Ob5uTIc3czmHI/PXPYRgedOr7AAlx5WDxcWvWBDuVGyfRSmUWat7umm
         ZdRTQ0A4puFBkTuw347eCUncpzr4EFfpsnjuaAjvWFY2DpqS21Hqd9mtE3JX/z0WN7
         /OpB/Z0R1ru7Q==
Date:   Mon, 22 Aug 2022 13:29:03 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Raed Salem <raeds@nvidia.com>, Lior Nahmanson <liorna@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH 1/3] net/macsec: Add MACsec skb_metadata_dst Tx Data path
 support
Message-ID: <20220822202903.ltpo6lg2illcqnfn@sx1>
References: <20220818132411.578-1-liorna@nvidia.com>
 <20220818132411.578-2-liorna@nvidia.com>
 <20220818210856.30353616@kernel.org>
 <DM4PR12MB5357C54831EB8F1C9C982D90C96E9@DM4PR12MB5357.namprd12.prod.outlook.com>
 <20220822111056.188db823@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220822111056.188db823@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Aug 11:10, Jakub Kicinski wrote:
>On Sun, 21 Aug 2022 11:12:00 +0000 Raed Salem wrote:
>> >On a quick (sorry we're behind on patches this week) look I don't see the
>> >driver integration - is it coming later? Or there's already somehow a driver in
>> >the tree using this infra? Normally the infra should be in the same patchset as
>> >the in-tree user.
>> Driver integration series will be submitted later on
>
>This is a requirement, perhaps it'd be good for you to connect with
>netdev folks @nvidia to talk thru your plan? Saeed, Gal, Tariq etc.

driver part is still WIP in terms of maintainer review, but we are very
close, we will submit everything at once in next version.

Thanks.

