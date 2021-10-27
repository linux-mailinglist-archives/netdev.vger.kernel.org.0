Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE8E43D15B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbhJ0TD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:03:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239031AbhJ0TD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Fs1k6uaHALUBcA3UWZ75VTAG9AmCGB/k7DReufrKhdM=; b=Z75BKusw94S0W/KDlUzZ6d4IyF
        +s5okMGih0a/qYBDRq/lDoRzfucGkrt+QgA0rrX+tTG/zGcdaYB32V9cOu4I7JtpqlOlwDiVdsQ2/
        4UWIYaam3T/wYIBve95hNhLoRzXpOyg/WXN80a8TNUEiwkACMQqKEX1tjjm04No70nDg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfo9U-00Bvs4-7J; Wed, 27 Oct 2021 20:59:56 +0200
Date:   Wed, 27 Oct 2021 20:59:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        mkubecek@suse.cz, amitc@mellanox.com, idosch@idosch.org,
        danieller@nvidia.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, netanel@amazon.com,
        akiyano@amazon.com, saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V4 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <YXmhrOS7Zo8AIorz@lunn.ch>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014113943.16231-5-huangguangbin2@huawei.com>
 <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
 <20211025132718.5wtos3oxjhzjhymr@pengutronix.de>
 <20211025104505.43461b53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211025190114.zbqgzsfiv7zav7aq@pengutronix.de>
 <8ce654b8-4a31-2d43-df7e-607528ba44d5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ce654b8-4a31-2d43-df7e-607528ba44d5@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We think ethtool_ringparam_ext is more easy to understand it is extension of
> struct ethtool_ringparam. However, we don't mind to keep the same way and modify
> to the name kernel_ethtool_ringparam if everyone agrees.
> 
> Does anyone have other opinions?

What has been done most in the past? We should one way to do this, and
consistently use it everywhere in the network stack.

     Andrew
