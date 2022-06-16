Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD454D8C2
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 05:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355476AbiFPDFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 23:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357429AbiFPDFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 23:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25D65A145;
        Wed, 15 Jun 2022 20:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D3B561408;
        Thu, 16 Jun 2022 03:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94177C3411A;
        Thu, 16 Jun 2022 03:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655348746;
        bh=eKMfwTswQ0hHiZwig2FzE3cqMfqaHWQ47VvrfOtn69Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VBis4LHJiUdLqv8ckZc82+pkTeCKeOfmmfcpWrguIjrUIs7IavQEIn8zUT/+RYDFt
         MvnJAEA4tTU1uArvetRT4CcbI88SmB0hR0Ko/yMJUhVea3l6qKIqklFDROgaGQrp0V
         1JC1cbIIa2xckcS4TFVZAOpDc6JruTDghZ95cnSVlEjMi7+ID/YBku3Jpf9+LYLwXO
         VuA9dPXkwrqEqx79nImTYlwRf0dkic2GlewTvC+h/AWo8c+yhmkuN0dxogl2IQvtCN
         7dLrWdadDa3PwEfdaKt7dHpM1BTFjvkW227RZSsSwKsrth7lL1J0tt10aSkaqJAfis
         GrQ9/VScI3s9A==
Date:   Wed, 15 Jun 2022 20:05:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V1 3/5] net: lan743x: Add support to SGMII
 block access functions
Message-ID: <20220615200544.10399227@kernel.org>
In-Reply-To: <20220615103237.3331-4-Raju.Lakkaraju@microchip.com>
References: <20220615103237.3331-1-Raju.Lakkaraju@microchip.com>
        <20220615103237.3331-4-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 16:02:35 +0530 Raju Lakkaraju wrote:
> Subject: [PATCH net-next V1 3/5] net: lan743x: Add support to SGMII block access functions
> 
> Add SGMII access read and write functions

Unfortunately you can't define functions and use them in later patches.
It will break build during bisection because of -Wunused-function
now that the kernel defaults to -Werror. I say just squash this into
the next patch, it's not that big.
