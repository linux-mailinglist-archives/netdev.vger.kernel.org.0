Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62AA062E21
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfGICav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:30:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGICav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 22:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uPau7u5kVoIOL7QcQNcDeqBP800OcpuSnuAeN+j3CUQ=; b=pgb/EV6BoIzr6u23XyzIHuGwnp
        g+Wqx0CrwJu87XDDjVL2nmwAPtno1db0+/pU1SLu6TcVpytNavcl0EhBOyomIAWR2oRcF8DvllAgz
        L/ktLbr35C4Klvy6f6ZSQfZihgioKj6f3zFeLrq+YLxjO64mEgElA/fD7RHHU4K2e370=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkfu6-0006aB-Ev; Tue, 09 Jul 2019 04:30:50 +0200
Date:   Tue, 9 Jul 2019 04:30:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190709023050.GC5835@lunn.ch>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708192532.27420-14-snelson@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ionic_nway_reset(struct net_device *netdev)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	int err = 0;
> +
> +	if (netif_running(netdev))
> +		err = ionic_reset_queues(lif);

What does ionic_reset_queues() do? It sounds nothing like restarting
auto negotiation?

     Andrew
