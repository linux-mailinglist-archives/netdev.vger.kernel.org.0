Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14A27E37A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 21:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388721AbfHATsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:48:17 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:56704 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388609AbfHATsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 15:48:16 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: vh3SLtMYu6k4fqJwhEDyt9vB+HTFrRtUMMAYRXhLpZz/G5/KmnyRPtQ6KVry3TRiuG/YK8jJ6m
 Hmmubl6WlDk9ohCjUswhFHuMTZM87QrjuHgT5KK5bJp1D+97sKARTYHu8+7muTpHWb/lLDu5dk
 cPUxkt7wFbyTQQasCcHEtlXbNlEtnrRbwYD5p7ftCdqVf8b4S+EGJkr9Srwa+Mq+tkxTw52vru
 LvKk+ztTVLe8MhJ664jNcB16AfSCI9HzS0glqLH/PkY5H1hpzbcmhxuj5GHFJkkOa1WJdyNZyK
 gvs=
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="42100612"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Aug 2019 12:48:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 1 Aug 2019 12:48:07 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 1 Aug 2019 12:48:08 -0700
Date:   Thu, 1 Aug 2019 21:48:02 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>
CC:     <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <davem@davemloft.net>, <bridge@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <allan.nielsen@microchip.com>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190801194801.rqv5jvb5vxjo2dor@soft-dev3.microsemi.net>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <20190801151739.GB32290@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190801151739.GB32290@t480s.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vivien,

The 08/01/2019 15:17, Vivien Didelot wrote:
> External E-Mail
> 
> I'm a bit late in the conversation. Isn't this what you want?
> 
>     ip address add <multicast IPv4 address> dev br0 autojoin
> 

Not really, I was looking in a way to register the ports to link layer
multicast address. Sorry for the confusion, my description of the patch
was totally missleaning.

If you follow this thread you will get a better idea what we wanted to
achive. We got some really good comments and based on these we send a
RFC[1]. 

> 
> Thanks,
> Vivien

[1] https://patchwork.ozlabs.org/patch/1140468/

-- 
/Horatiu
