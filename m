Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C60E1350E2
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgAIBJt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 20:09:49 -0500
Received: from mga17.intel.com ([192.55.52.151]:54097 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgAIBJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 20:09:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 17:09:48 -0800
X-IronPort-AV: E=Sophos;i="5.69,412,1571727600"; 
   d="scan'208";a="217661586"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.236])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 17:09:48 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <BN8PR12MB3266015708808170D71B17C6D33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com> <874kxxck0m.fsf@linux.intel.com> <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com> <157835635771.12437.5922951778370014410@aguedesl-mac01.jf.intel.com> <BN8PR12MB3266015708808170D71B17C6D33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
Subject: RE: [PATCH iproute2-next] taprio: Add support for the SetAndHold and SetAndRelease commands
From:   Andre Guedes <andre.guedes@linux.intel.com>
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Message-ID: <157853218801.36295.5868678705134050101@aguedesl-mac01.jf.intel.com>
User-Agent: alot/0.8.1
Date:   Wed, 08 Jan 2020 17:09:48 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

> > > On our IPs Queue 0 is by preemptible and all remaining ones are express 
> > > by default.
> > 
> > Is this configuration fixed in your IP or the user can control if a specific
> > queue is preemptible or express?
> 
> It's configurable for all Queues except 0 which is fixed as preemptible.

Thanks for the clarification.

> > I'm trying to figure out how this discussion relates to the Qbu discussion
> > we're having in "[v1,net-next, 1/2] ethtool: add setting frame preemption of
> > traffic classes".
> 
> Hmmm.
> 
> I think tc utility is the right way to do this, and not ethtool because 
> EST and FP are highly tied ... Do you agree ?

I'm still wrapping my head around this :) See my last reply on that other
thread. (BTW, let's concentrate this 'Qbu enabling' discussion there)

Thanks,

Andre
