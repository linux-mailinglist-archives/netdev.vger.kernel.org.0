Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385664E555A
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245276AbiCWPfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 11:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245278AbiCWPfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 11:35:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B13476E33;
        Wed, 23 Mar 2022 08:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8CC9ECE1F7B;
        Wed, 23 Mar 2022 15:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858C6C340E8;
        Wed, 23 Mar 2022 15:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648049614;
        bh=HHpjM+vxWVbBCe6V1NF5CGoUQRBfQcOjymf2uEZ000E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B9nFk4+LCuPWqYmcQhoHvPXvfYCx2ZWxGXBrv+0OzmRIgRUZZgKqTSxxxjUJveJ/D
         Po5j+J8bz9qDYszkbKE56no4RCIm+cPpOozZD8OtOoxL+rkGdVBHJ2huj/UCfllMe2
         rn1jnp95Vkqn5wiijXtwg4+/SBvtALp0gwDHXliEaB+AxyRB0ZVCw801lZnbNDXpfw
         IZmNK8662/r7/q1PmCI/60uPoiXLVB6IY6Bpj/XIPiOouLGd0Ex77u6HKYrW4Spmm6
         O919xuJvIwwEFH9I8ejowFE+wJGOVqyG+gc/mSWTAD013v8NYOL1f+P7esGxqwEmC/
         ChNA5uD+Mp4zA==
Date:   Wed, 23 Mar 2022 08:33:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, oliver@neukum.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
Subject: Re: [PATCH v6 0/4] Add support for IPV6 RLB to balance-alb mode
Message-ID: <20220323083332.54dc0a6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7288faa9-0bb1-4538-606d-3366a7a02da5@kernel.org>
References: <20220323120906.42692-1-sunshouxin@chinatelecom.cn>
        <7288faa9-0bb1-4538-606d-3366a7a02da5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 08:35:03 -0600 David Ahern wrote:
> On 3/23/22 6:09 AM, Sun Shouxin wrote:
> > This patch is implementing IPV6 RLB for balance-alb mode.
>
> net-next is closed, so this set needs to be delayed until it re-opens.

What I'm not sure of is why this gets reposted after Jiri nacked
it. A conclusion needs to be reached on whether we want this
functionality in the first place. Or someone needs to explain 
to me what the conclusion is if I'm not reading the room right :)
