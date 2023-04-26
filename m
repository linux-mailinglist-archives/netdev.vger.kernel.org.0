Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AC86EF5A9
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241036AbjDZNmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240734AbjDZNme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:42:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5394C1E;
        Wed, 26 Apr 2023 06:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=seuteR+t44/6GkQ0WofgA85I/KhddcxEUe2qcp/oMTc=; b=NS3gHvSgRa74knRtLYc6Gd9hwG
        GQV5CSgmoWtwrdIuMQRX+suM8tuUNUnncKpADrW2X2RDZCtl+spGfhaRb/WgUMnLBDOeIx5COMVXf
        mCBeq3P/+8uRWh5ekS6dy/vueCb94C1YanxA93pYloINGRr6oe09SS6W361DfjWHuwsc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prfPb-00BHBg-Sv; Wed, 26 Apr 2023 15:42:23 +0200
Date:   Wed, 26 Apr 2023 15:42:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     robh+dt@kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, vladimir.oltean@nxp.com,
        wsa+renesas@sang-engineering.com,
        krzysztof.kozlowski+dt@linaro.org, simon.horman@corigine.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        michal.simek@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: mscc: Add RGMII RX and TX
 delay tuning
Message-ID: <ea70aaab-d634-4fee-8355-d4208fd44527@lunn.ch>
References: <20230426104313.28950-1-harini.katakam@amd.com>
 <20230426104313.28950-3-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426104313.28950-3-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 04:13:12PM +0530, Harini Katakam wrote:
> From: Harini Katakam <harini.katakam@xilinx.com>
> 
> Add optional properties to tune RGMII RX and TX delay. The current
> default value in the Linux driver, when the phy-mode is rgmii-id,
> is 2ns for both. These properties take priority if specified.
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Your signed-off-by needs to come last, since you are submitting it.

But as Vladimir pointed out, you don't need to add anything.

You could however convert to yaml, if you want.

    Andrew
