Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0AE366A91
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239642AbhDUMSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:18:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238221AbhDUMSA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 08:18:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZBnF-000JIp-1F; Wed, 21 Apr 2021 14:17:21 +0200
Date:   Wed, 21 Apr 2021 14:17:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: dsa: mv88e6xxx: Correct spelling of
 define "ADRR" -> "ADDR"
Message-ID: <YIAX0axv5LWchKtM@lunn.ch>
References: <20210421120454.1541240-1-tobias@waldekranz.com>
 <20210421120454.1541240-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421120454.1541240-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 02:04:52PM +0200, Tobias Waldekranz wrote:
> Because ADRR is not a thing.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
