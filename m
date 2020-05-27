Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E401E51CB
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgE0X2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:28:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:5300 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE0X2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 19:28:17 -0400
IronPort-SDR: 86b2vKlgJpBy7nFXMF2ZtIcz82i47YQmpRMq2BY+OS6zNjfYV9xn4xGQW5g2Qiobu7V+IouFmk
 XFaBXWi0r0RA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 16:28:17 -0700
IronPort-SDR: ymWlNhG63YMw460FI2bhH3CSGRN0fjZDHCO10avwA3is357mE41AFiDVBZAN9wsL/9moOXXoK9
 tOpF6kFiZrgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="468921730"
Received: from unknown (HELO ellie) ([10.212.136.193])
  by fmsmga006.fm.intel.com with ESMTP; 27 May 2020 16:28:17 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: offload the Credit-Based Shaper qdisc
In-Reply-To: <20200527203850.1354202-1-olteanv@gmail.com>
References: <20200527203850.1354202-1-olteanv@gmail.com>
Date:   Wed, 27 May 2020 16:28:17 -0700
Message-ID: <87eer5j6um.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> SJA1105, being AVB/TSN switches, provide hardware assist for the
> Credit-Based Shaper as described in the IEEE 8021Q-2018 document.
>
> First generation has 10 shapers, freely assignable to any of the 4
> external ports and 8 traffic classes, and second generation has 16
> shapers.
>
> We also need to provide a dummy implementation of mqprio qdisc offload,
> since this seems to be necessary for shaping any traffic class other
> than zero.

This is false, right?


Cheers,
-- 
Vinicius
