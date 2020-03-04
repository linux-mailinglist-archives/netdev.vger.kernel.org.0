Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66C21792C9
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 15:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCDOzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 09:55:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgCDOzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 09:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0SOpupn090nwzDK1pJkDzNgiqEaGQ5s/rreLx0Go6yk=; b=GRB/6oiF6VzhuaqPx6/HSMZjiA
        ofaQqvCRP9zxBCUoBbr5DAmiPW0EfrS7MsKMWe1Ece8RZ5mZ/lc8JWAwsuYgO6cyZsZqG1iEF7c4V
        OD7DBOGTlF6iqbgYm4wpFnNewq899SjnXiusdXlHZ87LMLAIHG/DQWPqdVOy2tfTxOGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9VPz-0006Q1-1G; Wed, 04 Mar 2020 15:54:39 +0100
Date:   Wed, 4 Mar 2020 15:54:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, mkubecek@suse.cz, thomas.lendacky@amd.com,
        benve@cisco.com, _govind@gmx.com, pkaustub@cisco.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304145439.GC3553@lunn.ch>
References: <20200304035501.628139-1-kuba@kernel.org>
 <20200304035501.628139-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304035501.628139-2-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 07:54:50PM -0800, Jakub Kicinski wrote:
> @@ -2336,6 +2394,11 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
>  			goto roll_back;
>  		}
>  
> +		if (!ethtool_set_coalesce_supported(dev, &coalesce)) {
> +			ret = -EINVAL;
> +			goto roll_back;
> +		}

Hi Jakub

EOPNOTSUPP? 

    Andrew
