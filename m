Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3F55690A1
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiGFRZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 13:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiGFRZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 13:25:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4222A73B
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 10:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z+1pGsJypSzlYfdiQ7I1Jak4trYYHLlJgWuUDfysIx0=; b=QIKKEte6oalePMW5SluDLztdyZ
        Y+P/qwNo4eJ9Law3GcfwNddlQrfCcc/KFe4+KssqBMUeHIJup1YGw27NgKskyDVckm+H/lEfQ9wC8
        u7tVHMT+soYMAtb9FbXke/yUQaTXnkmds3RA7edrujjSdov79OBzNjF0bpEjecOUq16M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o98lp-009VId-1D; Wed, 06 Jul 2022 19:25:01 +0200
Date:   Wed, 6 Jul 2022 19:25:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 1/2] sfc: Add EF100 BAR config support
Message-ID: <YsXFbRF/cw4sH0RZ@lunn.ch>
References: <165712441387.6549.4915238154843073311.stgit@palantir17.mph.net>
 <165712447305.6549.5015491740374054340.stgit@palantir17.mph.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165712447305.6549.5015491740374054340.stgit@palantir17.mph.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 05:21:13PM +0100, Martin Habets wrote:
> Provide a "bar_config" file in the sysfs directory of the PCI device.
> This can be used to switch the PCI BAR layout to/from vDPA mode.

You probably should also Cc: the PCI maintainers.

    Andrew
