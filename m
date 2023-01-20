Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9857674883
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 02:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjATBE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 20:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjATBE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 20:04:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF261A45F2;
        Thu, 19 Jan 2023 17:04:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6620761DC3;
        Fri, 20 Jan 2023 01:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D926C433D2;
        Fri, 20 Jan 2023 01:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674176660;
        bh=7TayGs+eB97qDyojInbu3jqAmCJtKRZQFjJi9OoQkXY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q9MQoxzYKd8n4AZKpxvhDmPo5v4wsdg/FOxR/c78IJ2siiQq1Grv7FAbC6cVKHPI6
         srZV6D1WqiZo8EdjcatwJ5fopX23uahg+C6BzU1V+MwrTHw+SUijOMhebsHfWVSlwI
         zxT4M8K2LfJx8r3+Kjtf88GJ+rkO88cDE6qwSOPsBsrb3AzgnHnpvYA/9tZBjwAsE/
         KSNSpJ+LMM+2GGV51bjYbly5EzhldnxaIwT6wXhTX0+26D97AAVNC0vw6ytW1IyO6m
         w4fiajSFfLTHy2oi78ob1SZQEQUvf88w09rFcLPEob4Yx8p/MdUiGT7wRcf+80KFE9
         c7XLc2pBOsuQA==
Date:   Thu, 19 Jan 2023 17:04:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <robh@kernel.org>,
        <stephen@networkplumber.org>, <ecree.xilinx@gmail.com>,
        <sdf@google.com>, <f.fainelli@gmail.com>, <fw@strlen.de>,
        <linux-doc@vger.kernel.org>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH net-next v3 7/8] net: fou: use policy and operation
 tables generated from the spec
Message-ID: <20230119170419.091f7a02@kernel.org>
In-Reply-To: <7a732996-e566-14e2-6ce1-1ccde16f5975@intel.com>
References: <20230119003613.111778-1-kuba@kernel.org>
        <20230119003613.111778-8-kuba@kernel.org>
        <a340a5e2da55f352322c2aa902b592ece9bfbb5a.camel@sipsolutions.net>
        <7a732996-e566-14e2-6ce1-1ccde16f5975@intel.com>
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

On Thu, 19 Jan 2023 16:18:04 -0800 Jacob Keller wrote:
> On 1/19/2023 12:56 PM, Johannes Berg wrote:
> > On Wed, 2023-01-18 at 16:36 -0800, Jakub Kicinski wrote:  
> >> +fou-y := fou_core.o fou-nl.o  
> > 
> > I feel like you could've been consistent there and used "fou-core.o"
> > with a dash, but hey :-)
> 
> And here I lean towards using _ instead of - in file names but
> consistency is good, all else being equal.

Done. IIRC the codegen used to assume the naming (it needs to know 
the name of the header to include). I fixed that but forgot to rename
fou :S
