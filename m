Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF76BC40E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 03:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCPC6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 22:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPC6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 22:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DF818A86;
        Wed, 15 Mar 2023 19:58:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F59361ECD;
        Thu, 16 Mar 2023 02:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCE1C433D2;
        Thu, 16 Mar 2023 02:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678935510;
        bh=LXXNV2M9WlodvL95+MasX6cfMsuJjTIErSDW5SeOFNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DzBu+xABcCTXz7/LbeXrB6zObUcB49fcvafbaZ5Z7AWPXZnF4McDsi9ZuDSJKleKB
         YN6F/GUkPffb3IwaZSdE0wbO7o90/uwSWT5F2jXCqoQ9R0TlV91xdJUZGd+Bx71p2d
         hxT+TYWMp/XauYKudtQ7j/Hy92t2uQWFy1DlyYh1/YLLl2uoJhVgmIuFzA/RWDsVj5
         kf0D9kaSffb8azzBAtvOrS/PWR6QUpqLaAAqtHy21FpUj7//tQl67gigk51MJ9/ZDw
         zirVKLcjkbMkYUPtAyEYRtWM41KA6ZZ7XBTP/v1kOtYc9NrM6pRRKo9K2GYUVDrXtG
         yf8SS2kP68ttQ==
Date:   Wed, 15 Mar 2023 19:58:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230315195829.646db7b5@kernel.org>
In-Reply-To: <20230315183846.3eb99271@hermes.local>
References: <20230315223044.471002-1-kuba@kernel.org>
        <20230315183846.3eb99271@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 18:38:46 -0700 Stephen Hemminger wrote:
> On Wed, 15 Mar 2023 15:30:44 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > Add basic documentation about NAPI. We can stop linking to the ancient
> > doc on the LF wiki.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: jesse.brandeburg@intel.com
> > CC: anthony.l.nguyen@intel.com
> > CC: corbet@lwn.net
> > CC: linux-doc@vger.kernel.org  
> 
> Older pre LF wiki NAPI docs still survive here
> https://lwn.net/2002/0321/a/napi-howto.php3

Wow, it's over 20 years old and still largely relevant!
Makes me feel that we stopped innovating :)

Why were all the docs hosted out of tree back then?
Because there was no web rendering of the in-tree stuff?
Or no in-tree stuff at all?
