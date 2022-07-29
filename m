Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471A1584B05
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiG2FS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiG2FS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:18:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791214BD16
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:18:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1531B61E83
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD51AC433C1;
        Fri, 29 Jul 2022 05:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659071934;
        bh=ayAt9An1eOjsw4JRTNE+V4qWaO1+fRD0n+kyoEJYna0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GOTV+MCITTUnuvJZcsZWYo/5t89KDqqXzbSWdzAeW5QUoOYspkxoLalqOyqbSIxi5
         Ag8D7jWpx1eJRXzVCFPml55fOuAZmnZ0oiKj/yswicC3mpTHrOOl8F8YghL3AJQ8ni
         3m6/YQJfFi8Zk4WncqHmyOUTSgY/V3P2phDNGmL/V+MdPRlv4zTd/Gyl+mR5bJI81v
         sKRwqqNAX6/0uTYGFolJXuJdYUach9VU2LRMwYsydrr97tNRIHUmsfwYp8gBmsetwI
         OJPoeUVyj57dH/Z7reuEde6uMdmx9pEdMPhx4ThNR/uXDYpxQL/4RE6HcK87PXFXAg
         aT6U/DokupmBw==
Date:   Thu, 28 Jul 2022 22:18:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [net-next 06/15] net/mlx5e: TC, Support tc action api for
 police
Message-ID: <20220728221852.432ff5a7@kernel.org>
In-Reply-To: <20220728205728.143074-7-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
        <20220728205728.143074-7-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 13:57:19 -0700 Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Add support for tc action api for police.
> Offloading standalone police action without
> a tc rule and reporting stats.

Do you already support shared actions? I don't see anything later 
in the series that'd allow the binding of rules.

The metering in this series is for specific flower flows or the entire
port?


Simon, Baowen, would you be willing to look thru these patches to make
sure the action sharing works as expected?
