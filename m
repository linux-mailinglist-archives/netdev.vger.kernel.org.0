Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B3252C359
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbiERT3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 15:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241906AbiERT3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 15:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083121BB995;
        Wed, 18 May 2022 12:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 908F3618E8;
        Wed, 18 May 2022 19:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E93BC385A5;
        Wed, 18 May 2022 19:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652902183;
        bh=NFU8Dltu1a3EaEm+eHHhfuxHSuzLiRVDVZT53zcHvbA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X7D6sKrkOPrdyENXW9u6orQenvsNgVaFQtc5cMMOOCTA3yto3xW6SYCDN9UymdgF1
         1UFPMc8Rik/Nit5xkIgfuPTL0nqgBRIVsaaAT4FAemdXTSjwINBcyA9G8jaRQKf/lX
         z5odB25vLm7lvtHsNWG4sgbQO8SHHKrhYy9lTETifApHcpIgZgbRWlCpAzBJW6QLm4
         F1FHfMU5X3uRR9/tHCobVxm/saKn4lBvENFD5sjeHG0XGHJ+YvHeXBYPvjpVytpiHG
         qCPGgey4h1OWnbKhfHp/T6wCA59lPGU/0PcE17rMXwMdx4MO901ArtB7HrSPKcsDK7
         pBLHrTKlOb3Sw==
Date:   Wed, 18 May 2022 12:29:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Stefan Schmidt <stefan@datenfreihafen.org>,
        alex.aring@gmail.com, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: ifdefy the wireless pointers in struct
 net_device
Message-ID: <20220518122940.6f4da4a8@kernel.org>
In-Reply-To: <d161164cbb1d048ce1b2d99d23ed87c605cfaa8c.camel@sipsolutions.net>
References: <20220518181807.2030747-1-kuba@kernel.org>
        <d161164cbb1d048ce1b2d99d23ed87c605cfaa8c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 20:59:21 +0200 Johannes Berg wrote:
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

> Do you want me to follow up with trying to union the pointer into
> ml_priv?
> 
> I prefer to union it rather than use ml_priv because we'll not want to
> use the getter everywhere when we already know, only on the boundaries.

Your call. Replacing all the direct references with a helper call could
indeed be onerous.
