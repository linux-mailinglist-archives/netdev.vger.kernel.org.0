Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78397646510
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLGX2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLGX2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:28:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B995089AF4;
        Wed,  7 Dec 2022 15:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D87BB82194;
        Wed,  7 Dec 2022 23:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92149C433D7;
        Wed,  7 Dec 2022 23:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670455696;
        bh=lTnduRhi6AJ1bKCZCzLAjjxfjNoQ64rLfod75d7qxMQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HhETiRr6Gk1uY6kkRdQOr+MhsEzUYpb3zlvsEfujqPVg8b4r6ldGU3cWKvh79M+fL
         3yxLLqJ1cRq3h6F6+qLpft0X00Cy+IsNPFW7P6awMDFIl9uoYwGAXnMoWHXh6DR9fJ
         U70HMb/8C+QyllHv3373FtxF2jrQ6t/XosMJ0BP5eYb4g9WQM4rkk9zc1gfotIy9PV
         2HcTe4/K2nn+kl9NpsNUyb6OmuNj8ts4NfgM/hKWjEtYVd8KGtzzrASxyzmPQS5fNO
         gsIwf60OnVZ6bC1oZINxb0DJfLl4LjP/YkVhA2xGqS7fmEXcYGlpwVSfrae1VYhMzH
         vMwAQPC6Dxspg==
Date:   Wed, 7 Dec 2022 15:28:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <edumazet@google.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tedheadster@gmail.com>
Subject: Re: [PATCH linux-next] net: record times of netdev_budget exhausted
Message-ID: <20221207152814.2aa324d8@kernel.org>
In-Reply-To: <202212071617323068233@zte.com.cn>
References: <CANn89iKqb64sLT2r+2YrpDyMfZ8T6z2Ygtby-ruVNNYvniaV0g@mail.gmail.com>
        <202212071617323068233@zte.com.cn>
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

On Wed, 7 Dec 2022 16:17:32 +0800 (CST) yang.yang29@zte.com.cn wrote:
> > We prefer not changing /proc file format as much as we can, they are
> > deprecated/legacy.  
> 
> Should we add some explain of the deprecation in code or doc?
> As it's deprecated, I think it's NAK for this patch.

Correct, it is a NAK.
