Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A246165C5
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiKBPKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiKBPKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2752B6271;
        Wed,  2 Nov 2022 08:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29C8B619E3;
        Wed,  2 Nov 2022 15:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2392DC433D6;
        Wed,  2 Nov 2022 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667401807;
        bh=xPUSHu8Iyg0semF7srvZ5RISzVHzcQjVu3jXab4fuRw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g4WyD50wGFAMLnsEVEf7P2nNodUiGME9DMBU4IPTWgl5+hmxtKRE34bAH0rpyQBhx
         sw01DfsIqcpxOpD3htJ6dynoLVqx/BdKTy0lcReAUyJzprbEX37PO+2ItQ7lgaHTb+
         R4g6cMHZbXNQE1BhHAPfdJ8vknUb2GtVJA6Lz2rjMEfXGo0HEVqQSWeWMKFS3hdnCL
         LruA0KCCaozsUoiifkWjjNN2PbwCZqf6fmHWNy9cQyfIrYMpHTqEE4PIKXgeZ8hEKW
         OpkEkHVFDcw2WE/rPa1J6y1fF8uXrJLWlwRapHyBCyXq3mpto54Wvy4e9Dx1jrhpxW
         nIz+ByfQM2xrQ==
Date:   Wed, 2 Nov 2022 08:10:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 13/13] net: expose devlink port over
 rtnetlink
Message-ID: <20221102081006.70a81e89@kernel.org>
In-Reply-To: <Y2JS4bBhPB1qbDi9@nanopsycho>
References: <20221031124248.484405-1-jiri@resnulli.us>
        <20221031124248.484405-14-jiri@resnulli.us>
        <20221101091834.4dbdcbc1@kernel.org>
        <Y2JS4bBhPB1qbDi9@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 12:22:09 +0100 Jiri Pirko wrote:
>> Why produce the empty nest if port is not set?  
> 
> Empty nest indicates that kernel supports this but there is no devlink
> port associated. I see no other way to indicate this :/

Maybe it's time to plumb policies thru to classic netlink, instead of
creating weird attribute constructs?
