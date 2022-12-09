Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7841E648B71
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLIXqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLIXqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:46:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F2D2EF53
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 15:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C661762393
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 23:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D023C433EF;
        Fri,  9 Dec 2022 23:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670629594;
        bh=1LBaK9gvIdkjnjqnGMBi0AFtijqhuS+MKRA2IZdl3+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bT+zewt/VDEtJn59+tNUCT+5O9O5NIayDTFGsE34bIO6Xslglgxf9JsP94OLkQkTG
         EhJM4ozcsW4/U2I9EfFQUbPHm6bECwOJKb5LYyX0JPnrXJd7BgSZrc2B8qKywZ6+ks
         NPSr0LnX6t4pHKPhnECad/D5Kf1e2TL5kUZ2bmscqY2AV9LJK8dJriTZIRbh3p/s70
         VWEL0LN6km0d+0ggCa0Ic5YBeuLgmdESr8qV4etoeHkt3ElqSZmY1kHH4CAWLfWzeJ
         tNobjYazuDcxAUotXBoWBsDcJOwJM75FGZ1+mk6Dtur19a1JinDfBxYdh1o1oFG2qD
         DgfzqfHp7RaYg==
Date:   Fri, 9 Dec 2022 15:46:32 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>
Subject: Re: [PATCH net 1/3] bonding: access curr_active_slave with
 rtnl_dereference
Message-ID: <Y5PI2AGqKZALOLUr@x130>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
 <20221209101305.713073-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221209101305.713073-2-liuhangbin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Dec 18:13, Hangbin Liu wrote:
>Looks commit 4740d6382790 ("bonding: add proper __rcu annotation for
>curr_active_slave") missed rtnl_dereference for curr_active_slave
>in bond_miimon_commit().
>
>Fixes: 4740d6382790 ("bonding: add proper __rcu annotation for curr_active_slave")
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Saeed Mahameed <saeed@kernel.org>


