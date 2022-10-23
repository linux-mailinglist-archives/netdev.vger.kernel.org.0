Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436AA6091C1
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 10:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJWIIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 04:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJWIIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 04:08:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B45477565
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 01:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECBBA60BA4
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 08:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8892BC433C1;
        Sun, 23 Oct 2022 08:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666512532;
        bh=1OJRzdeiAA7BqrUNnrwesbxrAnBanUqPgrn61whVbmg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CnoNR9ZujnPHa4sv9xEZvTVt572IywdTgArYOF8yCYpfUkuLNLJyX/Q2ScpabmdC5
         BkvYECrouZlAU4bjFk6Z0h7dX6KiS+5qlr5p0qYkBj7MylHfvDse5c2m4SvdCXK2Z7
         uSp3owmHBeiTiXryThQlfCVcTcb+EY4WFxjXkAMxcEn2mtxisutMagOfBkdf8m4rF7
         eir0MKWXkaLO3ME+STnXPmJ4DgrkMc6KEtUmmT+nn3qQOYBN3dqocoUzBtlWrRu2Q9
         3lQ6ZXePpfBmHghh99W08Hi8bIMTXPb4iU0rniuXPBCbsnQJfqV0NWKtjRsdolCuZA
         OYWqZJud0BHRA==
Date:   Sun, 23 Oct 2022 11:08:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net] MAINTAINERS: add keyword match on PTP
Message-ID: <Y1T2j6qkBXwLj96b@unreal>
References: <20221020021913.1203867-1-kuba@kernel.org>
 <Y1Dh8kFNicjxzNHn@unreal>
 <Y1DmxBUCOYpWn5GY@unreal>
 <20221020105628.184765b0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020105628.184765b0@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:56:28AM -0700, Jakub Kicinski wrote:
> On Thu, 20 Oct 2022 09:12:20 +0300 Leon Romanovsky wrote:
> > > Should I try it differently?  
> 
> I think these are supposed to be Perl regexps:
> 
> 	K: *Content regex* (perl extended) pattern match in a patch or file.
> 
> IOW try grep -P rather than grep -E.

Tried now, it works, thanks.

> 
> > And maybe "K: ptp" will be even better.
> 
> That may be too wide, for instance it matches PPTP :(
