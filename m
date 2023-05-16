Return-Path: <netdev+bounces-3099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8812270571A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8414E1C20C1F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BB529113;
	Tue, 16 May 2023 19:30:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87283187E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:30:00 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1BB55AD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:29:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684265377; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=cXlVnfJZH/dhHgG7/F1Yp7GIhcDOfdFTCRh1rYLhq2J0eS6iod7Oq8phcGev4m4pTJxZ/I2cAA/17Vy8XOKCiJZ7EGDxc84i2mXI+O5/WeqMZ5nS71Oe13s9C3ZqJOl2o5hrJe+enWG5Cf8qVYWi6VuvnSVEa7gdioh5XDJADW0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684265377; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=Bmra5helk8rWxhFhMRciXdPeMIrrQOw5pj0HVRf7rlA=; 
	b=Ie4kKCllk0K+gWGjMBiwKaeI9K7dZM7qF7en1KQk+EWmsWaTliMly8rE7Zkc1dBOUxRjkycHTGUtrA6yf573UQ2TbQcaPbFqmvciX+wGAMf7HEzwl36O+awHZnV5Z+NgSjurN6zlXtoGOgFY4BHIKf2Hhr5FcYK9E4MSGEVQV+Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684265377;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Bmra5helk8rWxhFhMRciXdPeMIrrQOw5pj0HVRf7rlA=;
	b=XjSTyPMBrFfKsvfLmO99WcX7ZkrW0SPdp1Y79qKfE0V/L8GaHDFnIZwZ2rM5eEVK
	+K8bUPMd65SMGeoCu6C25SBlVuYFu+otPwVVyFLulXULB1+VCVP2116q9yCKMQenivN
	SmXFkeVUWlG1GS+Aa43aj0vMkXPG2mXtCdMJIwIA=
Received: from [10.10.10.122] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684265375916563.2475018541435; Tue, 16 May 2023 12:29:35 -0700 (PDT)
Message-ID: <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
Date: Tue, 16 May 2023 22:29:27 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Choose a default DSA CPU port
To: Vladimir Oltean <olteanv@gmail.com>,
 Frank Wunderlich <frank-w@public-files.de>
Cc: Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
 erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>, John Crispin <john@phrozen.org>,
 Mark Lee <Mark-MC.Lee@mediatek.com>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 Landen Chao <Landen.Chao@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 DENG Qingfang <dqfext@gmail.com>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230228115846.4r2wuyhsccmrpdfh@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 28.02.2023 14:58, Vladimir Oltean wrote:
> On Sun, Feb 26, 2023 at 01:12:04PM +0100, Frank Wunderlich wrote:
>> but back to topic...we have a patch from vladuimir which allows
>> setting the preferred cpu-port...how do we handle mt7531 here
>> correctly (which still sets port5 if defined and then break)?
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n2383
>>
>> 	/* BPDU to CPU port */
>> 	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
>> 		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
>> 			   BIT(cpu_dp->index));
>> 		break; //<<< should we drop this break only to set all "cpu-bits"? what happens then (flooding both ports with packets?)
>> 	}
>>
>> as dsa only handles only 1 cpu-port we want the real cpu-port
>> (preferred | first). is this bit set also if the master is changed
>> with your follow-up patch?
> 
> Could you please make a best-effort attempt at describing what does the
> MT7531_CFC[MT7531_CPU_PMAP_MASK] register affect? From the comment, if
> affects the trapping of control packets. Does the MT7530 not have this
> register? Do they behave differently? Does the register affect anything
> else? If that logic is commented out, does DSA-tagged traffic still work
> on MT7531? How about a bridge created with stp_state 1? I don't
> understand at the moment why the hardware allows specifying a port mask
> rather than a single port. Intuitively I'd say that if this field
> contains more than one bit set, then control packets would be delivered
> to all CPU ports that are up, effectively resulting in double processing
> in Linux. So that doesn't seem to be useful. But I don't have enough data.

I have thoroughly tested BPDU trapping using mausezahn on MT7530, and 
now MT7531.

First of all, the MT7530_MFC register exists on MT7530 and MT7531 but 
they're not the same. CPU_EN and CPU_PORT bits are specific to MT7530. 
The MT7531_CFC register and therefore the CPU_PMAP bits are specific to 
MT7531.

All these bits are used only for trapping frames. They don't affect 
anything else. DSA tagged traffic still works without setting anything 
on CPU_EN and CPU_PORT on MT7530. DSA tagged traffic still works without 
setting anything on CPU_PMAP on MT7531.

For MT7530, the port to trap the frames to is fixed since CPU_PORT is 
only of 3 bits so only one CPU port can be defined. This means that, in 
case of multiple ports used as CPU ports, any frames set for trapping to 
CPU port will be trapped to the numerically greatest CPU port.

For MT7531, after properly setting the CPU port bitmap [0], the switch 
traps the frame to the CPU port the user port is connected to. So 
there's no double processing!

I confirmed this by adding support for changing DSA conduit [1], then 
doing a BPDU test using mausezahn.

Here's the test from my computer. One port is connected to an MT7531 
port connected to eth0, the other is connected to an MT7531 port 
connected to eth1.

BPDUs only appear on eth0:
sudo mausezahn enp9s0 -c 0 -d 1s -t bpdu

BPDUs only appear on eth1:
sudo mausezahn eno1 -c 0 -d 1s -t bpdu

[0] 
https://github.com/arinc9/linux/commit/6dfa74e6383249bd017092eada0c41f178fa3d25
[1] 
https://github.com/arinc9/linux/commit/5ed8f08bd750ab5db521bf97584ddc1d43d23b2c

Arınç

