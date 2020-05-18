Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2253F1D8A68
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgERWG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:06:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:14212 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgERWG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:06:28 -0400
IronPort-SDR: 37pa6w3jpgOWM+0qKQd9CAc94rvaIdzYrgvuSKlZM5pNYHdkxt0QfwXVZYfMvcvrC+u1WAjKqZ
 sqZRyHmIWigA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 15:06:27 -0700
IronPort-SDR: QRwHLMKXm6I8OfddQAqm1mS/rNcakTrgCj3y3343ax2JSY5S7SEJIbtJp+bneB01lmzqsTOFI8
 PGTAdqygyBig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="465908938"
Received: from melassa-mobl1.amr.corp.intel.com (HELO ellie) ([10.212.228.130])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2020 15:06:26 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, olteanv@gmail.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com, po.liu@nxp.com,
        m-karicheri2@ti.com, Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <20200518135613.379f6a63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516.133739.285740119627243211.davem@davemloft.net> <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com> <20200516.151932.575795129235955389.davem@davemloft.net> <87wo59oyhr.fsf@intel.com> <20200518135613.379f6a63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 18 May 2020 15:06:26 -0700
Message-ID: <87h7wcq4nx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Jakub Kicinski <kuba@kernel.org> writes:
>
> Please take a look at the example from the cover letter:
>
> $ ethtool $ sudo ./ethtool --show-frame-preemption
> enp3s0 Frame preemption settings for enp3s0:
> 	support: supported
> 	active: active
> 	supported queues: 0xf
> 	supported queues: 0xe
> 	minimum fragment size: 68
>
> Reading this I have no idea what 0xe is. I have to go and query TC API
> to see what priorities and queues that will be. Which IMHO is a strong
> argument that this information belongs there in the first place.

That was the (only?) strong argument in favor of having frame preemption
in the TC side when this was last discussed.

We can have a hybrid solution, we can move the express/preemptible per
queue map to mqprio/taprio/whatever. And have the more specific
configuration knobs, minimum fragment size, etc, in ethtool.

What do you think?


Cheers,
-- 
Vinicius
