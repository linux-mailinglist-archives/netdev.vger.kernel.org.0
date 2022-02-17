Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18E44BA69E
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiBQRCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:02:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiBQRCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:02:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D7F1C5590
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 043C1B82373
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 17:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81675C340E8;
        Thu, 17 Feb 2022 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645117323;
        bh=dlbpyGajG5aad0n37q+411sqPalUafELSoj/sj5LF7Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RIFqUlpVr22+l3cVzoceR4Vr3mcR1J3J67HyAhgTYrRQgdSCRyG7opPjDAXNMjwVA
         TwXQ7Ffv101xvCAd9XalZ42ABOZHNkkfPyKCG5iIefs9Ix528o/QrDJ/Q46dhj1nLf
         O169waJWFUFk91ehgd6mPPkXoJH6Xmbfuoup4mKDVBS/WEQ3stkupNOqCdSioKOHlH
         6Me5g6gkSjMuPCdcRIMHAfkJ5xSMXXKNMvMNfvFOtZCTY032l5g4HQX6gm0zdHkR9v
         afCeNcIEmoyrIXyr64K1QTKrfSjc9vuv0Lbe/6xaI382qFmcw8QK2QcXjReXWpXVuw
         1heJe8oEy8ZhQ==
Date:   Thu, 17 Feb 2022 09:02:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>, <hkelam@marvell.com>,
        <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: Re: [net-next PATCH 1/2] ethtool: add support to set/get completion
 event size
Message-ID: <20220217090202.3426cbac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1645109346-27600-2-git-send-email-sbhatta@marvell.com>
References: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
        <1645109346-27600-2-git-send-email-sbhatta@marvell.com>
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

On Thu, 17 Feb 2022 20:19:05 +0530 Subbaraya Sundeep wrote:
> Add support to set completion event size via ethtool -G
> parameter and get it via ethtool -g parameter.

> @@ -83,6 +85,7 @@ struct kernel_ethtool_ringparam {
>   */
>  enum ethtool_supported_ring_param {
>  	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
> +	ETHTOOL_RING_USE_CE_SIZE    = BIT(1),
>  };

include/linux/ethtool.h:90: warning: Enum value 'ETHTOOL_RING_USE_CE_SIZE' not described in enum 'ethtool_supported_ring_param'
