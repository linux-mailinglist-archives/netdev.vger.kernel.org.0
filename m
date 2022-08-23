Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DAF59ED30
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiHWULl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiHWULV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:11:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB7A287F
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 12:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2019C61630
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 19:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAA2C433B5;
        Tue, 23 Aug 2022 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661283082;
        bh=+C6aXYkRrxhS6khtrhenTXCv4zjKT7ns5UkYviNaLvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UkybhA79qZIIUnTeu0TxmhXlvgugVukcy7HFRr8YjT5sVaAXmXMxuibMXeaEFxzqp
         ya3hyEIT90NcQKkdl8mxol7cEWYwISC0WqBofBYHLAkNX1YN4ZFzdV7zYQ08xLdmYs
         60kVONgJ+m/mKhxgPIhhNpfs+zoNO4OqMVno7ahYZeTODj7vZs3qOrWWeF5thtL6d+
         t7eLYISDDyLsHTO62ykAdRyL3cU/iyfsvM4Dfv6wpzIz3sQ7xEc9lfhlr8juXrcAyP
         tDCV0MUVXbWRYAl7XwWjhfkDNh69sVso/At8zSVW0W34FpsGVAqzCCwLVmKx6hKKAQ
         u/2C4glN4b3dg==
Date:   Tue, 23 Aug 2022 12:31:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Message-ID: <20220823123121.0ae00393@kernel.org>
In-Reply-To: <YwR1URDk56l5VLDZ@nanopsycho>
References: <20220822170247.974743-1-jiri@resnulli.us>
        <20220822170247.974743-5-jiri@resnulli.us>
        <20220822200116.76f1d11b@kernel.org>
        <YwR1URDk56l5VLDZ@nanopsycho>
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

On Tue, 23 Aug 2022 08:36:01 +0200 Jiri Pirko wrote:
> Tue, Aug 23, 2022 at 05:01:16AM CEST, kuba@kernel.org wrote:
> >I don't think we should add API without a clear use, let's drop this 
> >as well.  
> 
> What do you mean? This just simply lists components that are possible to
> use with devlink dev flash. What is not clear? I don't follow.

Dumping random internal bits of the kernel is not how we create uAPIs.

Again, what is the scenario in which user space needs to know 
the flashable component today ?
