Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E466DE5D1
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjDKUh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjDKUh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:37:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FF326A6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RCTZF5FWPRzvD/uqnnvd6vOIFewjjAl/vS6kktRJtT0=; b=pLH6SFOs7xrEE6lnVq6Tl4DTjb
        od98PUb8G6PCZvLXSsP2CvDvQTHZgH4JoOOrux/nkTM1WNq0jd31kUR4NzECIBBDofZlnze3Wq0Ah
        BEn0bPMkAPaV/hqaoN1+2uxSSIw8EpoANVuD1VvZr7CixTOMETflCXrzHh0eEsET4MN4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmKjv-00A1m5-Qq; Tue, 11 Apr 2023 22:37:19 +0200
Date:   Tue, 11 Apr 2023 22:37:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH v2 net-next 1/7] net: move ethtool-related netdev
 state into its own struct
Message-ID: <30747bee-35f9-420b-8962-a82899d46ee9@lunn.ch>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <7437d841fe416119199104ec334bf07cd285c9b5.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7437d841fe416119199104ec334bf07cd285c9b5.1681236653.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 07:26:09PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> net_dev->ethtool is a pointer to new struct ethtool_netdev_state, which
>  currently contains only the wol_enabled field.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
