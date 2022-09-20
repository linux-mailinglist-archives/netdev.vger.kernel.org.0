Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFCC5BEDE5
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiITTha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiITThK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:37:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F63B76745;
        Tue, 20 Sep 2022 12:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B98FAB82CA4;
        Tue, 20 Sep 2022 19:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BA5C433D7;
        Tue, 20 Sep 2022 19:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663702617;
        bh=vc+69lGHPMCCcLxrixDCEv244+sZsDSrdGTsQ1p30gc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WqyZcGF2dTF31x0/Utp0jJm3AMsPT77ZDQl9NWgsxOMAaLpPVERQVT9n/Ag/J7atv
         d3U16UVjZEkEhNOLlpxlHHSWg4ppZSHfODBL52DjhLOQ35X0yZKe8dwJLuCpWSW3nl
         9E1ePxPH17cdMdJiS6djeeW7xJ7jr2EzCDplJnm0k0gHCcCO+iQZ1OiUg05LnOqqO/
         zyTd7lwDHGeYu/VMAB+fhz2xxsgvYHGWU3YETguDc+9SMIW9L24a1PLmI6VIoHXgsO
         /FA9IivYi9Sz3ab17Sl97iGIGhdF1HhUCFiT2EnZIUyBFGXv4EWoYr0L1np9LlPK++
         KizMO6Eofzqvg==
Date:   Tue, 20 Sep 2022 12:36:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH net-next 04/13] sunhme: Return an ERR_PTR from
 quattro_pci_find
Message-ID: <20220920123656.2647c7cd@kernel.org>
In-Reply-To: <20220918232626.1601885-5-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
        <20220918232626.1601885-5-seanga2@gmail.com>
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

On Sun, 18 Sep 2022 19:26:17 -0400 Sean Anderson wrote:
> +	int i;
>  	struct pci_dev *bdev = pdev->bus->self;
>  	struct quattro *qp;

reverse xmas tree variable ordering please
