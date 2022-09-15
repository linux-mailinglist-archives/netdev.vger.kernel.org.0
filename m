Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A3F5B9ADD
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 14:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIOMee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 08:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIOMed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 08:34:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F221023
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 05:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/V0XRnA8Cd3ZiN6j0cc8Y3tJWfdtmdvU5BxGDJkwKms=; b=dmjL53tDw9t+7PXAjsnqrB78wW
        1m0tHQzBYAVMrHLaLXm1mUuKGpMiV7H+qH3yP2vt30p0xgK174dPPUkkICZ5OUt1Nny6GmnQxq62Y
        sEO42Tr8ax/sDja2dhYiXdZ+dv8sC7DnO2JZ2DCmdOlRpYI/AoK9mGl76TIG7pl4tBNE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oYo4Z-00Goyi-AD; Thu, 15 Sep 2022 14:34:27 +0200
Date:   Thu, 15 Sep 2022 14:34:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH -next 1/3] net: mdio: mux-meson-g12a: Switch to use
 dev_err_probe() helper
Message-ID: <YyMb06qzcQFY9SWP@lunn.ch>
References: <20220915065043.665138-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915065043.665138-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 02:50:41PM +0800, Yang Yingliang wrote:
> dev_err() can be replace with dev_err_probe() which will check if error
> code is -EPROBE_DEFER.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
