Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190BF2CC2C2
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbgLBQu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:50:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730550AbgLBQu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 11:50:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkVK4-009tUE-Fy; Wed, 02 Dec 2020 17:49:44 +0100
Date:   Wed, 2 Dec 2020 17:49:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Patrick Havelange <patrick.havelange@essensium.com>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: freescale/fman: Split the main resource region
 reservation
Message-ID: <20201202164944.GH2324545@lunn.ch>
References: <20201202161600.23738-1-patrick.havelange@essensium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202161600.23738-1-patrick.havelange@essensium.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Patrick

Please always include a patch [0/x] which explains the big picture,
what the patchset as a whole is trying to achieve.

     Andrew
