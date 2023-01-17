Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779F966D67B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbjAQGoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbjAQGoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:44:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605942005F;
        Mon, 16 Jan 2023 22:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F033260F75;
        Tue, 17 Jan 2023 06:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77024C433D2;
        Tue, 17 Jan 2023 06:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673937843;
        bh=Udx4r/gXUNGK85PWEZcekLE/XqdTwwDIDXtajpnNYVI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=buBlts+XQqKp13V+BFgCkpNF388yQyubFLcLITHOOXcUAPFff2l8KpxcsyLtTD/tq
         tqhHAJM51MrZrEujZHxyFChV6stIEjmgGvKeh7RqOfaVfw/bhCaprzk3sDFhK+9hvH
         Tx4ORdY2v8qOTuH/FViR7CBDUGHgpLtGrhJUtm9cvcF0laqaIy/NpaaPrFr35YND0c
         EzNMVlxaS8s1tX6enWKJEMRaahRAv4laQR24fMBlzoLb2s4UvtQ3ohU5XTMUHXXLJQ
         YAbcQpawWwH0P+DX7Ph3cxxiWO5C9HMaSbncin6p5d78c6oRqpl/dZ93JKbeItqUqi
         sxDqgW/WC0Tiw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] wifi: rsi: Avoid defines prefixed with CONFIG
References: <20230117032729.9578-1-peter@n8pjl.ca>
Date:   Tue, 17 Jan 2023 08:44:00 +0200
In-Reply-To: <20230117032729.9578-1-peter@n8pjl.ca> (Peter Lafreniere's
        message of "Mon, 16 Jan 2023 22:27:29 -0500")
Message-ID: <87mt6h8xu7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Lafreniere <peter@n8pjl.ca> writes:

> To avoid confusion, it is best to only define CONFIG_* macros in Kconfig
> files. Here we change the name of one define, which causes no change to
> functionality.
>
> Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
> ---

[...]

> --- a/drivers/net/wireless/rsi/rsi_hal.h
> +++ b/drivers/net/wireless/rsi/rsi_hal.h
> @@ -69,7 +69,7 @@
>  #define EOF_REACHED			'E'
>  #define CHECK_CRC			'K'
>  #define POLLING_MODE			'P'
> -#define CONFIG_AUTO_READ_MODE		'R'
> +#define CONFIGURE_AUTO_READ_MODE	'R'

I would prefer to add a prefix instead, for example
RSI_CONFIG_AUTO_READ_MODE or something like that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
