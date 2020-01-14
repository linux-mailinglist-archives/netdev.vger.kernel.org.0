Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B3613AFE0
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgANQrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:47:15 -0500
Received: from mga04.intel.com ([192.55.52.120]:19189 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbgANQrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 11:47:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 08:47:14 -0800
X-IronPort-AV: E=Sophos;i="5.70,433,1574150400"; 
   d="scan'208";a="213390392"
Received: from jmanteyx-desk.jf.intel.com ([10.54.51.75])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 Jan 2020 08:47:13 -0800
Subject: Re: [PATCH] Propagate NCSI channel carrier loss/gain events to the
 kernel
To:     samjonas <sam@mendozajonas.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <b2ef76f2-cf4e-3d14-7436-8c66e63776ba@intel.com>
 <20b75baf4fa6781278614162b05918dcdedd2e29.camel@mendozajonas.com>
From:   Johnathan Mantey <johnathanx.mantey@intel.com>
Autocrypt: addr=johnathanx.mantey@intel.com; prefer-encrypt=mutual; keydata=
 mQENBFija08BCAC60TO2X22b0tJ2Gy2iQLWx20mGcD7ugBpm1o2IW2M+um3GR0BG/bUcLciw
 dEnX9SWT30jx8TimenyUYeDS1CKML/e4JnCAUhSktNZRPBjzla991OkpqtFJEHj/pHrXTsz0
 ODhmnSaZ49TsY+5BqtRMexICYOtSP8+xuftPN7g2pQNFi7xYlQkutP8WKIY3TacW/6MPiYek
 pqVaaF0cXynCMDvbK0km7m0S4X01RZFKXUwlbuMireNk4IyZ/59hN+fh1MYMQ6RXOgmHqxSu
 04GjkbBLf2Sddplb6KzPMRWPJ5uNdvlkAfyT4P0R5EfkV5wCRdoJ1lNC9WI1bqHkbt07ABEB
 AAG0JUpvaG5hdGhhbiBNYW50ZXkgPG1hbnRleWpnQGdtYWlsLmNvbT6JATcEEwEIACEFAlij
 a08CGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ0EfviT3fHwmcBAgAkENzQ8s0RK+f
 nr4UogrCBS132lDdtlOypm1WgGDOVQNra7A1rvXFgN05RqrdRTpRevv7+S8ipbiG/kxn9P8+
 VhhW1SvUT8Tvkb9YYHos6za3v0YblibFNbYRgQcybYMeKz2/DcVU+ioKZ1SxNJsFXx6wH71I
 V2YumQRHAsh4Je6CmsiMVP4XNadzCQXzzcU9sstKV0A194JM/d8hjXfwMHZE6qnKgAkHIV3Q
 61YCuvkdr5SJSrOVo2IMN0pVxhhW7lqCAGBGb4oOhqePwGqOabU3Ui4qTbHP2BWP5UscehkK
 6TVKcpYApsUcWyxvvOARoktmlPnGYqJPnRwXpQBlqLkBDQRYo2tPAQgAyOv5Lgg2VkHO84R7
 LJJDBxcaCDjyAvHBynznEEk11JHrPuonEWi6pqgB8+Kc588/GerXZqJ9AMkR43UW/5cPlyF2
 wVO4aYaQwryDtiXEu+5rpbQfAvBpKTbrBfYIPc8thuAC2kdB4IO24T6PVSYVXYc/giOL0Iwb
 /WZfMd5ajtKfa727xfbKCEHlzakqmUl0SyrARdrSynhX1R9Wnf2BwtUV7mxFxtMukak0zdTf
 2IXZXDltZC224vWqkXiI7Gt/FDc2y6gcsYY/4a2+vjhWuZk3lEzP0pbXQqOseDM1zZXln/m7
 BFbJ6VUn1zWcrt0c82GTMqkeGUheUhDiYLQ7xwARAQABiQEfBBgBCAAJBQJYo2tPAhsMAAoJ
 ENBH74k93x8JKEUH/3UPZryjmM0F3h8I0ZWuruxAxiqvksLOOtarU6RikIAHhwjvluEcTH4E
 JsDjqtRUvBMU907XNotpqpW2e9jN8tFRyR4wW9CYkilB02qgrDm9DXVGb2BDtC/MY+6KUgsG
 k5Ftr9uaXNd0K4IGRJSyU6ZZn0inTcXlqD+NgOE2eX9qpeKEhDufgF7fKHbKDkS4hj6Z09dT
 Y8eW9d6d2Yf/RzTBJvZxjBFbIgeUGeykbSKztp2OBe6mecpVPhKooTq+X/mJehpRA6mAhuQZ
 28lvie7hbRFjqR3JB7inAKL4eT1/9bT/MqcPh43PXTAzB6/Iclg5B7GGgEFe27VL0hyqiqc=
Message-ID: <54db4c95-44a1-da74-a6d4-21d591926dbd@intel.com>
Date:   Tue, 14 Jan 2020 08:47:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20b75baf4fa6781278614162b05918dcdedd2e29.camel@mendozajonas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sam,

This code is working on a channel that is completely configured.  This
code is covering a situation where the RJ45 cable is intentionally or
mistakenly removed from a system. In the event that the network cable is
removed/damaged/slips, the kernel needs to change state to show that
network interface no longer has a link.  For my employers use case the
loss of carrier is then added to a log of system state changes. Thus for
each internal channel there needs to be a way to report that the channel
has/does not have a link carrier.

On 1/13/20 4:43 PM, samjonas wrote:
> On Fri, 2020-01-10 at 14:02 -0800, Johnathan Mantey wrote:
>> From 76d99782ec897b010ba507895d60d27dca8dca44 Mon Sep 17 00:00:00
>> 2001
>> From: Johnathan Mantey <johnathanx.mantey@intel.com>
>> Date: Fri, 10 Jan 2020 12:46:17 -0800
>> Subject: [PATCH] Propagate NCSI channel carrier loss/gain events to
>> the
>> kernel
>>
>> Problem statement:
>> Insertion or removal of a network cable attached to a NCSI controlled
>> network channel does not notify the kernel of the loss/gain of the
>> network link.
>>
>> The expectation is that /sys/class/net/eth(x)/carrier will change
>> state after a pull/insertion event. In addition the carrier_up_count
>> and carrier_down_count files should increment.
>>
>> Change statement:
>> Use the NCSI Asynchronous Event Notification handler to detect a
>> change in a NCSI link.
>> Add code to propagate carrier on/off state to the network interface.
>> The on/off state is only modified after the existing code identifies
>> if the network device HAD or HAS a link state change.
> 
> If we set the carrier state off until we successfully configured a
> channel could we avoid this limitation?
> 
> Cheers,
> Sam
> 
>>
>> Test procedure:
>> Connected a L2 switch with only two ports connected.
>> One port was a DHCP corporate net, the other port attached to the
>> NCSI
>> controlled NIC.
>>
>> Starting with the L2 switch with DC on, check to make sure the NCSI
>> link is operating.
>> cat /sys/class/net/eth1/carrier
>> 1
>> cat /sys/class/net/eth1/carrier_up_count
>> 0
>> cat /sys/class/net/eth1/carrier_down_count
>> 0
>>
>> Remove DC from the L2 switch, and check link state
>> cat /sys/class/net/eth1/carrier
>> 0
>> cat /sys/class/net/eth1/carrier_up_count
>> 0
>> cat /sys/class/net/eth1/carrier_down_count
>> 1
>>
>> Restore DC to the L2 switch, and check link state
>> cat /sys/class/net/eth1/carrier
>> 1
>> cat /sys/class/net/eth1/carrier_up_count
>> 1
>> cat /sys/class/net/eth1/carrier_down_count
>> 1
>>
>> Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
>> ---
>>  net/ncsi/ncsi-aen.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
>> index b635c194f0a8..274c415dcead 100644
>> --- a/net/ncsi/ncsi-aen.c
>> +++ b/net/ncsi/ncsi-aen.c
>> @@ -89,6 +89,12 @@ static int ncsi_aen_handler_lsc(struct
>> ncsi_dev_priv
>> *ndp,
>>      if ((had_link == has_link) || chained)
>>          return 0;
>>  
>> +    if (had_link) {
>> +        netif_carrier_off(ndp->ndev.dev);
>> +    } else {
>> +        netif_carrier_on(ndp->ndev.dev);
>> +    }
>> +
>>      if (!ndp->multi_package && !nc->package->multi_channel) {
>>          if (had_link) {
>>              ndp->flags |= NCSI_DEV_RESHUFFLE;
> 

-- 
Johnathan Mantey
Senior Software Engineer
*azad technology partners*
Contributing to Technology Innovation since 1992
Phone: (503) 712-6764
Email: johnathanx.mantey@intel.com <mailto:johnathanx.mantey@intel.com>

