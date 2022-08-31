Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C0C5A7630
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiHaGF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiHaGFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:05:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A81531226;
        Tue, 30 Aug 2022 23:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA758616FF;
        Wed, 31 Aug 2022 06:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DEEC433C1;
        Wed, 31 Aug 2022 06:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661925921;
        bh=1o734kbPT2aSPyWXx6uaFvK3CaaLOF8FTwNTJ7jLcj0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lg6WJEPRuwERlCGI5pF5z5HBjJMfJZkC+RDVNKs4tio92gfSZSK3HC4zTfoZNKU0o
         afnSltf1KXT4QifNdqzeW81TgCyvkGAj+PONyfedDeD7c3+CBvYSp9Q9AlMnSz1QvV
         rSE6Cvgg7oIMTIkEG+dEg+SJ0JdiM2ajoZzBlnuwrKuHLX5o89mZjRJzBeXB6bd6b6
         UsEKHThSKtOU25YnrehSDy2I4/utXOAm7EnCOe3s8WLec3DnAGQvP08io4/+QFNexx
         vfDQeBT8pcpfRhuL0dI1h3w0YlPSR54RWqntCiO327X+2m9txc2JknjTM4eUbRbtFg
         Tf0UXbE8qanDw==
Date:   Tue, 30 Aug 2022 23:05:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] mlxsw: remove redundant err variable
Message-ID: <20220830230519.4e92813a@kernel.org>
In-Reply-To: <20220829105454.266509-1-cui.jinpeng2@zte.com.cn>
References: <20220829105454.266509-1-cui.jinpeng2@zte.com.cn>
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

On Mon, 29 Aug 2022 10:54:55 +0000 cgel.zte@gmail.com wrote:
> +	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
>  					     mlxsw_core->bus,
>  					     mlxsw_core->bus_priv, true,
>  					     devlink, extack);

Please realign continuation lines so that their starts match the
opening bracket. Please keep the review tags you received.
