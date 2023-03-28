Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D306CCD9A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjC1Wl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjC1Wl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EBA1B0
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:41:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAFD8619A2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 22:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC72EC433D2;
        Tue, 28 Mar 2023 22:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680043316;
        bh=rf466V61DpUUK2d9tIKnXQHYA5HfD6+YAiSNakZut5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tmFrNuLB4dcsN1nralHAVXM05VX3UsuSe2csAA4qMroKI67u4SrIf/+NAAM0x0hqt
         RjgROYE44BogjvzuvXnQJNZdHKYGHlFhJ46yQ+yYs4o0E1SYDQWd+x5kzvahVfi+2u
         YCe2y+mBlpAht1Nwa5uza+to4KPrvkRvRP97RqS75CVYpGKDTlfM45GLBKtwmLsiLr
         ClZX0ZX7AvfMoSM3UlBTq2EdfNDxF8lCGzJs2vgjzYQ/hUUXziUWNskEYJIcYWuqfZ
         eA2j1pKOa5RoWr4zlkEop26bLRzzUeO9xR6dKxR25bLXgmPkRQ7Gv1Y7qt7q0vkKwD
         aEq1wWJ3D96Mg==
Date:   Tue, 28 Mar 2023 15:41:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <20230328154154.14bbee54@kernel.org>
In-Reply-To: <IA1PR12MB6353B5E1BC80B60993267190AB889@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
        <20230326072636.3507-2-ehakim@nvidia.com>
        <20230327094335.07f462f9@kernel.org>
        <IA1PR12MB6353B5E1BC80B60993267190AB889@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 06:54:11 +0000 Emeel Hakim wrote:
> > > +     if (real_dev->features & NETIF_F_HW_MACSEC)
> > > +             features |= NETIF_F_HW_MACSEC;
> > > +
> > >       return features;
> > >  }  
> > 
> > Shouldn't vlan_features be consulted somehow?  
> 
> I did consider including the vlan_features, but after careful
> consideration, I couldn't see how they were relevant to the task at
> hand.

Decode this for me please:
 - what was you careful consideration
 - what do you think the task at hand is; and
 - what are vlan_features supposed to mean?
