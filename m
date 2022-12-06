Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0B644270
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiLFLuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiLFLt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:49:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB5C1CFFE;
        Tue,  6 Dec 2022 03:49:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC22D616D4;
        Tue,  6 Dec 2022 11:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F47C433C1;
        Tue,  6 Dec 2022 11:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670327395;
        bh=Mwq5NuUta+wRMLWCv1J/+EfioKOtv+vyJzohqHnIx/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iaQE+6AEDlB+uXpLw/GQu62g48FT/7nlHQ+9v8EwFMYhGKEoK5xw+ROVYN41XspLY
         2FVUzSPuNaxt1vN3rghloroJCGx5ImeopcQbXdc63ILKYJFTNta2IsQ+IHN9XQEvhX
         spIAeEpTsjZ8gbSIKwoWEawQ3u6zefLpeYZ6+xpZN701120ChN/tYkvu/Oq2BQGFtw
         eF+32F3cmZNzU4mOhVQEigHyWx3XE4wWJ3Ufr7C63RGp6OwVzKmSOf8Q5gymsYgLEd
         1SgMzE4IXTKQ+Fc/8ehDBL68//F5dxxvlYUuZovAchMr5qiDhVYduVc2jKMWafNQfq
         n8HZ9xaFgIsCw==
Date:   Tue, 6 Dec 2022 13:49:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 net-next 0/6] net: ethernet: ti: am65-cpsw: Fix set
 channel operation
Message-ID: <Y48sXm0B67u/hSQI@unreal>
References: <20221206094419.19478-1-rogerq@kernel.org>
 <Y48T4OduISrVD4HR@unreal>
 <fed09b42-7891-0a5e-3fd9-1ab65d090271@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fed09b42-7891-0a5e-3fd9-1ab65d090271@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 12:15:17PM +0200, Roger Quadros wrote:
> On 06/12/2022 12:05, Leon Romanovsky wrote:
> > On Tue, Dec 06, 2022 at 11:44:13AM +0200, Roger Quadros wrote:
> >> Hi,
> >>
> >> This contains a critical bug fix for the recently merged suspend/resume
> >> support [1] that broke set channel operation. (ethtool -L eth0 tx <n>)
> >>
> >> As there were 2 dependent patches on top of the offending commit [1]
> >> first revert them and then apply them back after the correct fix.
> > 
> > Why did you chose revert and reapply almost same patch instead of simply
> > fixing what is missing?
> 
> v1 & 2 of this series were doing that but it was difficult to review.
> This is because we are taking a different approach so we have to undo
> most of the things done earlier.
> 
> It was suggested during review that reverting and fresh patch was better.

Thanks.
