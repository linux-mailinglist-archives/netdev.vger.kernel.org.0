Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA9262431E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiKJNYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiKJNYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:24:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEA86A69F
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 05:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e1f5N8gRSqfzxUpxVA2y18vSJE/+F6MBjUppYvek5vQ=; b=Mzz/oPuTE09WjY+WXKN3jJuzr0
        J9bI9aRb02xhKkmSh/RwG4qj2yfYorD/199a+3cWBzZaRrrpYFhFhXfQkM3cEWkmNaXsaG/XicMSN
        v/jUsWDMPYSeyOkyImXnaQzYR5GvpWxMcR9+HSVQ4/Gcw4rZQBEahXKWelYD5EE+dc34=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ot7X9-00229v-DV; Thu, 10 Nov 2022 14:23:55 +0100
Date:   Thu, 10 Nov 2022 14:23:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, chenhao288@hisilicon.com,
        huangguangbin2@huawei.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 2/4] mlxbf_gige: support 10M/100M/1G speeds
 on BlueField-3
Message-ID: <Y2z7a8/cMls/EVuC@lunn.ch>
References: <20221109224752.17664-1-davthompson@nvidia.com>
 <20221109224752.17664-3-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109224752.17664-3-davthompson@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 05:47:50PM -0500, David Thompson wrote:
> The BlueField-3 OOB interface supports 10Mbps, 100Mbps, and 1Gbps speeds.
> The external PHY is responsible for autonegotiating the speed with the
> link partner. Once the autonegotiation is done, the BlueField PLU needs
> to be configured accordingly.
> 
> This patch does two things:
> 1) Initialize the advertised control flow/duplex/speed in the probe
>    based on the BlueField SoC generation (2 or 3)
> 2) Adjust the PLU speed config in the PHY interrupt handler
> 
> Signed-off-by: David Thompson <davthompson@nvidia.com>
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
