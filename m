Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90496B193C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCICes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCICer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:34:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A37B82377
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 18:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DA71619E4
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5F2C433EF;
        Thu,  9 Mar 2023 02:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678329285;
        bh=jx6nY2JVt6L6luYz3YH5FIcJBV4dwIZNlMQXLmY4LVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eEwtwzcWFCRDod614+HiA+LDwik/bUETu9raUfGXITxGF83JM81ljO8YRrcaLAIdv
         6tzne85iyUnf8O32/MjzJiLcUUmNChkIepZ+JfMBT++N6hXI2PQXtDsYR2Wctr1xH1
         +61f8eWGR3XlUh6VyNVBVCjyV8aqh6IQeunxGtu0HFdXvZaC3LLfz0wHBneCKS2+cr
         AcjchoeWJVU0/Rq5nXohvWFgKJ7Jm81bsMYtrPcEtu0JOL5JvD0YT3Awg/OST9sgw7
         xqfDKcg4lSlZHjzzmjsu/MFJlW4ro5cXrNUhDEeVJVfWQv1P5Vnshiw3fvVdKmENRK
         ZoGiXrgdjY99g==
Date:   Wed, 8 Mar 2023 18:34:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v3 net-next 0/5] Add tx push buf len param to
 ethtool
Message-ID: <20230308183443.5284c51b@kernel.org>
In-Reply-To: <20230307102458.2756297-1-shayagr@amazon.com>
References: <20230307102458.2756297-1-shayagr@amazon.com>
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

On Tue, 7 Mar 2023 12:24:53 +0200 Shay Agroskin wrote:
> Changed since v2:
> - Added a check that the driver advertises support for TX push buffer
>   instead of defaulting the response to 0.
> - Moved cosmetic changes to their own commits
> - Removed usage of gotos which goes against Linux coding style
> - Make ENA driver reject an attempt to configure TX push buffer when
>   it's not supported (no LLQ is used)

LGTM!

Feel free to add my:

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

On patch one, because checkpatch will complain otherwise.

And repost as non-RFC.
