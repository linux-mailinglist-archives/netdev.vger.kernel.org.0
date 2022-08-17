Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F43A597386
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbiHQQCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240236AbiHQQCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:02:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80589E2C7
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 09:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92BBCB81C83
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 16:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102DAC433C1;
        Wed, 17 Aug 2022 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660752158;
        bh=xIu4KJrIt3W5zVPoWge6QPM6qcBRgNNwTeeqvxsI5wc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fhhfgWxyZv/fkaxp3pFLrceBGHGYafd95jdzaMETMWlNpK6JOtIKG9IHvbmG19Wpu
         02uzmMRSPakHsVjiRlBACaDdiVzhzHIjSb6WE6tEqpEB/6Ba3igmKTqGiwDZ5VhZW/
         u1/fkQIYe5Owd4y8D1FGoAYV9Jv9lP+M8wMt6t/nB6UBSaoTfFrliV6/TiCWIN1wIX
         pEw/0O3VYCQT9Zq3HaGMxN61ME/uKJaVit0vA7Fh8F2QE7u/ZLhtKjSTLYCRmK14y7
         jNja5mo3T4XjOmcTFkYE8rSrq97ukO4aqDS7ll+4nwELLj2vFQDZmgYmMHc/e8+Vob
         lh2uReUwuP7Lw==
Date:   Wed, 17 Aug 2022 09:02:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: Re: [ RFC net-next 0/3] net: flow_offload: add support for per
 action hw stats
Message-ID: <20220817090237.79e42eb3@kernel.org>
In-Reply-To: <a2b5d395-01c7-4ca4-a844-2ba6952ac66b@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
        <20220816111941.04242d4f@kernel.org>
        <a2b5d395-01c7-4ca4-a844-2ba6952ac66b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 17:46:54 +0300 Oz Shlomo wrote:
> On 8/16/2022 9:19 PM, Jakub Kicinski wrote:
> > On Tue, 16 Aug 2022 12:23:35 +0300 Oz Shlomo wrote:  
> >> This series provides the platform to query per action stats for in_hw flows.  
> > 
> > I'd like to make sure we document the driver-facing APIs going forward,
> > please consider adding a doc.  
> 
> Is there an existing document that we can update?

Not that I know of.
