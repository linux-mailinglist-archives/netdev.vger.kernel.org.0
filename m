Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6B346971C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 14:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbhLFNgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 08:36:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244021AbhLFNgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 08:36:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RC8NrBrwhX5mCdIhtGkHRsv39pzHtyYIv/DNyy3qsUg=; b=vW5WUTKphb7vVjRVrPQUmUyifI
        EJFhNoU7pKBRFDxdloAPoVy/Skh1dW0o72MEJWqKVt/uhyHibIR/WAslXAqyMU45LZHaV/7qbqmQX
        XfoSpBoYKRjAEztL114ZjpTsBzOEwi6s7Il65pV+CvqVSfj8zsCWN4vvqMQtndbHZmAQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muE6f-00FfDv-2O; Mon, 06 Dec 2021 14:32:37 +0100
Date:   Mon, 6 Dec 2021 14:32:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Apeksha Gupta <apeksha.gupta@nxp.com>
Cc:     qiangqing.zhang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com
Subject: Re: [PATCH v2 0/3] drivers/net: split FEC driver
Message-ID: <Ya4Q9aysfYwV35MO@lunn.ch>
References: <20211206045536.8690-1-apeksha.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206045536.8690-1-apeksha.gupta@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:25:33AM +0530, Apeksha Gupta wrote:
> This patch series is to restructure the FEC (Fast Ethernet Controller)
> driver. All PHY functionality moved from fec_main.c to separate files
> fec_phy.h and fec_phy.c. By these changes FEC driver become more
> flexible to work with other PHY drivers whenever required in future.

The MAC driver has little to do with the PHY driver. All PHY driver
details are in the actual PHY driver and phylib. At minimum we need to
see these other PHY driver changes, so you can justify this change.

What i think you are trying to do is sneak in the changes you need for
DPDK. Please don't so that. Just implement XDP.

NACK

      Andrew
