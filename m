Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8DD67B38B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbjAYNjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbjAYNj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:39:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B81356EE3
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 05:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ocX1zgrok/klJTIJ8/NOXVr7g8xBepvgYUvc4xVF4qI=; b=HRheRYHlR3TJ3+jV2xxg5xvnYo
        y+UeS789grM75QO8Mu6D8UCiBqM13SMXrIIcYW0WNYU3SEOcpH8N3Rw5KDzE1q8qshQ0dvWvsR2ur
        RCtojcN39j93vJbdSsI1O5MvgMP/qoJhFSNdU8bHtFX7GR08kErUegmfXTFzewjFb0k8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pKfzc-0038sL-D4; Wed, 25 Jan 2023 14:39:12 +0100
Date:   Wed, 25 Jan 2023 14:39:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, Shyam-sundar.S-k@amd.com
Subject: Re: [PATCH net-next 1/2] amd-xgbe: add 2.5GbE support to 10G BaseT
 mode
Message-ID: <Y9ExAOZ5q6rrZoLc@lunn.ch>
References: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
 <20230125072529.2222420-2-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125072529.2222420-2-Raju.Rangoju@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 12:55:28PM +0530, Raju Rangoju wrote:
> Add support to the driver to fully recognize and enable 2.5GbE speed in
> 10GBaseT mode.

Can the hardware also do 5G? It is reasonably common for a 10GBASE-T
PHY which can do 2.5GBASE-T can also do 5GBASE-T?

    Andrew
