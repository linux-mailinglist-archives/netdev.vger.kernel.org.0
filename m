Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421CD615699
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 01:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiKBAkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 20:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKBAkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 20:40:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94D813F0F;
        Tue,  1 Nov 2022 17:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z0k3XAWcZLVGNtAnxopPG8s9UHhlO5J1q7MWdt7TbNM=; b=JPiyAlAf+ZsN2+rTFY3C5X0fdN
        sXvSCrlZdOYpHiJEiooSdLC6YZWxDmvq5gx0mljnampvHyLGNiw19PqN58UvOogp6n9AMX5USpSHK
        bdngK9PC/wk0CMkZow4UTGqDOaCLIx0CvNTf0MAn67wRDa1GHlzkA6ohzODm7jc2i7Ew=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oq1nb-0019Vm-6B; Wed, 02 Nov 2022 01:40:07 +0100
Date:   Wed, 2 Nov 2022 01:40:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, greentime.hu@sifive.com
Subject: Re: [PATCH v2 net-next 3/3] dt-bindings: describe the support of
 "clock-frequency" in mdio
Message-ID: <Y2G8Z/fCQC+snBIP@lunn.ch>
References: <20221101010548.900471-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101010548.900471-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 09:05:48AM +0800, Andy Chiu wrote:
> mdio bus frequency can be configured at boottime by a property in DT
> now, so add a description to it.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
