Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568FD6686E1
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbjALWYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240826AbjALWXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:23:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C321A2DFA
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BF3C62138
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B7AC433EF;
        Thu, 12 Jan 2023 22:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673562050;
        bh=VFxcv1cRi4Xwqbkgyb+RA9oGbhT9AXq1oMFJrNHjY1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cyYC6UXLWPT1esxxi11e7Q8xhgk2ZNf6HS9sdydKUi3waphoOf35GFFzJGDUTIr7o
         l9GHO/HrajYuJ03UqJIhz+FfiHV4A1eQEeQ846Ve/cOteLi/pwynhv8Oh+eCzTi2nE
         1MBS0mqu0+uvYV/cSSkdyl/9oZSWyRdj4CMyFCmmHmxH8RGGZ499dsfkjrIe9O33md
         GQd3cZ/XKxC7WIhQhY/Oe8fNWlRYrlRtJvbOsB/pGuxOSsda7pa23LbyIPrw43AfGq
         AMkbUNN4Frd0qmB3g/FkGAPHegsQpugFFAR0wvcpeSaK8gsXsIcp7umDLwo4YQQ3zd
         rBiVPprq/LiYg==
Date:   Thu, 12 Jan 2023 14:20:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Message-ID: <20230112142049.211d897b@kernel.org>
In-Reply-To: <f10e0fa9-4168-87e5-ddf7-e05318da6780@nvidia.com>
References: <20230111053045.413133-1-saeed@kernel.org>
        <20230111053045.413133-9-saeed@kernel.org>
        <20230111103422.102265b3@kernel.org>
        <Y78gEBXP9BuMq09O@x130>
        <20230111130342.6cef77d7@kernel.org>
        <Y78/y0cBQ9rmk8ge@x130>
        <20230111194608.7f15b9a1@kernel.org>
        <f10e0fa9-4168-87e5-ddf7-e05318da6780@nvidia.com>
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

On Thu, 12 Jan 2023 11:17:07 +0200 Gal Pressman wrote:
> As Saeed said, we discussed different APIs for this, debugfs seemed like
> the best fit as we don't want users to change the queues parameters for
> production purposes. Debugfs makes it clear that these params aren't for
> your ordinary use, and allows us to be more flexible over time if needed
> (we don't necessarily have to keep these files there forever, if our
> hardware implementation changes for example).

You cut off the original question in your reply, it was:

  Can you expand on the use of this params when debugging?

IOW why do you need to change this configuration during debug.
