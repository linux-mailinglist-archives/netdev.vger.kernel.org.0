Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F3AFB913
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfKMTqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:46:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfKMTqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:46:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D44E4153EE9CA;
        Wed, 13 Nov 2019 11:46:03 -0800 (PST)
Date:   Wed, 13 Nov 2019 11:46:03 -0800 (PST)
Message-Id: <20191113.114603.769837304624163429.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        mparab@cadence.com, piotrs@cadence.com, dkangude@cadence.com,
        ewanm@cadence.com, arthurm@cadence.com, stevenh@cadence.com
Subject: Re: [PATCH net-next v3 0/2] net: macb: convert to phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113090006.58898-1-antoine.tenart@bootlin.com>
References: <20191113090006.58898-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 11:46:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Wed, 13 Nov 2019 10:00:04 +0100

> This series converts the MACB Ethernet driver to the Phylink framework.
> The MAC configuration is moved to the Phylink ops and Phylink helpers
> are now used in the ethtools functions. This helps to access the flow
> control and pauseparam logic and this will be helpful in the future for
> boards using this controller with SFP cages.
 ...

Series applied, thanks.
