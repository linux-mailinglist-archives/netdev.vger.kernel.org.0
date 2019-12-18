Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5D7125757
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfLRXEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:04:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:61556 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfLRXEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 18:04:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 15:04:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="417407896"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 18 Dec 2019 15:04:47 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next] taprio: Add support for the SetAndHold and SetAndRelease commands
In-Reply-To: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
Date:   Wed, 18 Dec 2019 15:05:13 -0800
Message-ID: <874kxxck0m.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

Jose Abreu <Jose.Abreu@synopsys.com> writes:

> Although this is already in kernel, currently the tool does not support
> them. We need these commands for full TSN features which are currently
> supported in Synopsys IPs such as QoS and XGMAC3.
>
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

This patch looks good in itself. 

However, I feel that this is incomplete. At least the way I understand
things, without specifying which traffic classes are going to be
preemptible (or it's dual concept, express), I don't see how this is
going to be used in practice. Or does the hardware have a default
configuration, that all traffic classes are preemptible, for example.

What am I missing here?


Cheers,
--
Vinicius
