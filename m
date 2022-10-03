Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCAB5F344B
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJCROI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJCRNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EE132DAF;
        Mon,  3 Oct 2022 10:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB13761186;
        Mon,  3 Oct 2022 17:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2E6C433D6;
        Mon,  3 Oct 2022 17:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664817206;
        bh=ix/u/5RYQfRbQ6xWKnsreS80VFdbDF76pRBFUOS16p4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZWzhMCYwI/FyqUMEQ/Lk/KLPyqJsDhRxgk/JCRSomd6gdnMhFvd4CzpyehtWdBuUi
         ZMzDrrmCDC/0DepaABSDL/2HPvSEcgFFvr+Wu/FuITdIDfXQ3iMspmWH/cqwPfhK2/
         F34DfCIkWYPKJqnnjrXQ3o5E2AmID9lidebmKmtkK9Y7wEjZr8Il+pQeLrKvqVGgQI
         Z0qxfcgOLlj1TI7o1/b1ZnKTVMsOkdDVtuXyvbaczZ/sSooTO3yr+1imdzbDVaKZ78
         tr8fpNcieEnYagkjrM0YdrnqZQ1+W4EBBaKLWYCnuE2ylFWjkz8Ok0zn5u73FHaA8/
         /4MkwUb4mvVJw==
Date:   Mon, 3 Oct 2022 10:13:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Sajan Kumar <rohit.sajan.kumar@oracle.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "leon@kernel.org" <leon@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Srinivas Eeda <srinivas.eeda@oracle.com>
Subject: Re: [External] : Re: [PATCH] IB/mlx5: Add a signature check to
 received EQEs and CQEs
Message-ID: <20221003101324.3e432360@kernel.org>
In-Reply-To: <BYAPR10MB2997F4E3E1588E2D003E65FFDC5B9@BYAPR10MB2997.namprd10.prod.outlook.com>
References: <1663974295-2910-1-git-send-email-rohit.sajan.kumar@oracle.com>
        <BYAPR10MB29977D4DCA235EE5F91EFF29DC579@BYAPR10MB2997.namprd10.prod.outlook.com>
        <YzYfwXtLceoEw0qo@ziepe.ca>
        <BYAPR10MB29977337E0C3791BCBC6381BDC5B9@BYAPR10MB2997.namprd10.prod.outlook.com>
        <YzsOPllsIMCOC0ks@ziepe.ca>
        <BYAPR10MB2997F4E3E1588E2D003E65FFDC5B9@BYAPR10MB2997.namprd10.prod.outlook.com>
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

On Mon, 3 Oct 2022 16:34:31 +0000 Rohit Sajan Kumar wrote:
> Hey Jason,
> 
> I just resent it. Does it show up on that list instantly or is there a time delay involved ?

Please be aware that:
 a) the lists don't accept HTML emails (which you're sending
    in this thread)
 b) you should not top post on the list
