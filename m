Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8876BC033
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjCOWyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjCOWyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF595C12B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:53:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB7C661EA7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378BDC433EF;
        Wed, 15 Mar 2023 22:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678920820;
        bh=8pvEQOQmr09Fm2Yuk5JrcAu4+dJxaTxS3cLvOUHbF7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gl3FfNMlwVgzIXmuLm3Un47SQU5Xr87g8ng1LLlfG94j2+bDbi+HY2nlYvokfNQWX
         glzQTGgVvejCm1YuwA/FHTBRGJxLKf0wVYqMgC2gAml1+NH2xV24sxWu0P3j1IWewQ
         w6aw78DlMqkdOCoCTMTyBVs5C6bAj+Top9xkGJnkfmusXByBfhfIHJISJVuXDUEGDB
         R27VBiyztPKjQoxyB7hBOTscXn7T8hF5/HDqcG/TlXCQbI+wrf/lOPonQLGzQGCJ6v
         zoLjmkQv0DoSFdsBadYJ8e8uaCF6KGSmuA0iWaicnl9ugio5wcowy5/DXz0GIioV7h
         rYgd2BiPtT+FA==
Date:   Wed, 15 Mar 2023 15:53:39 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Piotr Raczynski <piotr.raczynski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: Fix setting ec_function bit in MANAGE_PAGES
Message-ID: <ZBJMcw2i+6ijmmmA@x130>
References: <20230314174940.62221-1-saeed@kernel.org>
 <20230314174940.62221-4-saeed@kernel.org>
 <ZBHD2J8I1WGf9gnB@nimitz>
 <ZBIv4oGgtWbTGkaS@x130>
 <20230315140454.4329d99e@kernel.org>
 <ZBIz7yxaeDOiV4xk@x130>
 <20230315143334.434bbbda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230315143334.434bbbda@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Mar 14:33, Jakub Kicinski wrote:
>On Wed, 15 Mar 2023 14:09:03 -0700 Saeed Mahameed wrote:
>> When looking from a larger scope of multiple drivers and stack, yes it
>> makes total sense.
>>
>> Ack, will enforce adding mlx5 prefix to static functions as well..
>>
>> Let me know if you want me to fix this series for the time being,
>> I see another comment from leon on a blank line in one of the commit
>> messages.
>>
>> I can handle both and post v2 at the same time.
>
>It's a long standing problem, we can keep it as is, if you don't have
>any other code changes to the series. Just change the recommended style
>going forward.

I see that patchwork is complaining about the blank lines, I will fix 
both the mlx5 prefix and the blank lines, Will post V2.

Thanks.
