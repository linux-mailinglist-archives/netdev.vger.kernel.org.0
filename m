Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3435BA5C06
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 20:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfIBSFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 14:05:25 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:5236 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfIBSFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 14:05:25 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: HER/O+P4nrAcLTa8XXysI/HXmsgFV0NarfvE+VbTxBhYBwO5Sgb7n3E3j6NWhNqmaUKTlx6ZWl
 EZ/54vKM4oBkyj6ECZ0HMRpWM9yoQcZLQRL/6WsnIKrxDdIrwPQjOGhyy5AXdhlo4dpJfPTOau
 pSoilXhn5muEODXKK/8eErgOjIJ1j5MzvYv1Q5u8YhOo07N47eL6Sn1qwN6WQVGz91i67Ne0xU
 /XBZsWd+HwqgeRz3Wq1vNTCKX0HELhNeMqa7MjotkyeGw+YKicsNae5a+OQwkS+ZQACIX7vFaJ
 IDk=
X-IronPort-AV: E=Sophos;i="5.64,460,1559545200"; 
   d="scan'208";a="47512522"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2019 11:05:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 2 Sep 2019 11:05:21 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 2 Sep 2019 11:05:20 -0700
Date:   Mon, 2 Sep 2019 20:05:20 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     David Miller <davem@davemloft.net>, <idosch@idosch.org>,
        <andrew@lunn.ch>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <ivecera@redhat.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190902180519.ytbs6x2dx5z23hys@lx-anielsen.microsemi.net>
References: <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830053940.GL2312@nanopsycho>
 <20190829.230233.287975311556641534.davem@davemloft.net>
 <20190830063624.GN2312@nanopsycho>
 <20190902174229.uur7r7duq4dvbnqq@lx-anielsen.microsemi.net>
 <20190902175124.GA2312@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190902175124.GA2312@nanopsycho>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/02/2019 19:51, Jiri Pirko wrote:
> External E-Mail
> 
> 
> Mon, Sep 02, 2019 at 07:42:31PM CEST, allan.nielsen@microchip.com wrote:
> >Hi Jiri,
> >
> >Sorry for joining the discussion this late, but I have been without mail access
> >for the last few days.
> >
> >
> >The 08/30/2019 08:36, Jiri Pirko wrote:
> >> Fri, Aug 30, 2019 at 08:02:33AM CEST, davem@davemloft.net wrote:
> >> >From: Jiri Pirko <jiri@resnulli.us>
> >> >Date: Fri, 30 Aug 2019 07:39:40 +0200
> >> >
> >> >> Because the "promisc mode" would gain another meaning. Now how the
> >> >> driver should guess which meaning the user ment when he setted it?
> >> >> filter or trap?
> >> >> 
> >> >> That is very confusing. If the flag is the way to do this, let's
> >> >> introduce another flag, like IFF_TRAPPING indicating that user wants
> >> >> exactly this.
> >> >
> >> >I don't understand how the meaning of promiscuous mode for a
> >> >networking device has suddenly become ambiguous, when did this start
> >> >happening?
> >> 
> >> The promiscuity is a way to setup the rx filter. So promics == rx filter
> >> off. For normal nics, where there is no hw fwd datapath,
> >> this coincidentally means all received packets go to cpu.
> >> But if there is hw fwd datapath, rx filter is still off, all rxed packets
> >> are processed. But that does not mean they should be trapped to cpu.
> >> 
> >> Simple example:
> >> I need to see slowpath packets, for example arps/stp/bgp/... that
> >> are going to cpu, I do:
> >> tcpdump -i swp1
> >
> >How is this different from "tcpdump -p -i swp1"
> >
> >> I don't want to get all the traffic running over hw running this cmd.
> >> This is a valid usecase.
> >> 
> >> To cope with hw fwd datapath devices, I believe that tcpdump has to have
> >> notion of that. Something like:
> >> 
> >> tcpdump -i swp1 --hw-trapping-mode
> >> 
> >> The logic can be inverse:
> >> tcpdump -i swp1
> >> tcpdump -i swp1 --no-hw-trapping-mode
> >> 
> >> However, that would provide inconsistent behaviour between existing and
> >> patched tcpdump/kernel.
> >> 
> >> All I'm trying to say, there are 2 flags
> >> needed (if we don't use tc trap).
> >
> >I have been reading through this thread several times and I still do not get it.
> >
> >As far as I understand you are arguing that we need 3 modes:
> >
> >- tcpdump -i swp1
> 
> Depends on default. Promisc is on.
> 
> 
> >- tcpdump -p -i swp1
> 
> All traffic that is trapped to the cpu by default, not promisc means
> only mac of the interface (if bridge for example haven't set promisc
> already) and special macs. So host traffic (ip of host), bgp, arp, nsnd,
> etc.

In the case where the interface is enslaved to a bridge, it is put into promisc
mode, which means that "tcpdump -i swp1" and "tcpdump -p -i swp1" give the same
result, right?

Is this desirable?

> >- tcpdump -i swp1 --hw-trapping-mode
> 
> Promisc is on, all traffic received on the port and pushed to cpu. User
> has to be careful because in case of mlxsw this can lead to couple
> hundred gigabit traffic going over limited pci bandwidth (gigabits).
> 
> 
> >
> >Would you mind provide an example of the traffic you want to see in the 3 cases
> >(or the traffic which you do not want to see).
> >
> >/Allan
> >
> 

-- 
/Allan
