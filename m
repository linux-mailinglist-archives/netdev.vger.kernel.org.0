Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74003131CB7
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 01:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgAGATT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Jan 2020 19:19:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:57935 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727025AbgAGATT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 19:19:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 16:19:18 -0800
X-IronPort-AV: E=Sophos;i="5.69,404,1571727600"; 
   d="scan'208";a="215360945"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.231])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 16:19:18 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com> <874kxxck0m.fsf@linux.intel.com> <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
From:   Andre Guedes <andre.guedes@linux.intel.com>
Subject: RE: [PATCH iproute2-next] taprio: Add support for the SetAndHold and SetAndRelease commands
Message-ID: <157835635771.12437.5922951778370014410@aguedesl-mac01.jf.intel.com>
User-Agent: alot/0.8.1
Date:   Mon, 06 Jan 2020 16:19:17 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

Quoting Jose Abreu (2019-12-18 15:08:45)
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Date: Dec/18/2019, 23:05:13 (UTC+00:00)
> 
> > However, I feel that this is incomplete. At least the way I understand
> > things, without specifying which traffic classes are going to be
> > preemptible (or it's dual concept, express), I don't see how this is
> > going to be used in practice. Or does the hardware have a default
> > configuration, that all traffic classes are preemptible, for example.
> > 
> > What am I missing here?
> 
> On our IPs Queue 0 is by preemptible and all remaining ones are express 
> by default.

Is this configuration fixed in your IP or the user can control if a specific
queue is preemptible or express?

I'm trying to figure out how this discussion relates to the Qbu discussion
we're having in "[v1,net-next, 1/2] ethtool: add setting frame preemption of
traffic classes".

Regards,

Andre
