Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D40E4B5FF6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 02:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiBOBWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 20:22:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbiBOBWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 20:22:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4C9BBE05;
        Mon, 14 Feb 2022 17:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5A1AB81756;
        Tue, 15 Feb 2022 01:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358C3C340E9;
        Tue, 15 Feb 2022 01:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644888141;
        bh=xtE2jausP+OWLX7490Gt3bQOF1MxHFx8C0lh6Xf2gkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Grn/KSlMglWD2OD9GyNT+L2SieDw4XsY+23za7RJpQJM734jyv7/GP2eCyhJtktJM
         zQyY/qpwS7SfvPrltLleC7OE520maFKhutUCOuNVeMtgBCTCRfW8M2CczjBLYnMGRR
         SYL86BHMEDPy6RsOWL0pvrTZ804feeC6MQPfZ5RBzSEzOnfX85WN1qP+uuqARTu904
         42ta+Rva4pBuohxvhmSEs6nQV5/5Z4oOl+zU63OfGyRi9aJb7Jt3q86quvnKoTeKsY
         ujWRvMjOj4lsQQfqXc3NZDZsnfe8ayPN9qtq0xbXH67gwgbsuhUwABO2Ul1HplCCPK
         hxennj4irw7lQ==
Date:   Mon, 14 Feb 2022 17:22:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: prestera: acl: add multi-chain support
 offload
Message-ID: <20220214172219.30a84465@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1644826807-15770-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1644826807-15770-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Feb 2022 10:20:06 +0200 Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Add support of rule offloading added to the non-zero index chain,
> which was previously forbidden. Also, goto action is offloaded
> allowing to jump for processing of desired chain.
> 
> Note that only implicit chain 0 is bound to the device port(s) for
> processing. The rest of chains have to be jumped by actions.
> 
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

Looks applied, commit fa5d824ce5dd ("net: prestera: acl: add multi-chain
support offload") in net-next, thanks!
