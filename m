Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1EA5677B7
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiGETXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiGETXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:23:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804FC13CF7
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 12:23:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D44F9CE1CE8
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 19:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06991C341C7;
        Tue,  5 Jul 2022 19:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657049019;
        bh=a1QhGobGGck9fYK28TfvF/uBRmQzx1mW8fvLYxe7ud0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gCVkUbFeAepDHcZsbfREmK1yh2KbFXj1P+6YG1aOQRHwnYqpdrsw/0/UwYnJgVtLw
         yGWX/WHg1aQhq9OElUCBkIFngU0x8PMjsWRQuyB8X6RuuofA5z17Dl++FXq8CklpDV
         TDTChte3NF3x7MzbuvK4aJAZPLuIcCZpw9V2hreP2HEW6LUbknwYLqAnzgXPxGOc0V
         kq8Tp1bSHhRuXQUnGJF73UMeeSuD8IDedstZclwrBJywqrLJuONkO/ESs4sTiguhel
         BdiezL2J78OpY9C96b9CEq7HWNxYO+FyG1YLJ+oGguKys+QtXb1l8NZmaZ3eLVucPI
         hYaj+pKJPHkhQ==
Date:   Tue, 5 Jul 2022 12:23:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] r8169: fix accessing unset transport header
Message-ID: <20220705122337.696a6d78@kernel.org>
In-Reply-To: <1ca36910-31c0-ead6-d19e-c200eff752b4@gmail.com>
References: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
        <1670430b92ef3cbda6647ce249a6bafb9d243432.camel@redhat.com>
        <20220705121230.69a4e0e8@kernel.org>
        <1ca36910-31c0-ead6-d19e-c200eff752b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 21:18:43 +0200 Heiner Kallweit wrote:
> > How about we put Eric's patch under Fixes? The patch is not really
> > needed unless the warning is there.  
> 
> This would also be an option. It just seemed a little illogical to me
> to leave the impression a new (useful) warning needs to be fixed.
> Just a few seconds ago I sent a v2 following Paolo's proposal.

That's fine. Perhaps I have more utilitarian than literal view of the
Fixes tag than others (how far back can the problem trigger vs blame).
