Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D2767F9B3
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjA1Qzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjA1Qza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:55:30 -0500
X-Greylist: delayed 597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 28 Jan 2023 08:55:29 PST
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4550E24499
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:55:29 -0800 (PST)
Received: from madeliefje.horms.nl (86-88-72-229.fixed.kpn.net [86.88.72.229])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id B50F12013D;
        Sat, 28 Jan 2023 16:45:00 +0000 (UTC)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 6F9314924; Sat, 28 Jan 2023 17:45:00 +0100 (CET)
Date:   Sat, 28 Jan 2023 17:45:00 +0100
From:   Simon Horman <horms@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v5 1/6] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y9VRDCtpKGLjM4C6@vergenet.net>
References: <20230125153218.7230-1-paulb@nvidia.com>
 <20230125153218.7230-2-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125153218.7230-2-paulb@nvidia.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.7 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 05:32:13PM +0200, Paul Blakey wrote:
> For drivers to support partial offload of a filter's action list,
> add support for action miss to specify an action instance to
> continue from in sw.
> 
> CT action in particular can't be fully offloaded, as new connections
> need to be handled in software. This imposes other limitations on
> the actions that can be offloaded together with the CT action, such
> as packet modifications.
> 
> Assign each action on a filter's action list a unique miss_cookie
> which drivers can then use to fill action_miss part of the tc skb
> extension. On getting back this miss_cookie, find the action
> instance with relevant cookie and continue classifying from there.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

