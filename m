Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD05829DBC3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389646AbgJ2ANf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390805AbgJ2ANd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXkBG-003y9u-Qv; Wed, 28 Oct 2020 13:03:54 +0100
Date:   Wed, 28 Oct 2020 13:03:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     f.fainelli@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v5 2/3] dt-bindings: net: Add 5GBASER phy interface mode
Message-ID: <20201028120354.GB933237@lunn.ch>
References: <cover.1603837678.git.pavana.sharma@digi.com>
 <555c152c26952102a76f8ee40261b68c24c67ef2.1603837679.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555c152c26952102a76f8ee40261b68c24c67ef2.1603837679.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 10:09:12AM +1000, Pavana Sharma wrote:
> Add 5GBASE-R phy interface mode supported by mv88e6393
> family.
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
