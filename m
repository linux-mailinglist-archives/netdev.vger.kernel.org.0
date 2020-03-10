Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD9C1807E0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 20:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCJTVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 15:21:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55788 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgCJTVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 15:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rLkHQLHRXwnPXJXV6GglYqp8ii1S4lgeI0wZx9YE3e4=; b=2hwxnNf9ZK+DPmJWWARHUeKMzF
        njilO4vrjWJByZovE74EOyMdtw7xVRbyh6XAZNyF7fP6Zi0uMMRG2ij81V8UCqayfFcbp1Tg359Bf
        EJ9ws81dHmHrgAvAiTx6NFRCfWWBj4ZE2VOotMwi+RFtUB/utQxYvkAxDjtDnMkqEQes=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jBkRD-0004Y5-PD; Tue, 10 Mar 2020 20:21:11 +0100
Date:   Tue, 10 Mar 2020 20:21:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH net-next 4/6] octeontx2-vf: Ethtool support
Message-ID: <20200310192111.GC11247@lunn.ch>
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:17:23AM +0530, sunil.kovvuri@gmail.com wrote:
> +int __weak otx2vf_open(struct net_device *netdev)
> +{
> +	return 0;
> +}
> +
> +int __weak otx2vf_stop(struct net_device *netdev)
> +{
> +	return 0;
> +}

Hi Sunil

weak symbols are very unusual in a driver. Why are they required?

Thanks
	Andrew
