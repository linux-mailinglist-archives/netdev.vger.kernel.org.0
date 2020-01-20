Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC15C1427A3
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgATJuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:50:09 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46561 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgATJuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:50:08 -0500
Received: from soja.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:13da])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <o.rempel@pengutronix.de>)
        id 1itTh3-0001PY-RY; Mon, 20 Jan 2020 10:50:01 +0100
Subject: Re: [PATCH v1] ARM i.MX6q: make sure PHY fixup for KSZ9031 is applied
 only on one board
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        kernel@pengutronix.de, Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <20191209084430.11107-1-o.rempel@pengutronix.de>
 <20191209171508.GD9099@lunn.ch>
 <20191209173952.qnkzfrbixjgi2jfy@pengutronix.de>
 <20191209175119.GK9099@lunn.ch>
From:   Oleksij Rempel <o.rempel@pengutronix.de>
Message-ID: <30b05289-2cd6-6ca9-51fd-0af351506b6e@pengutronix.de>
Date:   Mon, 20 Jan 2020 10:50:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20191209175119.GK9099@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:13da
X-SA-Exim-Mail-From: o.rempel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.12.19 18:51, Andrew Lunn wrote:
>> Yes. all of them are broken.
>> I just trying to not wake all wasp at one time. Most probably there are
>> board working by accident. So, it will be good to have at least separate
>> patches for each fixup.
> 
> I agree about a patch per fixup. Can you try to generate such patches?
> See if there is enough history in git to determine which boards
> actually need these fixups?

After some attempts to make it and more discussions, I tend to provide a Kconfig to 
disable/enable this fixups. This will provide an option for users with old devicetree
and possibility to continue development on clean setup.

What do you think about this way and what default state it should be? FIXUPS default on or 
off?

Kind regards,
Oleksij Rempel

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
