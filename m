Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0E723AE36
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgHCUee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:34:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbgHCUee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:34:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2hAH-0086iU-Di; Mon, 03 Aug 2020 22:34:33 +0200
Date:   Mon, 3 Aug 2020 22:34:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/5] net: dsa: loop: PVID should be per-port
Message-ID: <20200803203433.GF1919070@lunn.ch>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
 <20200803200354.45062-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803200354.45062-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 01:03:50PM -0700, Florian Fainelli wrote:
> The PVID should be per-port, this is a preliminary change to support a
> 802.1Q data path in the driver.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
