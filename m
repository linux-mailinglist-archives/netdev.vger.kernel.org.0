Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305C55993F1
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbiHSEMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHSEMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:12:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BABD41BC;
        Thu, 18 Aug 2022 21:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C909C61515;
        Fri, 19 Aug 2022 04:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C0FC433C1;
        Fri, 19 Aug 2022 04:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660882331;
        bh=zUJckJ/QPMvQTfZBiArkTJRHxfoedO1VgMWV4Lpan2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A4mbdQcXUZ9MH+hnIlCyhW+ZeodmFxLmU7PP1TcCWdSWjbKgNbvY1SYoerPJH03ja
         nacNyJHI+PUIPih01S0juAb0Na9scln1cNNg/qeRfaqJhR7dngGjHI9YgyuH4ee/4T
         JojcmhWnmjagRqcTzo1+WMQWdchrGeyJCQgzWEEVbfkSiBmdyV7Ka4PcxlkmCpBo8T
         VbTZl+eqc5Zw4FwR6iSGSnnkIooy3HAXXuZ5XgtNRwK+sp+NvS1fevjnaXAV0gR02W
         83EMJ8hlvSjV6cv60R9OAFLrH4mseFk4B/tKMipNNFahN5JyXaTPQoCb7tQsuO6kDQ
         CRkpwYycsdBtQ==
Date:   Thu, 18 Aug 2022 21:12:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaolei Wang <xiaolei.wang@windriver.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Don't WARN for PHY_READY state in
 mdio_bus_phy_resume()
Message-ID: <20220818211210.1fc7fc77@kernel.org>
In-Reply-To: <20220818072943.1201926-1-xiaolei.wang@windriver.com>
References: <20220818072943.1201926-1-xiaolei.wang@windriver.com>
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

On Thu, 18 Aug 2022 15:29:43 +0800 Xiaolei Wang wrote:
> Fixes: fba863b81604 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")

I think the hash is wrong here. Please fix and repost (make sure to CC
the right folks once you change the hash).
