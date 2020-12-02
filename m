Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1766E2CC39A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgLBRYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:24:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34494 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgLBRYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 12:24:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkVqr-009thJ-Ln; Wed, 02 Dec 2020 18:23:37 +0100
Date:   Wed, 2 Dec 2020 18:23:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2] Improve error message when SFP module is
 missing
Message-ID: <20201202172337.GI2324545@lunn.ch>
References: <19fb6da036b04a465398f5b053b029ea04179aba.1606929734.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19fb6da036b04a465398f5b053b029ea04179aba.1606929734.git.baruch@tkos.co.il>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 07:22:14PM +0200, Baruch Siach wrote:
> ETHTOOL_GMODULEINFO request success indicates that SFP cage is present.
> Failure of ETHTOOL_GMODULEEEPROM is most likely because SFP module is
> not plugged in. Add an indication to the user as to what might be the
> reason for the failure.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
