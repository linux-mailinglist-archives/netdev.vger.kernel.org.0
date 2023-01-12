Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFB36686BD
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbjALWUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjALWUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:20:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D291107
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/x2GkU8jYHDp0iJ5e4QM6vR/StWgs2MglF1v9rY3BMU=; b=Upi3iRpgIfTXbvnArGdrGl+GKG
        J+WczYAna2mHSSN+VJwwQfs8KnENw3vx14+4sBvASjBglyajMDes/xOb/dBN6untQMRfifZjT3uas
        JOXoC5UDpDf7EQoe2nU77JNN6jKFfRGXAUzlkDRI3krKIubzxFxAXnXrgBGA+EL0tTCs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pG5nH-001vkA-HZ; Thu, 12 Jan 2023 23:11:31 +0100
Date:   Thu, 12 Jan 2023 23:11:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, chenhao288@hisilicon.com,
        huangguangbin2@huawei.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v3 3/4] mlxbf_gige: add "set_link_ksettings"
 ethtool callback
Message-ID: <Y8CFk8yrEI3DVlO0@lunn.ch>
References: <20230112202609.21331-1-davthompson@nvidia.com>
 <20230112202609.21331-4-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112202609.21331-4-davthompson@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 03:26:08PM -0500, David Thompson wrote:
> This patch extends the "ethtool_ops" data structure to
> include the "set_link_ksettings" callback. This change
> enables configuration of the various interface speeds
> that the BlueField-3 supports (10Mbps, 100Mbps, and 1Gbps).
> 
> Signed-off-by: David Thompson <davthompson@nvidia.com>
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
