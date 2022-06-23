Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16728557ED9
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 17:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiFWPrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 11:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiFWPrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 11:47:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F332C43ACD;
        Thu, 23 Jun 2022 08:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BAB3B82452;
        Thu, 23 Jun 2022 15:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F24C3411D;
        Thu, 23 Jun 2022 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655999226;
        bh=Gv4hBRcDLH8HNkMWXfGARhQzj8Khtn6AZ3B44+tKvzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zl7PrQ2MFJwpvCg8MDZb/czvZhztaNvMMFKNnm25rAE1uX3ZdpUYuLXlmxL0LIVBu
         unJyUZzfooUm3CVhZqmY7dvQ9shxi1XBV3dKye7jTsiHQcOfVGNFfjVdPGAJOiGX63
         RHZyq7eIHOIBdzXO/YXvYvQh5cwqiaexGvY4+oT8=
Date:   Thu, 23 Jun 2022 17:47:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>
Subject: Re: request to stable branch [PATCH] net: mana: Add handling of
 CQE_RX_TRUNCATED
Message-ID: <YrSK9+A4g66uqt77@kroah.com>
References: <DM5PR21MB1749E3A19B16CF6AED1A365DCAB39@DM5PR21MB1749.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR21MB1749E3A19B16CF6AED1A365DCAB39@DM5PR21MB1749.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 09:52:19PM +0000, Haiyang Zhang wrote:
> To stable tree maintainers:
> 
> Patch: net: mana: Add handling of CQE_RX_TRUNCATED
> 
> commit e4b7621982d29f26ff4d39af389e5e675a4ffed4 upstream
> 
> Why you think it should be applied:
> 	This patch fixes the handling of CQE_RX_TRUNCATED case, otherwise someone can easily attack it by sending a jumbo packet and cause the driver misbehave.
> 
> What kernel version you wish it to be applied to: 
> 	5.15.x

Now queued up, thanks.

greg k-h
