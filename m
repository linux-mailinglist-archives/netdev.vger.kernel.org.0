Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFA267F515
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 06:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjA1F6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 00:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjA1F6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 00:58:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091EC7BBE0
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 21:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F87860D39
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 05:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0833CC433D2;
        Sat, 28 Jan 2023 05:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674885498;
        bh=g9+0qzpYESMwix83LvVtHvRcMcH9OC6ZwsnewF0ZNTI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lnaAeQqG6EY2/fpX4MAVcE+OzeRYvhpkc/9Avw9kfa4kX6uOVgHkf9q8cyiAYojD9
         HHLoy1KOibskDoFoqeqCeCNd6VN2ozsH8M3KbKKvGNwvr7kcFYFApPz6onVizbkGxs
         G9W6eDJTM7zjJRdnNIQBu8FoObUv0gO63lg8s6+FU959T9wWLmVL0rf3uiWqkJUZhB
         4+JAjK2QVMaUaJZ4TXwa5PPvMtR7k/8sVEOaEAP6n8qxO/ntNxno5Qn5qGqW83qwDe
         oXpPijdbm3qKpOQit5XbEphPoN9DmCpGlXsosqA5LADjxFlfrwnMBmNXn7A1r3+w1v
         AHRRKPOlu3YwQ==
Date:   Fri, 27 Jan 2023 21:58:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, jacob.e.keller@intel.com,
        gal@nvidia.com, mailhol.vincent@wanadoo.fr
Subject: Re: [patch net-next 0/3] devlink: fix reload notifications and
 remove features
Message-ID: <20230127215815.1304c2a9@kernel.org>
In-Reply-To: <20230127155042.1846608-1-jiri@resnulli.us>
References: <20230127155042.1846608-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Jan 2023 16:50:39 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> First two patches adjust notifications during devlink reload.
> The last patch removes no longer needed devlink features.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
