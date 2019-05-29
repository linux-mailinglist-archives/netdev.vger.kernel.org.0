Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D14B2D31A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfE2BMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:12:41 -0400
Received: from icp-osb-irony-out9.external.iinet.net.au ([203.59.1.226]:32503
        "EHLO icp-osb-irony-out9.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfE2BMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:12:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AWAABg2+1c/zXSMGcNWBoBAQEBAQI?=
 =?us-ascii?q?BAQEBBwIBAQEBgVQCAQEBAQsBiDiTXwEBAQEBAQaBECWDX4VwhHKMEwkBAQE?=
 =?us-ascii?q?BAQEBAQE3AQEBhD8CgwY3Bg4BAwEBAQQBAQEBAwGGYAEBAQMjFUEQCw0LAgI?=
 =?us-ascii?q?mAgJXBg0IAQGDHoF3qFJxgS8ahS2DLoFGgQwoAYFgigl4gQeBOAyCXz6HToJ?=
 =?us-ascii?q?YBJNdhzONQwmCD5MPBhuCD4pjA4lUpHOBeTMaCCgIgyiCRY4ekA4BAQ?=
X-IPAS-Result: =?us-ascii?q?A2AWAABg2+1c/zXSMGcNWBoBAQEBAQIBAQEBBwIBAQEBg?=
 =?us-ascii?q?VQCAQEBAQsBiDiTXwEBAQEBAQaBECWDX4VwhHKMEwkBAQEBAQEBAQE3AQEBh?=
 =?us-ascii?q?D8CgwY3Bg4BAwEBAQQBAQEBAwGGYAEBAQMjFUEQCw0LAgImAgJXBg0IAQGDH?=
 =?us-ascii?q?oF3qFJxgS8ahS2DLoFGgQwoAYFgigl4gQeBOAyCXz6HToJYBJNdhzONQwmCD?=
 =?us-ascii?q?5MPBhuCD4pjA4lUpHOBeTMaCCgIgyiCRY4ekA4BAQ?=
X-IronPort-AV: E=Sophos;i="5.60,525,1549900800"; 
   d="scan'208";a="168740541"
Received: from unknown (HELO [10.44.0.22]) ([103.48.210.53])
  by icp-osb-irony-out9.iinet.net.au with ESMTP; 29 May 2019 09:12:35 +0800
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Set correct interface mode for
 CPU/DSA ports
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e27eeebb-44fb-ae42-d43d-b42b47510f76@kernel.org>
 <20190524134412.GE2979@lunn.ch>
 <f83b9083-4f2e-5520-b452-e11667c5c1cd@kernel.org>
 <20190528131705.GB18059@lunn.ch>
From:   Greg Ungerer <gerg@kernel.org>
Message-ID: <e7011587-8b09-acec-8640-96a34d20219a@kernel.org>
Date:   Wed, 29 May 2019 11:12:34 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528131705.GB18059@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 28/5/19 11:17 pm, Andrew Lunn wrote:
>> My hardware has the CPU port on 9, and it is SGMII. The existing working
>> devicetree setup I used is:
>>
>>                         port@9 {
>>                                  reg = <9>;
>>                                  label = "cpu";
>>                                  ethernet = <&eth0>;
>>                                  fixed-link {
>>                                          speed = <1000>;
>>                                          full-duplex;
>>                                  };
>>                          };
> 
> Hi Greg
> 
> You might need to set the phy-mode to SGMII. I'm surprised you are
> using SGMII, not 1000Base-X. Do you have a PHY connected?

No, no PHY connected. Direct Armada 380 to 6390 switch with SGMII.

Adding

   phy-mode = "sgmii";

to that port fixes it.

Thanks!
Greg
