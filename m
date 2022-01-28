Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E64A0001
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 19:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242827AbiA1STh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 13:19:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233898AbiA1STf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 13:19:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JebKbbPd+zMYlJE7viIQgYSD3Jw7bxYDJhFYhebgro0=; b=qjewVYi6+Z6exyHxu2FbESfnkI
        kn5oisyEGyIStU3RoQG5GB1JbmV0wuxm7uaxKtF0F2Gn6sKatL1P0MfGkFk+awPJW3FBTFY1I4a/b
        xA9CEv76cRJUXsOUI2jqOcDIFoNQ4Azd+99ErXA1dWrx4Js4/rCu2AxJcEyLzesAwJoQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nDVqE-003DBo-OL; Fri, 28 Jan 2022 19:19:22 +0100
Date:   Fri, 28 Jan 2022 19:19:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     cgel.zte@gmail.com
Cc:     jiri@resnulli.us, ivecera@redhat.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net/switchdev: use struct_size over open coded arithmetic
Message-ID: <YfQzqqiw7O/iKUD0@lunn.ch>
References: <20220128075729.1211352-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128075729.1211352-1-chi.minghao@zte.com.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 07:57:29AM +0000, cgel.zte@gmail.com wrote:
> From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>
> 
> Replace zero-length array with flexible-array member and make use
> of the struct_size() helper in kmalloc(). For example:
> 
> struct switchdev_deferred_item {
> 	...
> 	unsigned long data[];
> };
> 
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>

Please could you train your bot to zealously compile test patches
before submitting them?

At the moment you seem to have more patches which fail to build then
actually build. So you are wasting peoples time, which is not going to
make Maintainers happy.

       Andrew
