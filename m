Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960554CEC07
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 16:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiCFPQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 10:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiCFPQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 10:16:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D2E3FBD3;
        Sun,  6 Mar 2022 07:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SjmhTAZ5MddX6Jnp7nERsxNAziDtI725HDbO/okkTmI=; b=peROvnfp4rQKRplUsV7HF4sWz5
        6FdrREDyFJpwcWC+ZCCyRJsWXF7rp+mH+Qvxu8CtdsucSKa4dcXr9A17eD6KTWtoQzgQtMzhtZYeB
        jjJ8OlYQ7ZCxknDJ2HUYknnQD42eS2Tfh5N7fCfr3TDn3u1LghNl6Qu7AnxJJ7esrnPs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQsbH-009V6m-06; Sun, 06 Mar 2022 16:15:11 +0100
Date:   Sun, 6 Mar 2022 16:15:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: cxgb3: Fix an error code when probing the driver
Message-ID: <YiTP/t65qhhBaKvf@lunn.ch>
References: <1646490284-22791-1-git-send-email-zheyuma97@gmail.com>
 <1646546192-32737-1-git-send-email-zheyuma97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1646546192-32737-1-git-send-email-zheyuma97@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 05:56:32AM +0000, Zheyu Ma wrote:
> During the process of driver probing, probe function should return < 0
> for failure, otherwise kernel will treat value >= 0 as success.
> 
> Therefore, the driver should set 'err' to -ENODEV when
> 'adapter->registered_device_map' is NULL. Otherwise kernel will assume
> that the driver has been successfully probed and will cause unexpected
> errors.
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
