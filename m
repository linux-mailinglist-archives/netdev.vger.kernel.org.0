Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD7C4BFFE3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiBVROq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiBVROm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:14:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3AB10819A;
        Tue, 22 Feb 2022 09:14:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CD306118F;
        Tue, 22 Feb 2022 17:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA78FC340E8;
        Tue, 22 Feb 2022 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645550056;
        bh=vRqY29fntE05nLf7lFAfgWZ5noPzhBfh7WEWe2X8P+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YTjkmLatV894MQOVVKiTTtIqRyxQIa3ho9Uq/MGTGVtDfDuMvlLCnUs9Zcx5XuNJh
         KFdpXyY61EAeRT/gq8ItqrRvdDHxrnLF9LI5avsJBl+UsWv6mcR/DBKm8Q4tpBmcic
         /LibLHBfwdU3/JxX9IU3hamNlIiCU6ygiyzWL0VvZ1SVpUUw6fETV2uqizaeuuU6YP
         Kg/7zR1qVuyjY9MS4g9BFmYovGJv/LEPfPCFgU9RVnMmhcIt/Z+qFcL9LY8OTgDUcI
         5mSCRcqIeYmMSkFtf6HjwFO2ydt9mtBUJQV6u5g+QLTNf0kgngxs/euKYwMeNLN6ue
         2pEm+4b+ATn9A==
Date:   Tue, 22 Feb 2022 09:14:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5,v2] Netfilter fixes for net
Message-ID: <20220222091414.749bb106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222073312.308406-1-pablo@netfilter.org>
References: <20220222073312.308406-1-pablo@netfilter.org>
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

On Tue, 22 Feb 2022 08:33:07 +0100 Pablo Neira Ayuso wrote:
> This is fixing up the use without proper initialization in patch 5/5

Thanks! FTR pulled as commit 5663b85462a6 ("Merge
git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf")
