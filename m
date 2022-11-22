Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA286331A1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKVAwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKVAwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:52:00 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857318FFAF
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EbaYkZg04b/Mi9SWCChRsrx0tjOrY+89XB1W2o2MYxM=; b=rtPsNCtxDIFJIexCOAihJpYB78
        biDtGM5UMAVa8wowGYaOi6trOnWCAjX1jJ1gzktrXXGlE79sttpc7WGSF2Em3eonKQMZnq9dtL7Wb
        eO3C2jxlLp2uvTIQkNAvC0E3c+/UziqKsR1BXFhcwyAjyFq0A2WwjTVd1FeRNgPY/dZs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxHVn-0034Hb-9A; Tue, 22 Nov 2022 01:51:43 +0100
Date:   Tue, 22 Nov 2022 01:51:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next] nfp: ethtool: support reporting link modes
Message-ID: <Y3wdH/RBQ/gVdq1q@lunn.ch>
References: <20221121112045.862295-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121112045.862295-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 12:20:45PM +0100, Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Add support for reporting link modes,
> including `Supported link modes` and `Advertised link modes`,
> via ethtool $DEV.

Does the firmware support returning the link partners advertised link
modes? Knowing what the other end is advertising is often the key to
figuring out why a link has ended up on a specific link mode.

	 Andrew
