Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BCC5EDE6F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiI1OHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiI1OHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:07:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931EC564C9;
        Wed, 28 Sep 2022 07:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123F461D22;
        Wed, 28 Sep 2022 14:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24842C433C1;
        Wed, 28 Sep 2022 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664374055;
        bh=u2tPNgJtSHupgVed5hRLkf1bBRL8Ie9mRQkYuMTG0Ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=exSTlDIdFOIgpXrz+0201sQl+VGVKRV1aFE3DFbvUnoJECFfwuU6uYSAgq8P6b9of
         UCvn7VD+kaljO/czl4d6BmWwh7VJkvobCCsb3BckbrT51yJwmTvlThRIX+W96mW/U9
         T7nELCcIKUT0+Sh73vKY1LBozEhFw2Vp1Ks3QMlpBbIlm1ogTdIVXfyw6KWs9DsGcK
         bShjKJ/Dx5EdvIJyLOzWAF+F3fMffmPmzLbtL8BHRp732RL1HYIuS6JJVJ6+Z+WIhq
         nTkr84kvUH8PbaR4G6Km+AZmAgJDmboz/zZBC+qFAk+x5x0qiieE0WP//qJ4KOd16f
         hnKNTk1xtHhRA==
Date:   Wed, 28 Sep 2022 07:07:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ruan Jinjie <ruanjinjie@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <linmq006@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net: i82596: Add __init/__exit annotations to
 module init/exit funcs
Message-ID: <20220928070734.7a519e18@kernel.org>
In-Reply-To: <987b807d-9f10-414a-524c-40e3d9f69e72@huawei.com>
References: <20220926115456.1331889-1-ruanjinjie@huawei.com>
        <20220927075257.11594332@kernel.org>
        <987b807d-9f10-414a-524c-40e3d9f69e72@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 11:13:24 +0800 Ruan Jinjie wrote:
> On 2022/9/27 22:52, Jakub Kicinski wrote:
> > On Mon, 26 Sep 2022 19:54:56 +0800 ruanjinjie wrote:  
> >> Add missing __init/__exit annotations to module init/exit funcs  
> > 
> > How many of these do you have? Do you use a tool to find the cases 
> > where the annotations can be used?
> >   
> I think Linux kernel drivers have many of these problems.I use grep
> command to compare all the driver C files and find where the annotations
> can be used.
> 
> > Please read Documentation/process/researcher-guidelines.rst
> > and make sure you comply with what is expected in the commit message.  
> 
> Thank you very much! Some key information is missing from the commit
> message. Should I update the commit message and resubmit the patch?

TBH I don't think this is worth fixing. The functions which will be
discarded are tiny.
