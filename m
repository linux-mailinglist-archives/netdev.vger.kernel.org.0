Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A295E54EA16
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378236AbiFPTZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377879AbiFPTZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:25:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7969E56402
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 12:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R8SlYucgUDsqtuRQI5F9pNj5Fcdyx1zhPFNfPvE2SlE=; b=55rE6PJGyUFiJrkVo7+h1qhZh1
        n1pkjKGGQMm1ayMRbjV7ITrBDbJO0/OmJCzRp62LcpHfumK/I3nqR0f7OgpeDmwGg1OFpddiCbPfZ
        NVp5X1TsqMeG0ZNMbSYOWTnMhNxix6Wj/2tS10WOjP4MoL8Og5tqiQ+829TGh2FL/bBQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1v6t-007EEp-Gb; Thu, 16 Jun 2022 21:24:55 +0200
Date:   Thu, 16 Jun 2022 21:24:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next] nfp: add support for .get_pauseparam()
Message-ID: <YquDh/EWN9Lxo+vV@lunn.ch>
References: <20220616133358.135305-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616133358.135305-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 03:33:57PM +0200, Simon Horman wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Show correct pause frame parameters for nfp. These parameters cannot
> be configured, so .set_pauseparam() is not implemented. With this
> change:
> 
>  #ethtool --show-pause enp1s0np0
>  Pause parameters for enp1s0np0:
>  Autonegotiate:  off
>  RX:             on
>  TX:             on
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
