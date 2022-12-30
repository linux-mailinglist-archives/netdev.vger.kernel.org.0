Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB2465942B
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 03:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiL3CWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 21:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiL3CWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 21:22:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E6A60F6;
        Thu, 29 Dec 2022 18:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED4676195E;
        Fri, 30 Dec 2022 02:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEABC433D2;
        Fri, 30 Dec 2022 02:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672366949;
        bh=nKnAUzAGtaNsOyNHfeMz9+XTv6Ka1NzOGQRLHLJdiVM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GNyvDKvnL39Ewu85kv9/6udSEiR8NvCQCdzF0s3O4Hm71xAQx9hSOstrw+ON9uHrf
         TDZd5yN1KkkQ6dfMYVzhkFu2Le2e+gkIMYzQmN79S4pRP5XFE+UyEXpydCnCgd9QZI
         Co1Ttvb3FpDDYc7L+MAxE3i1Ufe3Nt3eEqIL8cMl6V+onkHuS/mLwNaOmASqRDvbtL
         +UZZ9rnRKAwox6RS9BJKrxnVgIWiPSiVukicDiAtFN1KAbmZZVbWeKjNyOMxFmgHPS
         Ty0n+PM2PpNqPJ46nWa//vbe0BPI3l2n5anwkIdrBJ/8kBepZg5CF2BbCDM9nTAqOl
         Uz0OHwkiarqEQ==
Date:   Thu, 29 Dec 2022 18:22:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RESEND PATCH net v1] drivers/net/bonding/bond_3ad: return when
 there's no aggregator
Message-ID: <20221229182227.5de48def@kernel.org>
In-Reply-To: <20221226084353.1914921-1-d-tatianin@yandex-team.ru>
References: <20221226084353.1914921-1-d-tatianin@yandex-team.ru>
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

On Mon, 26 Dec 2022 11:43:53 +0300 Daniil Tatianin wrote:
> Otherwise we would dereference a NULL aggregator pointer when calling
> __set_agg_ports_ready on the line below.

Fixes tag, please?
