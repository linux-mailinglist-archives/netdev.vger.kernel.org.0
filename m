Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDEE2C7A22
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 17:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgK2Q6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 11:58:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55470 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728050AbgK2Q6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 11:58:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjQ10-009NH3-Ms; Sun, 29 Nov 2020 17:57:34 +0100
Date:   Sun, 29 Nov 2020 17:57:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jean Pihet <jean.pihet@newoldbits.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Subject: Re: [PATCH 1/2] net: dsa: ksz: pad frame to 64 bytes for transmission
Message-ID: <20201129165734.GB2234159@lunn.ch>
References: <20201129102400.157786-1-jean.pihet@newoldbits.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201129102400.157786-1-jean.pihet@newoldbits.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jean

Please also include a patch 0/X which describes the patchset as a
whole. This will be used as the branch merge commit.

       Andrew
