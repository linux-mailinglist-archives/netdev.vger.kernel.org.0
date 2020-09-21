Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA4B272407
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgIUMlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:41:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47220 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgIUMlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 08:41:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKL7x-00Fakz-KH; Mon, 21 Sep 2020 14:41:05 +0200
Date:   Mon, 21 Sep 2020 14:41:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     mkubecek@suse.cz, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, michael.chan@broadcom.com,
        edwin.peer@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH ethtool] bnxt: Add Broadcom driver support.
Message-ID: <20200921124105.GD3702050@lunn.ch>
References: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct bnxt_pcie_stat {
> +	const char *name;
> +	u16 offset;
> +	u8 size;
> +	const char *format;
> +};
> +
> +static const struct bnxt_pcie_stat bnxt_pcie_stats[] = {
> +	{ .name = "PL Signal integrity errors     ", .offset = 0, .size = 4, .format = "%lld" },
> +	{ .name = "DL Signal integrity errors     ", .offset = 4, .size = 4, .format = "%lld" },
> +	{ .name = "TLP Signal integrity errors    ", .offset = 8, .size = 4, .format = "%lld" },

These look like statistics. Could they be part of ethtool -S

      Andrew
