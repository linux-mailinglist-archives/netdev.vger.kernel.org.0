Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294F8647AC1
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLIA0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiLIA0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:26:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54931941AE
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:26:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1E7AB823C4
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A7BC433EF;
        Fri,  9 Dec 2022 00:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670545611;
        bh=NvnYA5vRCR8ez1cZDlV7Y39KCoQ3k573KWtFHyVxBtc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cJlOt+MoQba7iQ6nmDov3ikKLmjOswga//wYQPTMOsrtTgfexmsV4ATMYjTaDgFdS
         bUhNNnEkK2IvweD9IMwsShsdBvGswAFwoFyDSYEMWYCgXszME8HJ7xnTEEPAlZbchL
         rO9e9/5bxYXm/ZBFj7rQWpjqq6Mshq5orb0lVZ6dtd9fdvRMgTXygV07DHq0i7uhvs
         0sC9okpzB2Mwat1u32VUrSAzh+XnRabR8O59MvxRxhRSGx2y04T8VYXhx03NMit+Ya
         SBmstGZCdJ2xOluhaoT95nzO5YLmphXkEpisli3lNjgpMRqvwI6+L2h3UOXx2qRZ0T
         fnHi5WTvT7Heg==
Date:   Thu, 8 Dec 2022 16:26:50 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: replace ATU violation
 prints with trace points
Message-ID: <Y5KAyrdaL7qU/J+e@x130>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
 <20221207233954.3619276-3-vladimir.oltean@nxp.com>
 <Y5EsWNfVQrl8Nb71@x130>
 <20221208144901.tgdhp73n7g5uh7qj@skbuf>
 <1bf9be8b0877a0536b73ceaa957f6234@kapio-technology.com>
 <20221208152725.g4scosm5klsn5fqf@skbuf>
 <78b2412528dae7225d280a904a38bd67@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <78b2412528dae7225d280a904a38bd67@kapio-technology.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 16:35, netdev@kapio-technology.com wrote:
>On 2022-12-08 16:27, Vladimir Oltean wrote:
>>On Thu, Dec 08, 2022 at 04:22:53PM +0100, 
>>netdev@kapio-technology.com wrote:
>>>The follow-up patch set to the MAB patch set I have, will make use 
>>>of the age
>>>out violation.
>>
>>Ok, so for v2 I can delete the debugging print, since it's currently
>>dead code, and you can add the counter and the trace point when the 
>>code
>>will be actually exercised, how does that sound?
>
>Ok, sounds like a plan.

FWIW +1 :)

