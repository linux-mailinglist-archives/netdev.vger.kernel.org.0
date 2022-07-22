Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6792857E8C6
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiGVVRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGVVRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:17:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6FF7E830;
        Fri, 22 Jul 2022 14:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEDC4620DD;
        Fri, 22 Jul 2022 21:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03400C341C6;
        Fri, 22 Jul 2022 21:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658524643;
        bh=R8Ls+2mIG649Ujc+HQ7M0na/jmw5uKyks/XLdAdrGsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NQpw7zNabnSfHkBJ9TRyrStRbCEV0seMqoPsPgT75M4pVlHIFr67iA8+ji5SVKxi1
         H/id8uxhPnh/uMQmdwlEkF3eu84WpB/U9VjMUOtfaCFZ/MuTaxZMbIDC2/E76TdV0f
         0sW3eulSepeXQKHcsZ6mMmNh6hWhNzMSaZ+J49AH2dIEjsrPuTGwQVeAb3301xXDJi
         UDEyWsf6e3pREacD8BV5auMQmnCCDhE3I/DVdrhZzXQ35Vg0u6TspbKE361q2xB5qO
         /c0BJGXF8awEO4RFBUxq4yAoNLO2JXRdC6RgWTtT13lMHYARfpjORd5oy8LaPa0mRU
         SIhM6vfOeFR9g==
Date:   Fri, 22 Jul 2022 14:17:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, tchornyi@marvell.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, idosch@nvidia.com,
        petrm@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] mlxsw: use netif_is_any_bridge_port()
 instead of open code
Message-ID: <20220722141721.79d6403a@kernel.org>
In-Reply-To: <20220721102648.2455-1-claudiajkang@gmail.com>
References: <20220721102648.2455-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 19:26:47 +0900 Juhee Kang wrote:
> The open code which is netif_is_bridge_port() || netif_is_ovs_port() is
> defined as a new helper function on netdev.h like netif_is_any_bridge_port
> that can check both IFF flags in 1 go. So use netif_is_any_bridge_port()
> function instead of open code. This patch doesn't change logic.

Appears applied:

c497885e3044 ("net: marvell: prestera: use netif_is_any_bridge_port instead of open code")
59ad24714b7b ("mlxsw: use netif_is_any_bridge_port() instead of open code")

Thanks!
