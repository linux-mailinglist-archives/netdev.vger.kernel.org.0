Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A07C25A12B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIAWIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:08:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36898 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgIAWIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 18:08:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDERq-00Cow1-EX; Wed, 02 Sep 2020 00:08:14 +0200
Date:   Wed, 2 Sep 2020 00:08:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 3/9] gve: Use dev_info/err instead of
 netif_info/err.
Message-ID: <20200901220814.GD3050651@lunn.ch>
References: <20200901215149.2685117-1-awogbemila@google.com>
 <20200901215149.2685117-4-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901215149.2685117-4-awogbemila@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1133,7 +1133,9 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		goto abort_with_db_bar;
>  	}
>  	SET_NETDEV_DEV(dev, &pdev->dev);
> +
>  	pci_set_drvdata(pdev, dev);
> +
>  	dev->ethtool_ops = &gve_ethtool_ops;
>  	dev->netdev_ops = &gve_netdev_ops;
>  	/* advertise features */
> @@ -1160,6 +1162,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	priv->state_flags = 0x0;
>  
>  	gve_set_probe_in_progress(priv);
> +
>  	priv->gve_wq = alloc_ordered_workqueue("gve", 0);
>  	if (!priv->gve_wq) {
>  		dev_err(&pdev->dev, "Could not allocate workqueue");
> @@ -1181,6 +1184,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
>  	gve_clear_probe_in_progress(priv);
>  	queue_work(priv->gve_wq, &priv->service_task);
> +
>  	return 0;
>  
>  abort_with_wq:

No white space changes please. If you want these, put them into a
patch of there own.

      Andrew
