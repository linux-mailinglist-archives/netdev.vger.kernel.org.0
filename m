Return-Path: <netdev+bounces-3394-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CB11706DC1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B9E628164B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA1C111B7;
	Wed, 17 May 2023 16:14:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E649101D9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:14:36 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FD3FB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:14:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684340053; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ila3l4t8TcGCIofkSH013KkYuWqQP/gmMMNUCZBNMa6UqHeiiVuuL1SW6qQjj2DTeI4I6OalcPDEetoaqmbAN5KjV9lryk5O6LNbVj5ltKtkIniBmt5O+Pf0508Et/UwdJreqCfCqVToMGj9eZXudXUDbNxkZjGUbBzdaHYNFes=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684340053; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=V/19PBQ7+oJiKfsdLT2+D0gnjx8cglmD4Es9XIaz/VA=; 
	b=jnicse2yl+O5lylhrJayNWdmhjemvouj1B0pDsWYSov02oP5O1oG/K4s7m5vIod3lnnsPDD6ArDUHwRLxQ1JXfzU+f+CqllllLrUyXfCrzlnplXBh2UlyEfnp0r/j5AnleiY0DPniH743wEJeS6QOjydTw0+PZPPisjle9mX2dA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684340053;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=V/19PBQ7+oJiKfsdLT2+D0gnjx8cglmD4Es9XIaz/VA=;
	b=Kj9IUwIkctj2Ht/X6sBAyPupZuIHTyPDdNgED5/OUvWFP9X6m2ME9tTaOwwgpbGt
	VqbVCm6iy8OvHOTS1r33/OzHvn3mxJmB7JJGRDhsTrOjlgJOdtz+KERj/B5MGcGJa2y
	7YwLGYPH40rr5JtOHeK+4Wb4isuHVa11cssjuhrY=
Received: from [10.10.10.122] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684340050887355.8482072241528; Wed, 17 May 2023 09:14:10 -0700 (PDT)
Message-ID: <e5f02399-5697-52f8-9388-00fa679bb058@arinc9.com>
Date: Wed, 17 May 2023 19:14:01 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Choose a default DSA CPU port
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Frank Wunderlich <frank-w@public-files.de>, Felix Fietkau <nbd@nbd.name>,
 netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
 Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 John Crispin <john@phrozen.org>, Mark Lee <Mark-MC.Lee@mediatek.com>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
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
 <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
 <20230517161028.6xmt4dgxtb4optm6@skbuf>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230517161028.6xmt4dgxtb4optm6@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17.05.2023 19:10, Vladimir Oltean wrote:
> On Tue, May 16, 2023 at 10:29:27PM +0300, Arınç ÜNAL wrote:
>> For MT7530, the port to trap the frames to is fixed since CPU_PORT is only
>> of 3 bits so only one CPU port can be defined. This means that, in case of
>> multiple ports used as CPU ports, any frames set for trapping to CPU port
>> will be trapped to the numerically greatest CPU port.
> 
> *that is up

Yes, the DSA conduit interface of the CPU port must be up. Otherwise, 
these frames won't appear anywhere. I should mention this on my patch, 
thanks.

Arınç

