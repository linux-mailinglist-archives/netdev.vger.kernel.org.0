Return-Path: <netdev+bounces-3255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 159FE7063EA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 057CB1C20E8C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BABE1078E;
	Wed, 17 May 2023 09:17:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD925249
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:17:31 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196F010E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:17:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684315042; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=DsRGPKWyAsj3g2Bgw+8ARI+KngZPicAK4BKCY9p9kexZiVIOx5pDfOSp+bZSTtgAftixVKQdom/vg4Zq0t0o8li49C6ZNx8TJjZIgwQJBDBLJeffj4jl+zHsVX5YT8kkzEBohGILiqkLNZ2sLnL0C+QdBXblbmPB2qtbe2mvvfs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684315042; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=itmwCZwJdlHwx661qimDTtPlPB0TzAqWaq8mnUNnCrI=; 
	b=lwzf7VsMXEO19cbIscQnhOj72jbwlohQNna3ELSSwIJKNUgZ+kahnvxjizV9p6s/PFBM6JNPs/ThVpB1LQRcYLZPIotmmvoP6B9MdPWoJAScMAYJTCseVRdJp5FsoEL0A/8yyPp6pljKCpehAHjNQTJXk2JixcImkVeIa9FgAec=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684315042;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=itmwCZwJdlHwx661qimDTtPlPB0TzAqWaq8mnUNnCrI=;
	b=SFWCeVrz44mdffH0HJ8cnso6fQR81iGgytWT3MLbG4KyVklKczkQXYRbj0OSMLOy
	55sl/yd8edHfTAXqyUHeYs7VO/yhWJth4Mj6zJ7Eccoxh0OPnkMIsUnuD2cNAFnVUyE
	y/XCEkvUza8nzOcZtBCvpb0xM7YdvPq01r0oI8KU=
Received: from [10.10.10.122] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684315041488489.4503157826275; Wed, 17 May 2023 02:17:21 -0700 (PDT)
Message-ID: <42ca00bc-ac73-dc95-044f-9f1f8d74212a@arinc9.com>
Date: Wed, 17 May 2023 12:17:14 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Net related kernel panic caused by commit in
 next-20230512..next-20230515
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev <netdev@vger.kernel.org>, Daniel Golle <daniel@makrotopia.org>
References: <58e55189-51b5-83c9-356c-90a20200cd01@arinc9.com>
 <20230516203836.3ccfc734@kernel.org>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230516203836.3ccfc734@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17.05.2023 06:38, Jakub Kicinski wrote:
> On Tue, 16 May 2023 17:42:44 +0300 Arınç ÜNAL wrote:
>> I get a kernel panic on next-20230515 and next-20230516. next-20230512
>> works fine. The panic log is attached.
>>
>> The device boots fine with CONFIG_NET disabled which made me think the
>> netdev mailing list is the best place to report this.
>>
>> Tested on Bananapi BPI-R64 with this defconfig. The filesystem is
>> Buildroot. The devicetree binary being fed to the bootloader is from
>> next-20230515.
>>
>> https://github.com/arinc9/linux/commit/b4a048428ab6f380b4203598aa62635e21015095
> 
> Should be now fixed in net/main, by commit d6352dae0903 ("devlink: Fix
> crash with CONFIG_NET_NS=n")

I can confirm this commit fixes it, thanks.

Arınç

