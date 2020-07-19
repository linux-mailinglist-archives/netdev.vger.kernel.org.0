Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD7A225445
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 23:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgGSVVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 17:21:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43800 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgGSVVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 17:21:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxGk0-005vjt-Pu; Sun, 19 Jul 2020 23:21:00 +0200
Date:   Sun, 19 Jul 2020 23:21:00 +0200
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
Subject: Re: [PATCH v2 net-next 01/14] qed: convert link mode from u32 to
 bitmap
Message-ID: <20200719212100.GM1383417@lunn.ch>
References: <20200719201453.3648-1-alobakin@marvell.com>
 <20200719201453.3648-2-alobakin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200719201453.3648-2-alobakin@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 11:14:40PM +0300, Alexander Lobakin wrote:
> Currently qed driver already ran out of 32 bits to store link modes,
> and this doesn't allow to add and support more speeds.
> Convert link mode to bitmap that will always have enough space for
> any number of speeds and modes.

Hi Alexander

Why not just throw away all these QED_LM_ defines and use the kernel
link modes? The fact you are changing the u32 to a bitmap suggests the
hardware does not use them.

     Andrew
