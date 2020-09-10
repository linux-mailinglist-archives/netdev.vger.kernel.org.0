Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C055E264EBC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgIJTYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbgIJTXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 15:23:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F4C8206DB;
        Thu, 10 Sep 2020 19:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599765832;
        bh=96zT4Xmg94ZHbDBP/nK1S/L06ICfJP5iCTTP4Fdg9NY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QOzOG0T38ZlqG8vZLvpTuUtqO8QjBZE7P/czMMyMlzO/YT88noqg/F5blCoMcBYwc
         t1qPsEUPIrEeZG4yaoV3TOCvehfvOGXpfWnprhSQsd3iSSZVNAdjQOW/MUV3mkaqPq
         TqyUxO9bsSAc79nH2Xk8FEJOnOoNmvIDMZNE+8jc=
Date:   Thu, 10 Sep 2020 12:23:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net-next 7/9] net: dsa: mv88e6xxx: Add devlink
 regions
Message-ID: <20200910122350.2c49ce88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909235827.3335881-8-andrew@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
        <20200909235827.3335881-8-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 01:58:25 +0200 Andrew Lunn wrote:
> +	table = kmalloc_array(mv88e6xxx_num_databases(chip),
> +			      sizeof(struct mv88e6xxx_devlink_atu_entry),
> +			      GFP_KERNEL);
> +	if (!table)
> +		return -ENOMEM;
> +
> +	memset(table, 0, mv88e6xxx_num_databases(chip) *
> +	       sizeof(struct mv88e6xxx_devlink_atu_entry));

kcalloc()
