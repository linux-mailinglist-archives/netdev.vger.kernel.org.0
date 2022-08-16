Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCAA596271
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiHPS13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiHPS12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559B486FDD
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90A04B81AAC
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 18:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB4FC433C1;
        Tue, 16 Aug 2022 18:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660674441;
        bh=qvk/krCmy8wrZ6NYeKjgm1IKaO6UueuYPMjnxXw15Qc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z/RfRVPkL94LwDVOm8a8sIdaTTlEltWB9P8c9CdJskqX8Tb2bbZANjYU73kean2Sc
         av24vp+s5G2ksVm2R1t0bXnq5pdEZK1p2YATXBrRz7UguWQ8SntO1zxSuBSvfPs7oL
         TNPf2+lvUfrQT/rgFiNR8Zwklhk8sSUk92zxb9dyZJjnXMJHZNx12AdPtt4xnChdyw
         AiYIMtDDyQNoj4Gf60MUuoRW4JZz34JjJnRgZQmIb9Ks5feuVrH6QzlCtM7EoFRART
         KFOacb+rHteocbIIPpHp7RCLR/qpkxQ2k9TeSeuYGJiyyNviqkEoMvI4QyFcjZSm+A
         zZ84G3NU+fXuA==
Date:   Tue, 16 Aug 2022 11:27:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wei.fang@nxp.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, xiaoning.wang@nxp.com
Subject: Re: [PATCH V2 net-next] net: phy: realtek: add support for
 RTL8221F(D)(I)-VD-CG
Message-ID: <20220816112719.7ee5531a@kernel.org>
In-Reply-To: <20220816194859.2369-1-wei.fang@nxp.com>
References: <20220816194859.2369-1-wei.fang@nxp.com>
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

On Wed, 17 Aug 2022 05:48:59 +1000 wei.fang@nxp.com wrote:
> From: Clark Wang <xiaoning.wang@nxp.com>
> 
> RTL8221F(D)(I)-VD-CG is the pin-to-pin upgrade chip from
> RTL8221F(D)(I)-CG.
> 
> Add new PHY ID for this chip.
> It does not support RTL8211F_PHYCR2 anymore, so remove the w/r operation
> of this register.

Also please fix the date on your system, you seem to be talking to us
from the future :/
