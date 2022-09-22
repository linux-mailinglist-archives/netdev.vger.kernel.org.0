Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6075E6BB0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiIVTYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIVTYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:24:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E124229CA8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34E34B83A2A
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 19:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EB6C433D7;
        Thu, 22 Sep 2022 19:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663874676;
        bh=PMk3ZRQ4KE1GshWil1PHu/Mwcpf3tOixr3I4U9q0ies=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S8BgrW7Z75wSRj2uIYpVqk8624bgbXX5M83BtUyR+nWLGQGq+5ORgB35QGLNCt7ly
         ilvBDVP1hHFjVBhGDaZycb/BGG5u2uEyWzwfVN8htwA1rvGt9N28WbaUNeddM1N4rR
         0rBLhhuE0jh5qMd1gfyiDx9366isr0jtDyntFsDdQcbJ5BDeXcTp2oF9vt8afhdbho
         Yq3/16kUAsXj4Y/SDtvngsedhHEC7WhR7impuWiUb8i5Z5wsgjUzRSWJyG6AB7ZR7i
         6EQw+G3xeUUHVA38BnQp9fJeU0uO1VT39Mcr2WID6vFQtL0tIwmPFK4aTllxTptVRe
         R2YvtPTw3FO+g==
Date:   Thu, 22 Sep 2022 12:24:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3]
 nfp: support VF multi-queues configuration)
Message-ID: <20220922122435.49bedc23@kernel.org>
In-Reply-To: <YyyyphcLn8UQse2F@unreal>
References: <20220920151419.76050-1-simon.horman@corigine.com>
        <20220921063448.5b0dd32b@kernel.org>
        <YyyHg/lvzXHKNPe9@unreal>
        <20220922091414.4086f747@kernel.org>
        <YyyyphcLn8UQse2F@unreal>
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

On Thu, 22 Sep 2022 22:08:22 +0300 Leon Romanovsky wrote:
> > > Please don't. It will cause to an opposite situation where UAPI
> > > discussions will be hidden from most people.  
> > 
> > Oh, it'd just be an additional list, the patches would still need 
> > to CC netdev.  
> 
> First, there is already such ML: https://lore.kernel.org/linux-api/
> Second, you disconnect discussion from actual patches and this can
> cause to repeating of same arguments while reviewing patches.

I phrased what I meant poorly. The list would be in addition to netdev.
All patches CCing the new list would also have to CC netdev. So if you
subscribe and read netdev that'd be enough, no extra effort needed.

So no disconnect from patches or repetition. linux-api is obviously 
not a subset of netdev, it's not a fit.
