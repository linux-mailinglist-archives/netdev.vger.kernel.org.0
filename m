Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC059CE04
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239162AbiHWBp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbiHWBp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:45:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7002B33E2C;
        Mon, 22 Aug 2022 18:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19F32B81257;
        Tue, 23 Aug 2022 01:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B39BC433D6;
        Tue, 23 Aug 2022 01:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661219153;
        bh=2U3JVa53oidkjOoPz7Z3M9E9nhiMVAytXWsA/3ptYks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SsuirfiHwmlZpOXcb6UQlqDAa+a2hbO5LxmXyZq27QPqKFUxoaOv5VQFTsU9U7V+h
         02oVJGNblllBdTuSFizdfvw7vQrfu2e6PinXdVnraLXvkrYQDhPvSO601G9uIMD5KC
         zAbcVLNW4o/mqkxOYKbFA4EykVUynSuOjRnJOjFa4dTYhN7YpD/uJJFW/i0ZGwiOIu
         CTyNvHEElhf+QcTZRdt97uXMve+QdcMzCBO01SX6zywV+6oKXLj5dWm8gsUNhPhunn
         LGxODMdsxiZVf+CrmRbfFBY++6nXGRZVzDJ29b+RmAubMWL18hr5SJb2wuc67N2nTz
         QOUvwOvGDjAVA==
Date:   Mon, 22 Aug 2022 18:45:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: [PATCH net-next v3 0/9] net: marvell: prestera: add nexthop
 routes offloading
Message-ID: <20220822184552.7d87c95b@kernel.org>
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
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

On Tue, 23 Aug 2022 03:10:38 +0300 Yevhen Orlov wrote:
> Add support for nexthop routes for Marvell Prestera driver.
> Subscribe on NEIGH_UPDATE events.

Does not apply. 

Please make sure you wait the required 24h period before posing v4.
