Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E2AD6730
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 18:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731276AbfJNQXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 12:23:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44998 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730957AbfJNQXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 12:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tlPhMYI/rbwxWPTaXzNEi16cvAXTZ9kyJttEikIt//8=; b=dElX2fQv4iC+XivGOf5kfgVyXc
        97eBYIx9+onFjGjkbrsQbZFDrO7vP+XzWhNlUCjtDP8PaYFGUcNOP7Jur1017dlFOQbs/n3jw938j
        5RH+TCIrPuECvzh2pokkBGUnycYr9Jf0bjkw6BAx//bYPNCGqX0iWdt3fbA3qeo6b3II=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iK37v-0006Gc-Fg; Mon, 14 Oct 2019 18:23:19 +0200
Date:   Mon, 14 Oct 2019 18:23:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 08/12] net: aquantia: add support for ptp
 ioctls
Message-ID: <20191014162319.GO21165@lunn.ch>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <e5810b73ee7a792d464284069b7dec7f775575b8.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5810b73ee7a792d464284069b7dec7f775575b8.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int aq_ndev_config_hwtstamp(struct aq_nic_s *aq_nic,
> +				   struct hwtstamp_config *config)
> +{
> +	if (config->flags)
> +		return -EINVAL;
> +
> +	switch (config->tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +	case HWTSTAMP_TX_ON:
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config->rx_filter) {
> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:

Probably a question of Richard

I think this hardware only supports IPv4. Is there some way to
indicate IPv6 is not supported?

	 Andrew
