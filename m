Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08C926483C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbgIJOrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730865AbgIJOkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:40:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BA0820855;
        Thu, 10 Sep 2020 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599748817;
        bh=3jABepdwQlseMkw2M80HP4FjnwkzEa58NXCBJcZr2CU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SUR/L0zaFWp7y/rGAfdXi49jC7BiG6Dc5ZGoyzs3dYNjDZgLwyeV/it1MPB/Tx2JE
         HTA335fclH28b5HCi1ZAEc7mjRDV6esrhqXuhab18tjaSSqojEkTV0UeQLIeVXExCQ
         P7mA6xcT6ZGqKqrsOFDFhwVHjpZYALclgUVTewvM=
Date:   Thu, 10 Sep 2020 07:40:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/5] dpaa2-eth: add APIs of 1588 single step
 timestamping
Message-ID: <20200910074016.2c4060a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910093835.24317-2-yangbo.lu@nxp.com>
References: <20200910093835.24317-1-yangbo.lu@nxp.com>
        <20200910093835.24317-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 17:38:31 +0800 Yangbo Lu wrote:
> This patch is to add APIs of 1588 single step timestamping.
> 
> - dpni_set_single_step_cfg
> - dpni_get_single_step_cfg
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

drivers/net/ethernet/freescale/dpaa2/dpni.c:2035:23: warning: restricted __le16 degrades to integer
drivers/net/ethernet/freescale/dpaa2/dpni.c:2036:30: warning: restricted __le16 degrades to integer
drivers/net/ethernet/freescale/dpaa2/dpni.c:2069:9: warning: invalid assignment: |=
drivers/net/ethernet/freescale/dpaa2/dpni.c:2069:9:    left side has type restricted __le16
drivers/net/ethernet/freescale/dpaa2/dpni.c:2069:9:    right side has type unsigned long
drivers/net/ethernet/freescale/dpaa2/dpni.c:2070:9: warning: invalid assignment: |=
drivers/net/ethernet/freescale/dpaa2/dpni.c:2070:9:    left side has type restricted __le16
drivers/net/ethernet/freescale/dpaa2/dpni.c:2070:9:    right side has type unsigned long
