Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F705A8BA6
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiIACzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiIACzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:55:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EDC252B7
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 407EA61DB1
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497A6C433D6;
        Thu,  1 Sep 2022 02:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662000936;
        bh=RGUe3QhcmaFB5Dl/4wPND6/kcP7XG+BPivGdaG7z92Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sk4z5PNuO0CWfleKxrWfDW6OTmYSWgA5v67D5/H+V/BWxykd+LnCFS66vUAqndfgr
         ymiSRDv8CAq1iQ5Agrgdrm1P/vLRXS8KLWowjGbB6s/jVeGXkq4M1EANd3+AQ0j2sz
         AWqLhJ19CuhHndcYJESbH52BhUOq9H7Q4GJpCkKTejfC0A9pcpD1gz1I+0ftKKREcT
         d0JRub52ygu3r6UbN3dosXCgd5ejnlWgtn5dGrh7ws46enQBLR/SgZ6B/84oU/vw4Y
         USyOb4h11C0jdTOuECftcPW3rkuIXo5mx5CjFqMa5gHFFEZ+LbB3hiXju3ewap0N06
         DquZIgEcr0hNA==
Date:   Wed, 31 Aug 2022 19:55:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
Message-ID: <20220831195535.39d1bf0b@kernel.org>
In-Reply-To: <20220830163448.8921-1-kurt@linutronix.de>
References: <20220830163448.8921-1-kurt@linutronix.de>
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

On Tue, 30 Aug 2022 18:34:48 +0200 Kurt Kanzenbach wrote:
> In case the source port cannot be decoded, print the warning only once. This
> still brings attention to the user and does not spam the logs at the same time.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

The ongoing convo is tangential AFAIU, so applying.
Applying to net, 'cause printing warnings based on packet
contents without a rate limit is a bad idea.
