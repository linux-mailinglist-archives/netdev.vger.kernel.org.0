Return-Path: <netdev+bounces-4282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D42970BE07
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 188AF28104C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603F312B71;
	Mon, 22 May 2023 12:26:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555654408
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:26:36 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FACA9;
	Mon, 22 May 2023 05:26:33 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id B0691C0004;
	Mon, 22 May 2023 12:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684758392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LmOknkiGbwRWi05gBEVUbhKWKgcpIrXBPCzL78lpEGw=;
	b=KJYXKaU5T0YwZvWBpn0vwwU7ANrv67sjH7nSzG1MQfrq9UEAMIttP39vWyaT3HdcAKjomH
	g/qV6CvC8Rx9QMJAUf/z41PtN9/Vc0Rw/1REVVTP9ouPMfWj/jpNU/5LApgDBZ78ObwwE3
	WcecZtw6sZGxONJD85smgMi5tkmAenLw4yK+a3TC9Vq0gMmeoQM7RNU/kztNBUnyyq3FaD
	iUJmVFLsUmtLN9Q885rGIPX2jU0at9awrIyGbzEG3mjpG4ejk4vbw144QHBtb9D7nmk0ZT
	ZiLLqPOylo8rLIL6TSvUnXjEZF1n6YOi/W6uCDaQ6TIarNkAAuw+IeOswkzMWw==
Message-ID: <aed51991-7f4f-b8c5-e899-48e8f23075fb@bootlin.com>
Date: Mon, 22 May 2023 14:26:50 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Richard Cochran <richardcochran@gmail.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 thomas.petazzoni@bootlin.com, paul.arola@telus.com, scott.roberts@telus.com,
 =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-8-alexis.lothore@bootlin.com>
 <ZGeLEbcCHzOASasC@shell.armlinux.org.uk>
 <1c104034-b61f-5242-40fa-339de59ac9c9@bootlin.com>
 <237dbb7f-8979-4435-a099-95bb5d093910@lunn.ch>
From: =?UTF-8?Q?Alexis_Lothor=c3=a9?= <alexis.lothore@bootlin.com>
In-Reply-To: <237dbb7f-8979-4435-a099-95bb5d093910@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Andrew,
On 5/22/23 14:19, Andrew Lunn wrote:
>>> Not exactly related to this patch, but please do not rely on this "max
>>> speed mode" - please always ensure that you specify the phy-mode and
>>> fixed-link settings for CPU and DSA ports in firmware. Thanks.
>>
>> I would like to make sure to fully understand your point:
>> - when telling so specify phy-mode and fixed-link in firmware, you mean
>> device-tree, right ?
>> - when checking for code and execution flow, I observe that port_max_speed is
>> always called and its output is always used to configure shared ports mode in
>> mv88e6xxx driver. Are you telling that eventually, the whole mv88e6xxx driver
>> should stop relying on port_max_speed_mode for shared ports ?
> 
> Yes, the concept of port_max_speed_mode causes problems for PHYLINK,
> and we want to remove it. Russell and i have been updating DT
> descriptions adding fixed-link and phy-mode properties to all
> mv88e6xxx systems so that it is not needed. Either at the end of this
> cycle, or the beginning of the next we will change the code to
> actually enforce this.

Understood, thanks for clarification

> 
> 	 Andrew

-- 
Alexis Lothoré, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


