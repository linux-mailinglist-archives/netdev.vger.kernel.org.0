Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04579571EB
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFZTmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:42:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZTmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:42:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=m1JcWTDKC4jW46W5VgSO5/Fpnw8QC+lO8gBFWRQFS+g=; b=w8szMH5w5ixh8MubVN5vsHseJ0
        ebP7zsuIDSJYf5fF9syBL7Kn8n0+kMwV2g692CJXVv9DpKP9ZHXZqrAmK3W1hFeKun79U1iRIFIXT
        f6yQTF0rWu3FaXWSaabxqPjgfFXNTKgtBeCihCpjaCz498vXEWG5O/M+lPYL5qjoeNfs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgDnv-0003kh-94; Wed, 26 Jun 2019 21:42:03 +0200
Date:   Wed, 26 Jun 2019 21:42:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [net-next 2/4] gve: Add transmit and receive support
Message-ID: <20190626194203.GF27733@lunn.ch>
References: <20190626185251.205687-1-csully@google.com>
 <20190626185251.205687-3-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-3-csully@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int gve_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +	dev->mtu = new_mtu;
> +	return 0;
> +}

The default implementation does this.

Also, i think your mtu has a limit of PAGE size.  So you should set
the dev->max_mtu so the core will enforce this.

    Andrew
