Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEBF632C8A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiKUTCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiKUTB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:01:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD161D28AA;
        Mon, 21 Nov 2022 11:01:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70C1CB815CF;
        Mon, 21 Nov 2022 19:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5834C433D6;
        Mon, 21 Nov 2022 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669057316;
        bh=5ksltyMIU3JUc2SCAQbfG8x5koWbUcghafEe3bQQ8u0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NBpKVYZlMguJBmksKAO66qFOmTI1c2Xc9wYBOyGQF08I5J8NfwSy7SJk9VT1rxGcs
         My0NlN2IqL0Y0ilZD1p5gQjVn12oktfrIkTQrswh8PKyyX8kRiZ6/fUC37IEngSErY
         oV/70IGEv1thBBM83e067UQ2SrAPKYD+GVmus++Zcd3AnhDB1l8wUoD+RE9FNEv/im
         mB4DziMQkFDcXwwBFNkOPQRhBCCmA6nJ/kX7CELn4WtZuxBMKVY6LqCg5WkCqB3V4k
         VllVr30qvYp4GC3mMHl2UQAnFKhhjHba8x4jWH3ZeyaXHqJoUs4cf/bIoZdxPMHC80
         wp9+lwYoLc9sA==
Date:   Mon, 21 Nov 2022 11:01:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v2 0/8] Add support for VCAP debugFS in Sparx5
Message-ID: <20221121110154.709bed49@kernel.org>
In-Reply-To: <20221117213114.699375-1-steen.hegelund@microchip.com>
References: <20221117213114.699375-1-steen.hegelund@microchip.com>
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

On Thu, 17 Nov 2022 22:31:06 +0100 Steen Hegelund wrote:
> This provides support for getting VCAP instance, VCAP rule and VCAP port
> keyset configuration information via the debug file system.

Have you checked devlink dpipe? On a quick scan it may be the right API
to use here? Perhaps this was merged before people who know the code
had a chance to take a look :(
