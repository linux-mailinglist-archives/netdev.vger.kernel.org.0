Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93E368FF8C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 05:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBIEwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 23:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjBIEwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 23:52:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35989EB51;
        Wed,  8 Feb 2023 20:52:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF1A1618A6;
        Thu,  9 Feb 2023 04:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05981C433EF;
        Thu,  9 Feb 2023 04:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675918319;
        bh=IZSF2T8MHcH6eT5q1V0597aOE/zm1eE8ir+LFWgpNWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ck2l5bhqnhtey7rZ6cn+oIrjL7h/k6F0/wvhZN3sqe8TtZlUBwc8R+pKcApXY1fNP
         aKd/zSAzb5XxTqqK6eFT4yKDIPzLIhpGkuCrCg9i83aoH8KBhio/WdzF1JFTT4VVnP
         pSMUICzlKvV+d2dve/+2i4iotariesmMJaL6zPnUJkDNJRoDZyhCev0lyFQoNhtULx
         3mdeHB0SsZHFlXczSFsGlb8EcxtCC9Y+YQyQRvP/e/NbBzqj/DArRfVHtYBAwxN5zE
         lBxOYiXc3+BqTrTQYM8crAPLd2A5TudX3gxzjqm/rifFEtUZ7zShY/mbbMe0PAltR2
         bLpa8to4JNkKw==
Date:   Wed, 8 Feb 2023 20:51:57 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next netdev notifier deadlock 2023-02-07
Message-ID: <Y+R77fsgVjof6cIZ@x130>
References: <20230208005626.72930-1-saeed@kernel.org>
 <20230208191250.45b23b6f@kernel.org>
 <20230208191605.719b19db@kernel.org>
 <Y+RseKpYCBnXzImH@x130>
 <20230208202714.5b3ecc3e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230208202714.5b3ecc3e@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Feb 20:27, Jakub Kicinski wrote:
>On Wed, 8 Feb 2023 19:46:00 -0800 Saeed Mahameed wrote:
>> On 08 Feb 19:16, Jakub Kicinski wrote:
>> >Ooh, maybe I'm not supposed to pull?
>> >Jiri's changes have Change-Ids on them:
>>
>> Fixed now, same tag, if you wanna go ahead and pull.
>> Please let me know if you prefer V2..
>
>One more, on:
>
> 94b3ec5464f6323e1cd6be72b84c2d98c942ea13
>
>FETCH_HEAD  8946287ba8513c1c

Now should be fixed, sorry I was trying to preserve the sha of
"net/mlx5: Introduce CQE error syndrome" and I was off by one.
Thanks for the tolerance.. 

