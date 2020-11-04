Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EE52A66B0
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgKDOrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:47:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730073AbgKDOrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:47:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaK4A-005E3o-Fk; Wed, 04 Nov 2020 15:47:14 +0100
Date:   Wed, 4 Nov 2020 15:47:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dustin McIntire <dustin@sensoria.com>, kuba@kernel.org,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/12] net: ethernet: smsc: smc911x: Mark 'status' as
 __maybe_unused
Message-ID: <20201104144714.GF1213539@lunn.ch>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-3-lee.jones@linaro.org>
 <20201104132200.GW933237@lunn.ch>
 <20201104143140.GE4488@dell>
 <20201104143826.GF4488@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104143826.GF4488@dell>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Our of interest, are you planning on working on any other areas?

Hi Lee.

No, not really. I'm a networking guy, so will look mostly at
drivers/net and the core net code.

    Andrew
