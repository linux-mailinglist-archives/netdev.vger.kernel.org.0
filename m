Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448F7226E5C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgGTSeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:34:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgGTSet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 14:34:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxacc-0063zF-HV; Mon, 20 Jul 2020 20:34:42 +0200
Date:   Mon, 20 Jul 2020 20:34:42 +0200
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
Subject: Re: [PATCH v3 net-next 02/16] qed, qede, qedf: convert link mode
 from u32 to ETHTOOL_LINK_MODE
Message-ID: <20200720183442.GL1339445@lunn.ch>
References: <20200720180815.107-1-alobakin@marvell.com>
 <20200720180815.107-3-alobakin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720180815.107-3-alobakin@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 09:08:01PM +0300, Alexander Lobakin wrote:
> Currently qed driver already ran out of 32 bits to store link modes,
> and this doesn't allow to add and support more speeds.
> Convert custom link mode to generic Ethtool bitmap and definitions
> (convenient Phylink shorthands are used for elegance and readability).
> This allowed us to drop all conversions/mappings between the driver
> and Ethtool.
> 
> This involves changes in qede and qedf as well, as they used definitions
> from shared "qed_if.h".
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_main.c    | 288 ++++++++++--------
>  .../net/ethernet/qlogic/qede/qede_ethtool.c   | 200 ++++--------
>  drivers/scsi/qedf/qedf_main.c                 |  78 +++--
>  include/linux/qed/qed_if.h                    |  47 +--
>  4 files changed, 268 insertions(+), 345 deletions(-)

Nice diffstat.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
