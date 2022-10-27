Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD34760F71A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbiJ0MX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiJ0MX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:23:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74826134ABD;
        Thu, 27 Oct 2022 05:23:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CA6A622B8;
        Thu, 27 Oct 2022 12:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8B0C433C1;
        Thu, 27 Oct 2022 12:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666873404;
        bh=b54F1RzA3jISI41sdoOkZ9b/ulgf8O2mcJRK3XR/VHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNBqV2izcLkLVehQ76m02Qi3PtD+AJci5atzAvMG79eEE3jQW6PZ8ExEHhJPBrrX1
         U/U3tEXKjP5HTrGjhjxYZK6jgDjTAt+wirLO4jUAE9mt6NFaUK20+Pj0CpcBSDoN1P
         kTld67UuNFuzqiFy80P86oiiIjXSJhHYQvwnQoMrJarPgxtZQ7ApuxG4Muq2s/K/rG
         kn83ZKTB6yfjk7jA/rvaVTobZ65n5y/JGKTs0pxDvaU3CdOVC04raAc2ZGPyXYp9aP
         j+C90ZvvWZKNdcHe8zNhai3Zsq50e3kCgF/dnFNOhOQ0vcoR1pES2tFHhmFzqTWKZd
         dK3PSU3DSoy0Q==
Date:   Thu, 27 Oct 2022 15:23:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Rohit Nair <rohit.sajan.kumar@oracle.com>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, manjunath.b.patil@oracle.com,
        rama.nichanamatlu@oracle.com,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: Re: [External] : Re: [PATCH 1/1] IB/mlx5: Add a signature check to
 received EQEs and CQEs
Message-ID: <Y1p4OEIWNObQCDoG@unreal>
References: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
 <Y0UYml07lb1I38MQ@unreal>
 <5bab650a-3c0b-cfd2-d6a7-2e39c8474514@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bab650a-3c0b-cfd2-d6a7-2e39c8474514@oracle.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 10:44:12AM -0700, Rohit Nair wrote:
> Hey Leon,
> 
> Please find my replies to your comments here below:

<...>

> > 
> > > This patch does not introduce any significant performance degradations
> > > and has been tested using qperf.
> > What does it mean? You made changes in kernel verbs flow, they are not
> > executed through qperf.
> We also conducted several extensive performance tests using our test-suite
> which utilizes rds-stress and also saw no significant performance
> degrdations in those results.

What does it mean "also"? Your change is applicable ONLY for kernel path.

Anyway, I'm not keen adding rare debug code to performance critical path.

Thanks
