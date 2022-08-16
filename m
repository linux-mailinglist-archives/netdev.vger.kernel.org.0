Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165A6594F3E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 06:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiHPEEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 00:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiHPEDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 00:03:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6902734DBF5;
        Mon, 15 Aug 2022 17:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF710B812A9;
        Tue, 16 Aug 2022 00:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C50BC433C1;
        Tue, 16 Aug 2022 00:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660609976;
        bh=BSGgJ7iMZEYOSd5W2gqOogJBCuIfGXgdgTTD+Q2n6L0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oQI8afcC1WHLY52gT1Ikl7MWGgq6d04soh0goRzQBoAnNOrv/E2fTCw1iVOqdaNV2
         ZAUYIL0T4MymmSpzeNtcKqkcwGyXitcCdXxMq/MNosEBkN9WPkDXTNmMKA9FmSE43c
         yd/EaofDNFzD1VT0hTcGYU2hgn1cGY9wh/fgrZ/Wm49h/LOA6BaM6BT7KBJWik+mlP
         bckur/qT6xD05k4ylZRCXRU1mr9eNfh+pOvrzf3A6ElQKLiNjoNZ7i8sd5axweN2+c
         KPFeSDb1d4HHfyKugpItxfBlQs5BtRHt1gItx9lkHucT0xc6SosH1hiF/FJ58M9FEx
         KO8ZZnPI1Zw3Q==
Date:   Mon, 15 Aug 2022 17:32:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 1/4] ynl: add intro docs for the concept
Message-ID: <20220815173254.1809b44a@kernel.org>
In-Reply-To: <273db0bc09c0e074a8875679e5e07ea047b61c27.camel@sipsolutions.net>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-2-kuba@kernel.org>
        <273db0bc09c0e074a8875679e5e07ea047b61c27.camel@sipsolutions.net>
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

On Mon, 15 Aug 2022 22:09:29 +0200 Johannes Berg wrote:
> On Wed, 2022-08-10 at 19:23 -0700, Jakub Kicinski wrote:
> > 
> > +Note that attribute spaces do not themselves nest, nested attributes refer to their internal
> > +space via a ``nested-attributes`` property, so the YAML spec does not resemble the format
> > +of the netlink messages directly.  
> 
> I find this a bit ... confusing.
> 
> I think reading the other patch I know what you mean, but if I think of
> this I think more of the policy declarations than the message itself,
> and there we do refer to another policy?
> 
> Maybe reword a bit and say
> 
>    Note that attribute spaces do not themselves nest, nested attributes
>    refer to their internal space via a ``nested-attributes`` property
>    (the name of another or the same attribute space).
> 
> or something?

I think I put the cart before the horse in this looong sentence. How
about:

  Note that the YAML spec is "flattened" and is not meant to visually
  resemble the format of the netlink messages (unlike certain ad-hoc documentation
  formats seen in kernel comments). In the YAML spec subordinate attribute sets
  are not defined inline as a nest, but defined in a separate attribute set
  referred to with a ``nested-attributes`` property of the container.
