Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABD344D547
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 11:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhKKKvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 05:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhKKKvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 05:51:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5B6C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 02:48:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <h.assmann@pengutronix.de>)
        id 1ml7dL-00011i-GX; Thu, 11 Nov 2021 11:48:43 +0100
Subject: Re: [Linux-stm32] [PATCH net] net: stmmac: allow a tc-taprio
 base-time of zero
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Michael Olbrich <m.olbrich@pengutronix.de>
Cc:     Yannick Vignon <yannick.vignon@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
 <87bl2t3fkq.fsf@kurt> <20211109103504.ahl2djymnevsbhoj@skbuf>
 <6bf6db8b-4717-71fe-b6de-9f6e12202dad@pengutronix.de>
 <20211109142255.5ohhfyin7hsffmlk@skbuf>
 <20211110123843.3u4jo3xe7plows6r@skbuf>
From:   Holger Assmann <h.assmann@pengutronix.de>
Message-ID: <7090ab87-e0ba-3f5a-116d-71ce34a94c97@pengutronix.de>
Date:   Thu, 11 Nov 2021 11:48:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110123843.3u4jo3xe7plows6r@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: h.assmann@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 10.11.21 um 13:38 schrieb Vladimir Oltean:
>>
>> Indeed. Was there a v2 to that?
> 
> FWIW I've applied that patch and made a few fixups according to my
> liking, and it works fine. I can resend it myself if there aren't any
> volunteers from Pengutronix.
> 

Feel free to do so!

Greetings,
Holger

-- 
Pengutronix e.K.                         | Holger Assmann              |
Steuerwalder Str. 21                     | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686         | Fax:   +49-5121-206917-5555 |
