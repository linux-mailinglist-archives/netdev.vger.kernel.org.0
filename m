Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF16C59AA2C
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 02:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiHTAem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 20:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245275AbiHTAek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 20:34:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B22BC14;
        Fri, 19 Aug 2022 17:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1A3DB829A0;
        Sat, 20 Aug 2022 00:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C8FC433D7;
        Sat, 20 Aug 2022 00:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660955675;
        bh=EDb/TDUNl2c98Al1euf0fcsVVMwYWDBPVHtktMfZh6I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C8aP0vETUkZLXwye39N8PdHfiBcyqNtpruSfhvGDI8wnKpyLBntFfgz0nLWAQ29gQ
         KIcwSC5xZE1xG7VTQBcdNL1jV10Nt4/znPp9wpcWWfumygXOIwWAYCd1YKW3/ncF+l
         G/88A/5P9FhbiwhOTZ6RwuQaibkIDmTZ9CSG1BcAINoI4cgsHa0k/wrM3B5lWR+RfM
         Qt/pcAMFJkjndWbv7QjorbAa3bzEcHphWrP7gDXGrgqcQJnrKA1cqQHrxfIYsU4VX0
         4jt9O5V6xmH5xQUcfBTa08nJwtVjztKBxIq61WzaBQ5R1cHAMMfTSJd4RQhw8m6aZs
         vus6rbIRmwgQw==
Date:   Fri, 19 Aug 2022 17:34:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tejun Heo <tj@kernel.org>, Xin Gao <gaoxin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core: Variable type completion
Message-ID: <20220819173430.20f8653b@kernel.org>
In-Reply-To: <YwAlvv+xf//wlTSg@slm.duckdns.org>
References: <20220817013529.10535-1-gaoxin@cdjrlc.com>
        <20220819164731.22c8a3d2@kernel.org>
        <YwAlvv+xf//wlTSg@slm.duckdns.org>
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

On Fri, 19 Aug 2022 14:07:26 -1000 Tejun Heo wrote:
> On Fri, Aug 19, 2022 at 04:47:31PM -0700, Jakub Kicinski wrote:
> > On Wed, 17 Aug 2022 09:35:29 +0800 Xin Gao wrote:  
> > > 'unsigned int' is better than 'unsigned'.  
> > 
> > Please resend with the following subject:
> > 
> > [PATCH net-next] net: cgroup: complete unsigned type name  
> 
> Out of curiosity, why is 'unsigned int' better than 'unsigned'?

Good question, a citation in the commit message would also be good.
