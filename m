Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991974EF98D
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbiDASM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiDASM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:12:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13BC12E75B
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5851360C35
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 18:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5227DC340EE;
        Fri,  1 Apr 2022 18:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648836636;
        bh=YBIIsVfU1lUzYS2Ml6mEX7b3TKPdqopWvYWtMmO1htU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u+ajwDaorXjGT8j54j36R+ktFObu85ILuvcPLxMVDh5nTq3wTtKHoV+LS3+Wbec2C
         y6vedvwU7ncm24e2cJ1cx+L8eUS6xcAoCD5zZPIDIK0JIZtevtRiG7gYhihvW5d8c9
         ZkajjYKe3mGQJrhwhVUoPLOZOA6+jprgfMKNE7ND4TEursOBN2I7zQmPd4o6FXhUpE
         LK4ipnrIXzzAD26ilUzg4JilzdbutbQjmPeT7h8v6jkNDUnBDDcIQdLwiNTQTJ33D+
         FfEN8heI9Y1haufP0av8ZyUppX70+jJs8KYRWln8lpUTSwq+4FZU1UFvxF5NstY+GW
         GIJI8VedlNWpA==
Date:   Fri, 1 Apr 2022 11:10:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v1 net-next 1/2] net: tc: dsa: Add the matchall filter
 with drop action for bridged DSA ports.
Message-ID: <20220401111035.3b570a28@kernel.org>
In-Reply-To: <20220401100418.3762272-2-mattias.forsblad@gmail.com>
References: <20220401100418.3762272-1-mattias.forsblad@gmail.com>
        <20220401100418.3762272-2-mattias.forsblad@gmail.com>
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

On Fri,  1 Apr 2022 12:04:17 +0200 Mattias Forsblad wrote:
>  	case NETDEV_CHANGEUPPER:
> +		struct netdev_notifier_changeupper_info *info = ptr;

I don't think C99 has been enabled, yet? You can't declare variables
like this. Please fix and repost on Monday when net-next is actually
opened.
