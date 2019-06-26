Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A33B571D8
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFZTfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:35:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZTfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8xreKcuSG6RwApsmQZaB+CKTRYNHwVm//A79jxsxhB8=; b=iAxp7dHZ5yLOEmGzxz1MHmQQFI
        5Oo4szlZZXvHPzFWv338Ppupv3pnCS6G9vOqHrRsZTXDHuX4NCnvrWimlGnzff0ES4NWEx3iM4npw
        nvMBezq+rLS/GYT4lFlafrP52+5UbD9Ae+vcfytPGXHTbTy0VCmyZZle765NZh594J/I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgDhF-0003hl-QZ; Wed, 26 Jun 2019 21:35:09 +0200
Date:   Wed, 26 Jun 2019 21:35:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 1/4] gve: Add basic driver framework for Compute
 Engine Virtual NIC
Message-ID: <20190626193509.GE27733@lunn.ch>
References: <20190626185251.205687-1-csully@google.com>
 <20190626185251.205687-2-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-2-csully@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 11:52:48AM -0700, Catherine Sullivan wrote:
> Add a driver framework for the Compute Engine Virtual NIC that will be
> available in the future.
> 
> +static int __init gvnic_init_module(void)
> +{
> +	return pci_register_driver(&gvnic_driver);
> +}
> +
> +static void __exit gvnic_exit_module(void)
> +{
> +	pci_unregister_driver(&gvnic_driver);
> +}
> +
> +module_init(gvnic_init_module);
> +module_exit(gvnic_exit_module);

module_pci_driver()?

	Andrew
