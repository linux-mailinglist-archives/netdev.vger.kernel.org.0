Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF766150AA
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 18:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiKAR3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 13:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiKAR3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 13:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3F41C134;
        Tue,  1 Nov 2022 10:29:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A3B7616A9;
        Tue,  1 Nov 2022 17:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817ABC433D6;
        Tue,  1 Nov 2022 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667323756;
        bh=9HjTZKUyi5InttAzsyhb1k2dAIgNFWUCZ9EPY+QsLHM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cSLQ/idV6dnMMtDIpYtoEVFZSp8BFnrCJ+FIm4rjTI6cXSsdLFfFXys+cKtoNT1jB
         dWV46BSB0fCgbIYx79v9JOeZheUgKskhB+nvU5d40607p1BQv3jM8qkweFqKJfU1GA
         UVxlj62yrWqw+8XspAb/6SBCjAydL95U3jCa5S1FS9OJpW1zftggjjkri0WZUCDTmo
         Wvy3l5SnTWX/j8zzfi3dc2a2Mocu0vi3Qa2GSWvhac/HCq2uME+pCBYRraBSSiDGl7
         Ve12kYLm1SESBMjBHZmnV4Dsyqq+g8ki7cQILPE4Py+eALQY3QlFqb8DsRYMb2mv7Q
         m6DWkccqRBo1Q==
Date:   Tue, 1 Nov 2022 10:29:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 00/13] net: fix netdev to devlink_port
 linkage and expose to user
Message-ID: <20221101102915.3eccdb09@kernel.org>
In-Reply-To: <20221031124248.484405-1-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 13:42:35 +0100 Jiri Pirko wrote:
> Currently, the info about linkage from netdev to the related
> devlink_port instance is done using ndo_get_devlink_port().
> This is not sufficient, as it is up to the driver to implement it and
> some of them don't do that. Also it leads to a lot of unnecessary
> boilerplate code in all the drivers.

Sorry about the late nit picks, the other patches look good.
Nice cleanup!
