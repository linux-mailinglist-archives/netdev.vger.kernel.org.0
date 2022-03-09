Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400F54D28A6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiCIGEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiCIGEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:04:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0110C70909
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 22:03:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9858CB81F39
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 06:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07262C340EE;
        Wed,  9 Mar 2022 06:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646805810;
        bh=XDnKUZ6b/DdH1ieWYkXJGJbhcaQx1z34pu5UsxaUeu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RL16YaDLe+bM2PUmzeZ3PBJo2E8MAsPYrapToBf6vm8r+OjtMa34TeWr7AAi/EDxA
         fBsnHjUtWgxrp1WotDPAAjG4Cq9VLpcuHrXpGwlFi/APHSlRRrAO9XfBH5Ip7NqIGu
         ophf2kM+OmhnSGZ8qbpnzGMEM3iTiai5WFVmMSRnKDZ13UEjXqFk9k6+84gjZWsfln
         EUfGgrAqoUJKcx06wBGGxfNYlYjglsP+hTE1r5n9tTvYio1XXznr4vI1ooBv57IBvj
         vusvut88DiBZtK3mUfq8If8IkxC9m36/Q6U4jbz55EHdSS0dIX84dAV0ImLADivR6w
         9Q/Gth+t5Dhpw==
Date:   Tue, 8 Mar 2022 22:03:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v2] net: dsa: tag_rtl8_4: fix typo in modalias
 name
Message-ID: <20220308220329.554a3d0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309022757.9539-1-luizluca@gmail.com>
References: <20220309022757.9539-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Mar 2022 23:27:58 -0300 Luiz Angelo Daros de Luca wrote:
> DSA_TAG_PROTO_RTL8_4L is not defined. It should be
> DSA_TAG_PROTO_RTL8_4T.
> 
> Fixes: 7c33ef0ad83d ("net: dsa: tag_rtl8_4: add rtl8_4t trailing variant")

This SHA does not exist upstream.
