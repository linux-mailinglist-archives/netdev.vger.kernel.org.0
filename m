Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC74610669
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 01:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiJ0X3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 19:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiJ0X3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 19:29:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BA8A3B5C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 16:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NAN/ivLyz5IT7VXzPk/XPxFEo4/LP85GRXT71OCXeHw=; b=06daRgMEWTRtmyiDR1Wk+jiv2a
        1oKiNGh/UDfo6+ohotIG9OJ5HG+BZHZznJPqAycg3ck/s3yWICkzB7NpS3/84jxzvPDRxXj5ggf10
        vli5g5qxei3TSGNzQOsIt6rv6wZMPDjH965GWbNFXjz2DOMSl3Rl+4/SUKEou4rc7NcU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooCJB-000lF8-MM; Fri, 28 Oct 2022 01:29:09 +0200
Date:   Fri, 28 Oct 2022 01:29:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v1 4/4] mlxbf_gige: add BlueField-3 ethtool_ops
Message-ID: <Y1sURRYUzwDCbpjX@lunn.ch>
References: <20221027220013.24276-1-davthompson@nvidia.com>
 <20221027220013.24276-5-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027220013.24276-5-davthompson@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 06:00:13PM -0400, David Thompson wrote:
> This patch adds logic to support initialization of a
> BlueField-3 specific "ethtool_ops" data structure. The
> BlueField-3 data structure supports the "set_link_ksettings"
> callback, while the BlueField-2 data structure does not.

Why?

I _think_, so long as the supported values have been set correctly in
the phydev, set_link_ksettings should not be able to set anything for
BF2 which it cannot support.

    Andrew
