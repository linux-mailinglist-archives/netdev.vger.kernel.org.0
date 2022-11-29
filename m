Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C00B63B850
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiK2DAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiK2DAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:00:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C785545084;
        Mon, 28 Nov 2022 19:00:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5931D61551;
        Tue, 29 Nov 2022 03:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EE1C433C1;
        Tue, 29 Nov 2022 03:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669690803;
        bh=5btTgIEeLul1wxmf1BM9Yh4gkHLdgzHiv1lNNQuIEws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BnMSEkCBbbHX04jB5ycyfv9uxQibWA+H5AaTPzc/XeyVD7cvTmSmyxdSma/kJ7yXO
         NEKm+uEXyhIYEfPLV8wFANdeTYml0nbfiiharpnnsLn8XLXFSbP8C+ztpa93ORrQ6Y
         hqG+8I9Kpjgw1kwWXlVyCqQOIWdu5gz6dA89lJu3WwYiVlyBX1KP8FEvHhIDToAubo
         pD9R7ij713Uj/u0wrUTrcRtv+Snx13RxQO6tvryIhAb89rPhycqEyk+MTYs5KfWS82
         zrFVBGt6WLNkcFN4bkPt2hiFJSLjBUM9Xbsz3xz8jGzy+8ZJZS40OlUm+FNvhCAQPo
         Ujmqr7AO99oGA==
Date:   Mon, 28 Nov 2022 19:00:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Xiaolei Wang <xiaolei.wang@windriver.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Message-ID: <20221128190002.0cc0fc95@kernel.org>
In-Reply-To: <e1c8ef9c-5dce-485e-e363-abba3c1178a9@gmail.com>
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
        <20221125041206.1883833-2-xiaolei.wang@windriver.com>
        <e1c8ef9c-5dce-485e-e363-abba3c1178a9@gmail.com>
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

On Mon, 28 Nov 2022 13:05:09 -0800 Florian Fainelli wrote:
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks! Is this for next or for net?
