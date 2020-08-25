Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2370251EB5
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgHYR6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:58:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:41198 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgHYR6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 13:58:04 -0400
IronPort-SDR: u1h6fXqDlbKAQLDc0lXrJcSHhKdLew8GdeRx3+PxMtTbp/4OQRTrNimfFj7voCfqzjqBD4pScf
 k3z5xtavprWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="153746295"
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="153746295"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2020 10:58:04 -0700
IronPort-SDR: 2wBErFcwFqPKB8Ayi1BF8FUakWu9BuWS4+aKtavvEx0Y1g1tQRwI7Uf7W69wX1TaQrWCrkCLPF
 h+N/cppawE7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,353,1592895600"; 
   d="scan'208";a="499401862"
Received: from adent-mobl.amr.corp.intel.com (HELO ellie) ([10.209.77.195])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2020 10:58:03 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <875z9712qd.fsf@kurt>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200822143922.frjtog4mcyaegtyg@skbuf> <87imd8zi8z.fsf@kurt> <87y2m3txox.fsf@intel.com> <875z9712qd.fsf@kurt>
Date:   Tue, 25 Aug 2020 10:58:03 -0700
Message-ID: <878se2txp0.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

Kurt Kanzenbach <kurt@linutronix.de> writes:

> I think so. As Vladimir pointed out, the driver should setup an identity
> mapping which I already did by default.
>
> Can you point me your patch?

Just sent it for consideration:

http://patchwork.ozlabs.org/project/netdev/patch/20200825174404.2727633-1-vinicius.gomes@intel.com/


Cheers,
-- 
Vinicius
