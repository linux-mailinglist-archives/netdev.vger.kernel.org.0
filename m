Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A765660736
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 20:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbjAFTfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 14:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbjAFTer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 14:34:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E904268C8C;
        Fri,  6 Jan 2023 11:34:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35C1BB81C39;
        Fri,  6 Jan 2023 19:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14F0C433EF;
        Fri,  6 Jan 2023 19:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673033682;
        bh=V8R6GREMQHFTWGmJjJVX3DCS6UY+0a4/L4eOTj/MoV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q7WIvUiWeo9hEFfLSjG57GWkRqPOHpwl/q7ler+xdqJ426+nf6AE12UPM2FgaTeox
         2SgRIqQsbrQN0GOSNcQ0+B/lfrW/ur8FAWphYkhqEouFFx+V8HwZ8V71uVKkgdWPSO
         1EHEytSQNCwYjFKaHYloRyyqC26Z9/V6bnx4tncnHgGjAkcnTQE6SggGKNsnRoOsUI
         Zcgq4V6idtfEZqgqX+Bb2pRiYrQeqqGCTjR1QTaFnikOiKZntPZvcajN5eAhme5fJw
         FFCHvi/+EqmxgNUG1aFNQdMNZ+Wt6iGsCwdbNZox03R1G7meveU9uWNvEZrVkTMqjZ
         XZ9TJjgOXSZ9Q==
Date:   Fri, 6 Jan 2023 11:34:41 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <Y7h30d8t/EvQTzFW@x130>
References: <20230105041756.677120-1-saeed@kernel.org>
 <Y7bLMiB9Pb8EUfn0@unreal>
 <20230105103746.13c791d8@kernel.org>
 <Y7cvLGQwaWKrFixC@unreal>
 <20230105122517.235208c3@kernel.org>
 <Y7fCouYoyEVCLUdP@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y7fCouYoyEVCLUdP@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06 Jan 08:41, Leon Romanovsky wrote:
>On Thu, Jan 05, 2023 at 12:25:17PM -0800, Jakub Kicinski wrote:
>> On Thu, 5 Jan 2023 22:12:28 +0200 Leon Romanovsky wrote:
>> > > > PR should be based on Linus's -rcX tag and shouldn't include only this patchset.
>> > >
>> > > FWIW I don't understand what you mean by this comment.
>> > > PR should be based on a common ancestor, the -rc tags
>> > > are just a convenient shorthand.
>> >
>> > Linus asked for more than once to use sensible ancestor which is -rc.
>>
>> I mean.. as I said using -rc tags makes sanity checking the PRs easier,
>> so definitely encouraged.
>>
>> I was asking more about the second part of your sentence, what do you
>> mean by "shouldn't include only this patchset" ?
>
>When I saw "be applied to net-mlx5 branch", I imagined some branch which
>is based on net-rc and not on mlx5-next as usual. It looks like Saeed's
>intention was to say mlx5-next, but he misspelled it.

I meant mlx5-next.

