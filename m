Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6464E30E6
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 20:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347539AbiCUTst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 15:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiCUTsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 15:48:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2158176298
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 12:47:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE240B819BC
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 19:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEBDC340E8;
        Mon, 21 Mar 2022 19:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647892039;
        bh=WrVmoyHHvP3KxUHXy/LLNp8kMGX3mrL7tjuXvepd5GY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UtdS+QfVGukgH9glb0lEXRud63OkpLWfVI8boFoL9pESGoIHuCFUsOpvHrzWrJRSz
         v1Z9v8QP+ISylmq+rekvN6A+jN1uaUhVFC9yKqNtFXxvAREKfkJ4uhDFRvN4t43+LQ
         StjNB7GG+0wJgZBzCUvg4RczhLatvDiUCwC71+plKBw+fTHpic0MMe9TlW0vqA+5T4
         gbGSLU8qxzck7+AC9HwBnFMZl851wlWGD9X6Y0gUvKfNAXJui7XfrlXaUzlBVgCzIl
         RRFg8SwBJaCr/3Z8+H1LawB+5UrDVQLQuW+xXtVXN6BMwM2PQyMDrnouywU26gP8+r
         tAiOe2G2hl+FA==
Date:   Mon, 21 Mar 2022 12:47:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 0/2] net: sparx5: Add multicast support
Message-ID: <20220321124717.610fdcdf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2c3b730d91c8a39e3e6131237ff1274dbd4b9cbb.camel@microchip.com>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
        <164786941368.23699.3039977702070639823.git-patchwork-notify@kernel.org>
        <2c3b730d91c8a39e3e6131237ff1274dbd4b9cbb.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 14:33:34 +0100 Steen Hegelund wrote:
> I have just added some comments to the series, and I have not had
> more than a few hours to look at it, so I do not think that you have
> given this enough time to mature.

Sorry about that. Is it possible to fix the issues in a follow up
or should we revert the patches?
