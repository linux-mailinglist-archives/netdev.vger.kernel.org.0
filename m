Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730562A2D3E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 15:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgKBOqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 09:46:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58696 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKBOqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 09:46:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZb5y-004pRV-Dp; Mon, 02 Nov 2020 15:46:06 +0100
Date:   Mon, 2 Nov 2020 15:46:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL Ether
 Group driver
Message-ID: <20201102144606.GI1042051@lunn.ch>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
 <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
 <20201023153731.GC718124@lunn.ch>
 <20201026085246.GC25281@yilunxu-OptiPlex-7050>
 <20201026130001.GC836546@lunn.ch>
 <20201026173803.GA10743@yilunxu-OptiPlex-7050>
 <20201026191400.GO752111@lunn.ch>
 <20201102023809.GA10673@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102023809.GA10673@yilunxu-OptiPlex-7050>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I did some investigation and now I have some details.
> The term 'PHY' described in Ether Group Spec should be the PCS + PMA, a figure
> below for one configuration:
> 
>  +------------------------+          +-----------------+
>  | Host Side Ether Group  |          |      XL710      |
>  |                        |          |                 |
>  | +--------------------+ |          |                 |
>  | | 40G Ether IP       | |          |                 |
>  | |                    | |          |                 |
>  | |       +---------+  | |  XLAUI   |                 |
>  | | MAC - |PCS - PMA|  | |----------| PMA - PCS - MAC |
>  | |       +---------+  | |          |                 |
>  +-+--------------------+-+          +-----------------+

Thanks, that makes a lot more sense.

	Andrew
