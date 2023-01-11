Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21DA66519D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjAKCTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbjAKCTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:19:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA5EC05
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 18:19:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14867619F6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 02:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F355C433EF;
        Wed, 11 Jan 2023 02:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673403548;
        bh=QXSoLVticgbS2yqndMr7OxVDMtt9w1dkgisfe/DRvXg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jncl4D4JxEj87aGwZxtKmUEotwUGxWrNAhQSu+X+fJ5VTTnTNFCqoz+xyFJ6LUpjk
         t3GxtFVOGns9l0nK3Oyoa9E4ALU+3GQD8IUJWWcqD7rNChKItsFSjy7sVk5Ub6nu5e
         XV4cSVRvkHzCKkRonDQBOPak8+YYhUAlK0AWqD1nUbhtVivLSm82xqFlB99Av2pleH
         KYhSwfolBNxXKPgOUM6XINdhjHaEPagb3GE+Ieb1PG+kvMsydOpKaO8cbRvCFwK7Lz
         qv8UT8I5Bf4dXafzL0wPkAPSGsqBjJjRH86bnpJ017rAAepmF5+jBnoyx7jz7X70fU
         Mc2i6oyZF9Rlw==
Date:   Tue, 10 Jan 2023 18:19:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org,
        jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v7] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <20230110181907.5e4abbcd@kernel.org>
In-Reply-To: <Y7xFiNoTS6FdQa97@lunn.ch>
References: <20230109153508.37084-1-mengyuanlou@net-swift.com>
        <Y7xFiNoTS6FdQa97@lunn.ch>
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

On Mon, 9 Jan 2023 17:49:12 +0100 Andrew Lunn wrote:
> On Mon, Jan 09, 2023 at 11:35:08PM +0800, Mengyuan Lou wrote:
> > Add mdio bus register for ngbe.
> > The internal phy and external phy need to be handled separately.
> > Add phy changed event detection.
> > 
> > Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Any preference on this getting merged as is vs Mengyuan implementing
the c45 support via separate callbacks? I just applied the patches
adding the new callbacks to net-next:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=ef1757ef58467310a285e57e6dbf6cf8314e5080
