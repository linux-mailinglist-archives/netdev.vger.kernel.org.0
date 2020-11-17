Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54D12B6DFA
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgKQTAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:00:45 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:55105 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgKQTAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605639643; x=1637175643;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uJGo6j8ljzoyAXtuqCtiWI7gZtN1UjVC/lwvJf0+CrE=;
  b=jyEpGExGLrxrCeWlSub5hZStpLLfucObUPzH0eYr91BJyrNwH7EqwTp4
   /2ChQ6/aqKB/ckxN3Q7zB/o8nL4nOPCrWDSt+gFNux56SlDB64IH3j65+
   gtqAMjOqL84zPK/EB3iSL820RtdaOnnjLShaCRtVRmrpps1shcGLs3KqS
   hvNqsUdc1qKRg0JnZkjjl50gsndiLrUWImwgQxU+OuuWa7T0wuIdTYV9a
   ErrsDeU9RqhxBokADAhrpjsCyJIlfTqjuBSKdL5XnKu8jt27+t5OwvTKQ
   BYwiruDSYUQbkyEAEYT/rmYKFrbk35pLGe01+P2DHuYEhKggs+D7GMJRO
   A==;
IronPort-SDR: wq5GUw4ZcCdWfdFbnT+sTxxoOtlAtdlJ3i488p4VgXIX82brdwCzyRFxJAm0BmPrcgq55k9PQK
 fi8hilKi43EKoV3ZzqIyxBksIoZLOsMi0va4REXx5XUKpQWo4TM437C7v27095HvY/FHOxwdUK
 quDPxconGD/+CUBqHDdRF9HkVQzg5dzjjsq46SQYqF+wCeU/J7aRpQ0/jrb2wXMmrUzoWz864Q
 0/ZspERyU+2JEKChag6ggk+WRasQbSYw9UeKWk8eHP6jeVnWPnjCypXGwWqOkkFZHFUGkNKG9Z
 AJU=
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="96659063"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2020 12:00:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 12:00:42 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 17 Nov 2020 12:00:42 -0700
Date:   Tue, 17 Nov 2020 20:00:41 +0100
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Arvid.Brodin@xdin.com>,
        <m-karicheri2@ti.com>, <vinicius.gomes@intel.com>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <saeedm@mellanox.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <ivan.khoronzhuk@linaro.org>, <andre.guedes@linux.intel.com>,
        <allan.nielsen@microchip.com>, <po.liu@nxp.com>,
        <mingkai.hu@nxp.com>, <claudiu.manoil@nxp.com>,
        <vladimir.oltean@nxp.com>, <leoyang.li@nxp.com>
Subject: Re: [RFC, net-next] net: qos: introduce a redundancy flow action
Message-ID: <20201117190041.dejmwpi4kvgrcotj@soft-dev16>
References: <20201117063013.37433-1-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201117063013.37433-1-xiaoliang.yang_1@nxp.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/17/2020 14:30, Xiaoliang Yang wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> This patch introduce a redundancy flow action to implement frame
> replication and elimination for reliability, which is defined in
> IEEE P802.1CB.
> 
> There are two modes for redundancy action: generator and recover mode.
> Generator mode add redundancy tag and replicate the frame to different
> egress ports. Recover mode drop the repeat frames and remove redundancy
> tag from the frame.
> 
> Below is the setting example in user space:
>         > tc qdisc add dev swp0 clsact
>         > tc filter add dev swp0 ingress protocol 802.1Q flower \
>                 skip_hw dst_mac 00:01:02:03:04:05 vlan_id 1 \
>                 action redundancy generator split dev swp1 dev swp2
> 
>         > tc filter add dev swp0 ingress protocol 802.1Q flower
>                 skip_hw dst_mac 00:01:02:03:04:06 vlan_id 1 \
>                 action redundancy recover
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Hi Xiaoliang,

I like your idea about using filter actions for FRER configuration.

I think this is a good starting point but I think that this approach will only
allow us to configure end systems and not relay systems in bridges/switches.

In the following I refer to sections and figures in 802.1CB-2017.

I am missing the following possibilities:
Configure split without adding an r-tag (Figure C-4 Relay system C).
Configure recovery without popping the r-tag (Figure C4 Relay system F).
Disable flooding and learning per VLAN (Section C.7).
Select between vector and match recovery algorithm (Section 7.4.3.4 and 7.4.3.5).
Configure history length if vector algorithm is used (Section 10.4.1.6).
Configure reset timeout (Section 10.4.1.7).
Adding an individual recovery function (Section 7.5).
Counters to be used for latent error detection (Section 7.4.4).

I would prefer to use the term 'frer' instead of 'red' or 'redundancy'
in all definitions and functions except for 'redundancy-tag'.
-- 
Joergen Andreasen, Microchip
