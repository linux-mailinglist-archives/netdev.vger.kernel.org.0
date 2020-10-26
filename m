Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF462298DA4
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1774656AbgJZNRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:17:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1774629AbgJZNRE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 09:17:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kX2Mo-003biD-UZ; Mon, 26 Oct 2020 14:16:54 +0100
Date:   Mon, 26 Oct 2020 14:16:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] net: phy: fix kernel-doc markups
Message-ID: <20201026131654.GJ752111@lunn.ch>
References: <cover.1603705472.git.mchehab+huawei@kernel.org>
 <d23c5638c4fd0e7b9f294f2bf647d2386428eb7e.1603705472.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d23c5638c4fd0e7b9f294f2bf647d2386428eb7e.1603705472.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 10:47:36AM +0100, Mauro Carvalho Chehab wrote:
> Some functions have different names between their prototypes
> and the kernel-doc markup.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

