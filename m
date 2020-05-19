Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A541DA504
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgESWx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:53:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:50876 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgESWx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 18:53:27 -0400
IronPort-SDR: s0dL1/R3Us/h7F5pHcu2RdDnoLs/qr6TqirwE4lJdkwf2/00tr+jOspT1JX2miStniA5Eb9qGS
 5Oh+ppjglA/w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 15:53:26 -0700
IronPort-SDR: nKTbsCYzgP+JcScsxOxTpYh27usGUO8gRm2QO1LlWyhFrnpcIDYZPoG6OZy0u9psScbnkmfIMR
 KefAnvgTpBvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466307570"
Received: from stputhen-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.5.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 15:53:26 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Andre Guedes <andre.guedes@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <158992801438.36166.9692784713665851855@twxiong-mobl.amr.corp.intel.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516093317.GJ21714@lion.mk-sys.cz> <87sgfxox4x.fsf@intel.com> <158992801438.36166.9692784713665851855@twxiong-mobl.amr.corp.intel.com>
Date:   Tue, 19 May 2020 15:53:26 -0700
Message-ID: <875zcro7tl.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andre Guedes <andre.guedes@intel.com> writes:

>> >
>> >>      active: active
>> >>      supported queues: 0xf
>
> Following the same rationale, is this 'supported queue' going aways as well?
>

I think so, with good error messages, when trying to set an express-only
queue as preemptible, no need to expose this information.


-- 
Vinicius
