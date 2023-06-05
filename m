Return-Path: <netdev+bounces-8007-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BAB772265E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B600280CA0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C3B18B17;
	Mon,  5 Jun 2023 12:52:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A04F9FF
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:52:05 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5B29E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:52:03 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.ext.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1q69gm-0007O1-HV; Mon, 05 Jun 2023 14:52:00 +0200
Message-ID: <e3170e58-60fa-e682-50d5-404ea27ef4ab@pengutronix.de>
Date: Mon, 5 Jun 2023 14:51:59 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH resubmit] net: fec: Refactor: rename `adapter` to `fep`
Content-Language: en-US
To: =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>,
 Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
 Richard Cochran <richardcochran@gmail.com>, kernel@pengutronix.de,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>
References: <20230605094402.85071-1-csokas.bence@prolan.hu>
 <20230605-surfboard-implosive-d1700e274b20-mkl@pengutronix.de>
 <e67321c3-2a81-170a-0394-bdb00beb7182@prolan.hu>
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <e67321c3-2a81-170a-0394-bdb00beb7182@prolan.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05.06.23 14:35, Csókás Bence wrote:
> On 2023. 06. 05. 11:51, Marc Kleine-Budde wrote:
>> On 05.06.2023 11:44:03, Csókás Bence wrote:
>>> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
>>
>> You probably want to add a patch description.
> 
> Is it necessary for such a trivial refactor commit? I thought the commit msg already said it all. What else do you think I should include still?
> 
> 
> Would something like this be sufficient?
> "Rename local `struct fec_enet_private *adapter` to `fep` in `fec_ptp_gettime()` to match the rest of the driver"

The "to match the rest of the driver" is the interesting part.
I see what the commit is doing, but the title alone doesn't tell
me why you'd want to change it.

Cheers,
Ahmad

> 
>>
>> regards,
>> Marc
>>
> 
> Thanks,
> Bence
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |


