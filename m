Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE12F6F1F15
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346480AbjD1UDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjD1UDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:03:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0C3213C;
        Fri, 28 Apr 2023 13:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Wv+EBTjiTggM86bRrEIYAUqkBhkR33itbQQzGQoM17k=; b=hZ2Kfoj4ys+sxny036+dZkKWNy
        SmnqrdX175aeGLMe8tzUt+ZyLiy4d2tpoivxvHPMCFSUbp9u7leuv9TdM1Hf2yoBSOUjneUFamJen
        bGr+SK2rRHQClr6FzLbhh9rJe4U+ZKWiTCgUh6cBKGsFD1G3dbYsJindkw+ZNGT+RhE8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1psUIx-00BSGv-2J; Fri, 28 Apr 2023 22:02:55 +0200
Date:   Fri, 28 Apr 2023 22:02:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v3 2/3] r8152: fix the poor throughput for 2.5G
 devices
Message-ID: <fab5674d-377e-4885-ac65-bc8133e15f60@lunn.ch>
References: <20230428085331.34550-409-nic_swsd@realtek.com>
 <20230428085331.34550-411-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428085331.34550-411-nic_swsd@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 04:53:30PM +0800, Hayes Wang wrote:
> Fix the poor throughput for 2.5G devices, when changing the speed from
> auto mode to force mode. This patch is used to notify the MAC when the
> mode is changed.
> 
> Fixes: 195aae321c82 ("r8152: support new chips")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
