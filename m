Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AB7514008
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbiD2BLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiD2BLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:11:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E8D35843;
        Thu, 28 Apr 2022 18:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UJSSqjTq6rR+oz33lKK9+qYKGeOvFGrRHEb492CpU6w=; b=Abb3VEdYgLR65x5qpNT0MqgWZZ
        y85jpY1gHTTdH5zfFEHnz1sh8Z6JjCDRHkumbIF2jOdUqXaF9rgnlNyoH4a7eUohOLGki1uVL3X6U
        Da/R4swdZenjsBCaGztpxXtO9XS+XwdtviaHd/+xdEgoroN4MNA2J1ou25oS9Rna8UMw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkF6x-000P1H-M3; Fri, 29 Apr 2022 03:07:55 +0200
Date:   Fri, 29 Apr 2022 03:07:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
Subject: Re: [PATCH 0/2] emaclite: improve error handling and minor cleanup
Message-ID: <Yms6a3GODF6Lmf4l@lunn.ch>
References: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 09:57:56PM +0530, Radhey Shyam Pandey wrote:
> It patchset does error handling for of_address_to_resource() and also
> removes "Don't advertise 1000BASE-T" and auto negotiation.
> 
> TREE: net-next

Please read the netdev FAQ. It tells you how to specify the tree a
patchset should be applied to.

	 Andrew


