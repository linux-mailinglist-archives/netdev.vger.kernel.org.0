Return-Path: <netdev+bounces-2411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4BFD701C4A
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 10:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B1D628154D
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 08:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 538411FAB;
	Sun, 14 May 2023 08:15:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47910ED1
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 08:15:10 +0000 (UTC)
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 01:15:07 PDT
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66002125;
	Sun, 14 May 2023 01:15:07 -0700 (PDT)
Received: by air.basealt.ru (Postfix, from userid 490)
	id 7251D2F20227; Sun, 14 May 2023 07:59:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
Received: from [192.168.120.181] (unknown [176.59.56.94])
	by air.basealt.ru (Postfix) with ESMTPSA id 52EE52F20226;
	Sun, 14 May 2023 07:59:46 +0000 (UTC)
Message-ID: <6894e9f7-7100-255b-b026-5ccf485a7e31@basealt.ru>
Date: Sun, 14 May 2023 10:59:44 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] e1000e: Fix bind network card with ID = 0x0D4F
To: "Neftin, Sasha" <sasha.neftin@intel.com>, kovalev@altlinux.org,
 nickel@altlinux.org, jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 davem@davemloft.net, kuba@kernel.org, jeffrey.t.kirsher@intel.com,
 intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
 "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
 "naamax.meir" <naamax.meir@linux.intel.com>
References: <20230512231944.100501-1-kovalev@altlinux.org>
 <c9ef1c57-3ec5-5cf8-c025-63527280f2fa@intel.com>
Content-Language: en-US
From: =?UTF-8?B?0JLQsNGB0LjQu9C40Lkg0JrQvtCy0LDQu9C10LI=?=
 <kovalevvv@basealt.ru>
In-Reply-To: <c9ef1c57-3ec5-5cf8-c025-63527280f2fa@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

14.05.2023 09:00, Neftin, Sasha пишет:
>> Fixes: 914ee9c436cbe9 ("e1000e: Add support for Comet Lake")
>> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
>> ---
>>   drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c 
>> b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index db8e06157da29..8b13f19309c39 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -7887,7 +7887,7 @@ static const struct pci_device_id 
>> e1000_pci_tbl[] = {
>>       { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_LM9), 
>> board_pch_cnp },
>>       { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ICP_I219_V9), 
>> board_pch_cnp },
>>       { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM10), 
>> board_pch_cnp },
>> -    { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V10), 
>> board_pch_cnp },
>> +    { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V10), 
>> board_pch_adp },
> This is wrong approach. (we can not process old board similar as new)
>>       { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM11), 
>> board_pch_cnp },
>>       { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_V11), 
>> board_pch_cnp },
>>       { PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_CMP_I219_LM12), 
>> board_pch_spt },
> Looking in commit 639e298f432fb0 (e1000e: Fix packet loss on Tiger 
> Lake and later) I would suggest to replace the mac->type as follow:
> "if (mac->type >= e1000_pch_tgp)" with "if (mac->type >= 
> e1000_pch_cnp)" (more correct) - try it on your side.

I checked this variant first of all - the behavior is correct, network 
packets are not lost. Can I prepare a new patch or will this change be 
made by you?

-- 
Best regards,
Vasiliy Kovalev


