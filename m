Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB9E226E48
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgGTSb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:31:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgGTSb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 14:31:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxaZF-0063w5-Tx; Mon, 20 Jul 2020 20:31:13 +0200
Date:   Mon, 20 Jul 2020 20:31:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alobakin@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-everest-linux-l2@marvell.com,
        QLogic-Storage-Upstream@marvell.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 01/16] linkmode: introduce
 linkmode_intersects()
Message-ID: <20200720183113.GK1339445@lunn.ch>
References: <20200720180815.107-1-alobakin@marvell.com>
 <20200720180815.107-2-alobakin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720180815.107-2-alobakin@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 09:08:00PM +0300, Alexander Lobakin wrote:
> Add a new helper to find intersections between Ethtool link modes,
> linkmode_intersects(), similar to the other linkmode helpers.
> 
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
