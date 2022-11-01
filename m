Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44156615644
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 00:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiKAXtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 19:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKAXtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 19:49:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44CFD2A;
        Tue,  1 Nov 2022 16:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NaB2XkMs4qlkVBTINnHUBg093857r9cigDq/0nKCQwE=; b=oGX3y2uTh5HmRewiPjwIdxx6f8
        fbV1OJ52Q1j+FQwV0oZe+nPwl1o76DvkQuJ5UzFtue/ER13c/oi+L/fcwG+9D7ZVb5BgkM8ScDYKa
        YEI/SJVd8kehgnFpO3XAP8vFbjj3JZPOcxcE/QJSH/Os9GHsmSnHa2FWUzovSg/afh5M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oq10m-0019O4-NF; Wed, 02 Nov 2022 00:49:40 +0100
Date:   Wed, 2 Nov 2022 00:49:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, greentime.hu@sifive.com
Subject: Re: [PATCH v2 net-next 1/3] net: axienet: Unexport and remove unused
 mdio functions
Message-ID: <Y2GwlDxu882k74gf@lunn.ch>
References: <20221101010146.900008-1-andy.chiu@sifive.com>
 <20221101010146.900008-2-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101010146.900008-2-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 09:01:45AM +0800, Andy Chiu wrote:
> Both axienet_mdio_enable functions are no longer used in
> xilinx_axienet_main.c due to 253761a0e61b7. And axienet_mdio_disable is
> not even used in the mdio.c. So unexport and remove them.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
