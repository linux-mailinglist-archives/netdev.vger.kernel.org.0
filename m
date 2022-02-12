Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E46F4B3259
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354525AbiBLBMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:12:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiBLBMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:12:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5E3D52;
        Fri, 11 Feb 2022 17:12:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE79C61D49;
        Sat, 12 Feb 2022 01:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E745C340E9;
        Sat, 12 Feb 2022 01:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644628372;
        bh=J+mPftWcitDa1G9pdx+wjO91eRL1CiMarVvrNyHVUVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=itIXLyDbbdZoLxRo3JxAQKgmdp3qNL4XrapSrqR+NIL1SPZv1b6jCL7f0LlG9aq4H
         nL2cRsDUy7UHRxjDsrHTYBDDqai+SAga+4HQ632kZ0TIuO524qoW7LF+h0D1LcZ4qP
         feIF0qzP0Jcr/XJIlalg+Vk/V/uCtwXuM0yZ6sWZQtyr6M55YSzdUCmyFkE6KSYGjI
         XB3JH+r88lZRmb5CqERF35wZykAsxcltyVEYjaW9JFBh9FPkt8Es0c3JNIckCXB/lO
         5rRxmgZ7sx6qcHD35pFMlPYKVO7L+d6IqUBuqZCjXLL+L/KovkCthR0ug7SRFznjgF
         aItQ/aO+mVvww==
Date:   Fri, 11 Feb 2022 17:12:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Message-ID: <20220211171251.29c7c241@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
References: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
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

On Fri, 11 Feb 2022 11:20:17 +0200 Moshe Shemesh wrote:
> v1->v2:
>  - updated example to make clear SF port and SF device creation PFs
>  - added example when SF port and device creation PFs are on different hosts

How does this address my comments?

We will not define Linux APIs based on what your firmware can or 
cannot do today. Can we somehow avoid having another frustrating
and drawn out discussion that hinges on that point?

Otherwise, why the global policy and all the hoops to jump thru?
User wants a device with a vnet, give them a device with a vnet.

You left out from your steps how ESW learns that the device has 
to be spawned. Given there's some form of communication between
user intent and ESW the location of the two is completely irrelevant.
You were right to treat the two cases as equivalent in the cover 
letter for v1.
