Return-Path: <netdev+bounces-708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3866F9263
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 16:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D79A281193
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 14:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E97E8BEB;
	Sat,  6 May 2023 14:04:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6020D1FAF
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 14:04:41 +0000 (UTC)
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4D47EC7
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 07:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
	s=s1; h=MIME-Version:References:In-Reply-To:Message-Id:Cc:To:Subject:From:
	Date:From:To:Subject:Date:Message-ID:Reply-To;
	bh=/y6i/2uJtbvTfRPuMg9QXmzD6zWMjHDw1YpPBF+17e0=; b=SNyTsj5giTTD5p6zrDaE1e4bi+
	pm2dLkz1Gr1WnC6mUSMeW2OoeGZZw5OVHIZNHzsH5wI/hzAjadDQq+1Uk0w8g0ZxaKCo1adtb6dKw
	vY9TRhLSMYzQA8VPQ94+e64sq4tpANIwdCHT5cZYALRxiza39PqR9LLNYidMKUlwJIVah4eLjaPoH
	nrCpJbrbIsZuYfzMDkXvj3SujsvEUAtxby0pdxukMkRc1bSOSS/feHgaAr8IEPmSpjFVwq1PIPzuj
	L3PJhPqwi1OSyIguqE7CJP48FKdQSwZwl1O8bm19RMGJ88c2/b1VTIHfFTB7kDJvVC+pe5kuKnhqB
	i3ArJgqg==;
Received: from [212.51.153.89] (helo=[192.168.12.42])
	by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <lorenz@dolansoft.org>)
	id 1pvIWb-000bkJ-0V;
	Sat, 06 May 2023 14:04:37 +0000
Date: Sat, 06 May 2023 16:04:31 +0200
From: Lorenz Brun <lorenz@brun.one>
Subject: Re: Quirks for exotic SFP module
To: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Message-Id: <JRP8UR.4LGGLMICAZ5S@brun.one>
In-Reply-To: <ZFZcL8LKkX3+GKMT@shell.armlinux.org.uk>
References: <C157UR.RELZCR5M9XI83@brun.one>
	<7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
	<CQF7UR.5191D6UPT6U8@brun.one>
	<d75c2138-76c6-49fe-96c3-39401f18b831@lunn.ch>
	<DVN7UR.QEVJPHB8FG6I1@brun.one>
	<8adbd20c-6de0-49ab-aabe-faf845d9a5d9@lunn.ch>
	<75Q7UR.PII4PI72J55K3@brun.one>
	<561dff8e-8a12-4f99-86e2-b5cdc8632d4a@lunn.ch>
	<ZFZcL8LKkX3+GKMT@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: lorenz@dolansoft.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Am Sa, 6. Mai 2023 um 14:54:55 +01:00:00 schrieb Russell King (Oracle) 
<linux@armlinux.org.uk>:
> It's not backwards at all. For a fibre link, 1000baseX is carried over
> the fibre, and it looks like this:
> 
> Host MAC <==> Host PCS <==1000baseX==> Remote PCS <==> Remote MAC
> 
> The host has no access to the remote PCS.
> 
> In your case:
> 
> Host MAC <==> Host PCS <==1000baseX==> AR8033 <==RGMII==> SoC
> 
> How is this any different? I would say the AR8033 is up to the SoC to
> manage itself. The fact that the SoC does something with the packets
> to them stuff them out to the rest of the world is neither here nor
> there. In the 1000base-X over fibre example above, the SoC could be
> something designed for routing applications inside a network switch/
> router.
> 
> Please don't get hung up on "there is a PHY on the module, I want
> access to it!" As you're not talking twisted-pair ethernet, you
> don't, there is nothing we need to control there.

That was my initial thought as well, Andrew told me to look for some 
interface to talk with a PHY.

> 
> The fact the module wants 1000base-X on its host interface is just
> what it wants - and that it specifies that it offers 1000base-T
> compliance is just the manufacturer being idiotic (as seems to be
> the case with a lot of SFPs.)
> 
> Just add a quirk removing the 1000base-T capability, setting
> 1000base-X in the supported mask, and also clear the
> PHY_INTERFACE_MODE_SGMII and set PHY_INTERFACE_MODE_1000BASEX in
> the interfaces mask.

Sounds good, I'll do that. Thanks for your help!

Regards,
Lorenz





