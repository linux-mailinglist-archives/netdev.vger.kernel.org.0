Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07ED95F3AAA
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJDAb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiJDAbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DABE27CEE;
        Mon,  3 Oct 2022 17:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA2861155;
        Tue,  4 Oct 2022 00:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1F3C433D6;
        Tue,  4 Oct 2022 00:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664843476;
        bh=VU3D3Y/JxVxGyNnpj6KIqCOTo2oWJQhVtfAInbuEJlc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dISLqxPYRi1VATu0uwIsKBzyZYYOuWg2h6YDRXLCjfqk6G9oNHPGutfT+Sdf25Udg
         xj6ubyGDoO10yqoPmlUvHqbCYO2UVM5wtVJ92BcTqb4jNjbmNfnUhv0TQPpNCDz4bm
         q6fBsgrP/MghyBb/rxj3IZvrAdcu7vQYkgiUCxQeQFLGgFuZeHAOwuSH7md8V/qVG2
         MvLasldZoiH0VUEsHobJcaMVPwXYy+Yb6icCVo+m2fmxw3a2EV3EZbpujqpwuqpBZm
         68NgpeOBbhxPtOXoXD9S7xR0o37Kx2CoCEICKjTGSUmH8OwSHjc0gVozWWypPbm07H
         eAG4dIAgt5ezg==
Date:   Mon, 3 Oct 2022 17:31:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next V3] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221003173114.03b49d92@kernel.org>
In-Reply-To: <20221003103821.4356-1-Raju.Lakkaraju@microchip.com>
References: <20221003103821.4356-1-Raju.Lakkaraju@microchip.com>
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

On Mon, 3 Oct 2022 16:08:21 +0530 Raju Lakkaraju wrote:
> Add support to SGMII register dump

net-next is closed, please repost once Linus tags 6.1-rc1

http://vger.kernel.org/~davem/net-next.html
