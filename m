Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1100ED9E6
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 08:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfKDH3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 02:29:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60562 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbfKDH3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 02:29:17 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iRWnL-0004Dn-BL; Mon, 04 Nov 2019 08:28:59 +0100
Message-ID: <69baa44c928ae7f6ca1f4631b7beb6b2c2b1c033.camel@sipsolutions.net>
Subject: Re: [PATCH v2 2/7] mac80211: Use debugfs_create_xul() helper
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 04 Nov 2019 08:28:57 +0100
In-Reply-To: <20191025094130.26033-3-geert+renesas@glider.be>
References: <20191025094130.26033-1-geert+renesas@glider.be>
         <20191025094130.26033-3-geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-10-25 at 11:41 +0200, Geert Uytterhoeven wrote:
> Use the new debugfs_create_xul() helper instead of open-coding the same
> operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Sorry Greg, this slipped through on my side.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Do you prefer to take this to your tree still, or should I pick it up
later once debugfs_create_xul() is available (to me)?

johannes


