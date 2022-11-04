Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B2C619BC9
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiKDPe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiKDPew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:34:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1A31C924;
        Fri,  4 Nov 2022 08:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=J6P5thdq0LgZlSUySZdbISDq4FEs02Q70Gfyp54pM+0=; b=LagpLcn0jx9GmNKSDk3Eq/12Yo
        4zL1uyHMKGaSsk2NNoBr0vphk50RKN3t+Kd1cFz9SYm0mO9HaxmEKlO0eN+w8r/o12pbIEPG8VqDy
        WAQ1II/5iqWPi5ey0LmJp7bpsInMuUBxEyc6iw138ZVvm4TCJk1gFXcg2DLH3XyR5Pcw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqyiK-001RP7-Jf; Fri, 04 Nov 2022 16:34:36 +0100
Date:   Fri, 4 Nov 2022 16:34:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sriranjani P <sriranjani.p@samsung.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Jayati Sahu <jayati.sahu@samsung.com>
Subject: Re: [PATCH 4/4] arm64: dts: fsd: Add Ethernet support for PERIC
 Block of FSD SoC
Message-ID: <Y2UxDH/LdTXmm4HC@lunn.ch>
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
 <CGME20221104115909epcas5p25a8a564cd18910ec2368341855c1a6a2@epcas5p2.samsung.com>
 <20221104120517.77980-5-sriranjani.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104120517.77980-5-sriranjani.p@samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +&ethernet_1 {
> +	status = "okay";
> +
> +	fixed-link {
> +		speed=<1000>;
> +		full-duplex;
> +	};

That is pretty unusual. Fixed link is generally used when connected to
an Ethernet switch. Is that the case here?

   Andrew
