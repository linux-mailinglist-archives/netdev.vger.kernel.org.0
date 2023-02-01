Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2570C686DE0
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbjBAS0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbjBASZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:25:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D247F68A
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:25:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F258FB82267
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209E2C433D2;
        Wed,  1 Feb 2023 18:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675275947;
        bh=+ysKNM/qX+vUFh7ls46wGK+gSEJSUWfzN8v7hHVOH0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jCsQxnDvbkdPXr3c/jbkTbdPBO5OjzBe2P2sADtfmFOt5CYeqCV0kAMpICSZu+snk
         pY/Fuf5kE/fjnZ03HopADqksMCchKJIUYeWr1pknUFZo9o6zFRFtEZwxJdY8zmvllH
         wHCEoBHWha3YrGRDwbSBRhD3Q1Jb/yfjhZl2zjtR4iH4Wmd40cNlM/DjTzyvLdUJxg
         pGImQZJKDjSHPVcZa0Rdf4CKErmjcLk85YqMeE8Vxy9ZsDozcwMuix8/fLRggJ0HEQ
         DokvVRHaiFhpp2gYMYgJx2KADGULReG8jNq0OXvF3GEu4OeTkK/dy/3PORCENUbYm6
         tL9yZV45YVQ/A==
Date:   Wed, 1 Feb 2023 10:25:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: Re: [PATCH net-next mlxsw v2 00/16] bridge: Limit number of MDB
 entries per port, port-vlan
Message-ID: <20230201102546.1d1722ae@kernel.org>
In-Reply-To: <cover.1675271084.git.petrm@nvidia.com>
References: <cover.1675271084.git.petrm@nvidia.com>
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

On Wed, 1 Feb 2023 18:28:33 +0100 Petr Machata wrote:
> Subject: [PATCH net-next mlxsw v2 00/16] bridge: Limit number of MDB entries per port, port-vlan

What do you mean by "net-next mlxsw"?
Is there a tree called "net-next mlxsw" somewhere?
