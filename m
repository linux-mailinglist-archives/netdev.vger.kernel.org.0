Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B72509F92
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384044AbiDUM1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384099AbiDUM1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:27:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8372F3A2
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 05:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FtD2llsx0L5b7cFmHRpQebTaKlsKpRshf4BAZ6P66G4=; b=JYcuIzyybTpjFX+Z+sXbBT60nW
        g4qP+65Q1g4SQZbm+eJOQKzYXZl1lVuYSd9sL2JPOcikqBYXt5Qvhr/9/V/z8ocFGHACgvq5j6My8
        LM77wSh45I5Afc5P6cUDSc1U3czFw9HbTz7zVrZohaDl1gqIYWQB8U27n8eS4So1eaDI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhVrS-00GnbH-Pm; Thu, 21 Apr 2022 14:24:38 +0200
Date:   Thu, 21 Apr 2022 14:24:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: net: adin: document phy clock output
 properties
Message-ID: <YmFNBlCieFmkFJo4@lunn.ch>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
 <20220419102709.26432-2-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419102709.26432-2-josua@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:27:07PM +0300, Josua Mayer wrote:
> The ADIN1300 supports generating certain clocks on its GP_CLK pin, as
> well as providing the reference clock on CLK25_REF.
> 
> Add DT properties to configure both pins.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
