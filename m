Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B38621F62
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKHWfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKHWfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:35:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C748F51C3C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:35:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CD49617C9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 22:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F720C433D6;
        Tue,  8 Nov 2022 22:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667946900;
        bh=Qe/2zLPIjt/yeLp6KRKZdh5NXrNlW60NYlTxQA+lXlM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TpFkgmaRsTUPYMPi11i4rMaRNTI38zMk7sVI2H5dmqsqA+ha2lE/RSA75HrC7bhe6
         Kpw2Pj96por78/jgXMttv61E6XTVS+zfnSTwJrzfcYghU6Ac2Pk58Kx3EaM6Gy1Xls
         am+RYOaZ+5qKN4vVD1FHSLJp22CzhU4lbdJEHOOk3ULo3dWoh4VZKUSWyy16O3roBz
         iWRFDMkmmz6h0nsBbI/b1dJxGrkChOytD4NchZdDkJy6hzHwO3ZYjrk9eVuBYrJHZs
         rNVEWJhi7llWU8nmkGxHngJiJOALWoShLs/L1lqoOktGWZL9IPQYX/I+1YDW8+VghO
         wmUoXgfi5NHrQ==
Date:   Tue, 8 Nov 2022 14:34:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next v9 0/9] Implement devlink-rate API and extend
 it
Message-ID: <20221108143459.0131d662@kernel.org>
In-Reply-To: <8d4faf31-ea3a-97ba-9a0b-394705dba617@intel.com>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
        <20221104190533.266e2926@kernel.org>
        <561f25bc-40dc-78c7-0a2c-e7e0fe74ebde@intel.com>
        <20221107103145.585558e2@kernel.org>
        <f0075083-8a11-a2f4-a927-7cd5f255bde4@intel.com>
        <8d4faf31-ea3a-97ba-9a0b-394705dba617@intel.com>
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

On Tue, 8 Nov 2022 09:36:01 +0100 Wilczynski, Michal wrote:
> > On 11/7/2022 7:31 PM, Jakub Kicinski wrote:  
> >> You can't reply to email and then immediately post a new version :/
> >> How am I supposed to have a conversation with you? Extremely annoying.  
> >
> > I'm sorry if you find this annoying, however I can't see any harm here ?
> > I fixed some legit issues that you've pointed in v9, wrote some
> > documentation and basically said, "I wrote some documentation in
> > the next patchset, is it enough ?". I think it's better to get feedback
> > for smaller commits faster, this way I send the updated patchset
> > quickly.

Perhaps spending some time reading the list would help you understand
what normal development upstream looks like. Posting the N + 1 version
of a patch set and then replying to comments on version N is confusing
because it's impossible to decide where the conversation is taking
place. Should I reply to you on version N or reply to N + 1 even tho
there I can't quote your reply. And will the maintainer who's applying
the patches understand that N + 1 got rejected if the discussion is
happening under the thread of version N?

Perhaps one has to read the list to appreciate the challenges involved.

> >> I'm tossing v10 from patchwork, and v11 better come with the docs :/  
> >
> > I will however create a new devlink-rate.rst file if you insist.
> 
> There is however a mention about rate-object management in
> devlink-port.rst. Would it be okay to extend devlink-por.rstt with new
> attributes tx_priority, tx_weight instead of creating a new
> devlink-rate.rst ?

Sounds good, but please make sure you describe the interaction between
the params and the algorithm. We don't have a SW implementation like we
have for qdiscs here, and we don't want each vendor to be coming up
with their own interpretation of the arguments. So we need solid docs,
and some pseudo code to describe the behavior, perhaps?

Let me ask some extra questions on the doc.
