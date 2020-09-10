Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605BB265162
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgIJUxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730544AbgIJOuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:50:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C68B920C09;
        Thu, 10 Sep 2020 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599749049;
        bh=y1/UiaFqTZvUJ00Sl8M0YEMGTpBBJAgalN+YK0nHQ7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l9GIFLJ0iDliBtTQm3+j5U8G2fE6bdu+9JsUJLSbEk1mJRJKoAeWCchtb4fzcYTfr
         sRqtjVG/Cc+qTSju6NB/w/XM/Lr4WOw6HdjSkzWAxbe5XU2/TWLnkGMRnwekFxWPuM
         MQx/E823NDT5iF4UhzC2sJ2YH62J4dwDNFAK/tk8=
Date:   Thu, 10 Sep 2020 07:44:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [v2, 0/5] dpaa2_eth: support 1588 one-step timestamping
Message-ID: <20200910074407.6ba9ae2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910101655.13904-1-yangbo.lu@nxp.com>
References: <20200910101655.13904-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 18:16:50 +0800 Yangbo Lu wrote:
> Change for v2:
> 	- Removed unused variable priv in dpaa2_eth_xdp_create_fd().


Ah, just saw this. Please fix all the other warnings and errors from v1,
too.
