Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6A16809DC
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbjA3Jsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjA3Jsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:48:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DE1196AF;
        Mon, 30 Jan 2023 01:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCADB60EFE;
        Mon, 30 Jan 2023 09:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556E0C433D2;
        Mon, 30 Jan 2023 09:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675072124;
        bh=5LtIlqjKnHPmPhoTd1JoMdvaD6d6QRzhmsfGLeEORLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bycmB+k2yfXw+2NKeuDxedEZTzyTmDVUFMa7ZjGhWUMU6wjzCBxyp67Qn0jQLn1co
         KRHkYK38WGkwkx1PnNytKRnTg10yumDgn3YuEpy4p3KKTECofzIwtmwm2qDfjjhOTr
         lML3dtn/g++WK2oMAHjQwNZK3AEvIjaef3mYJP/a6kZsI5OjJm2K/aQMOyiCmsWHSM
         cik4Qq+vyUGCXCwM5F7PpzzGYDFIof9B25X2ACF4d1AzTJo4IACeach6iKvcbwv7IC
         Z2hTH7SUSQSjMpLzAYX+laQ1m2BslNhrLYv/hi5clkVnT4AhLBKitx3NYfnX2lhm26
         o89E6AG03hUDw==
Date:   Mon, 30 Jan 2023 11:48:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc:     netdev@vger.kernel.org, Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: tulip: Fix typos ("defualt" and "hearbeat")
Message-ID: <Y9eSdwA24uz2W9Z0@unreal>
References: <20230129195309.1941497-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230129195309.1941497-1-j.neuschaefer@gmx.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 08:53:08PM +0100, Jonathan Neuschäfer wrote:
> Spell them as "default" and "heartbeat".
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
> 
> v2:
> - also fix "hearbeat", as suggested by Simon Horman
> ---
>  drivers/net/ethernet/dec/tulip/tulip.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch title should include target: "PATCH net-next ...".

Thanks
