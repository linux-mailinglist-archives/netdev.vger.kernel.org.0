Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34769E5673
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfJYWYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:24:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:61612 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfJYWYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 18:24:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 15:24:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,230,1569308400"; 
   d="scan'208";a="400249052"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 25 Oct 2019 15:24:53 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at net/sched/sch_generic.c:448
In-Reply-To: <20191024204134.egc5mdtz2o2tsxyz@linux-p48b>
References: <20191024032105.xmewznsphltnrido@linux-p48b> <87mudpylcc.fsf@linux.intel.com> <20191024204134.egc5mdtz2o2tsxyz@linux-p48b>
Date:   Fri, 25 Oct 2019 15:26:06 -0700
Message-ID: <875zkcxy0x.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Davidlohr Bueso <dave@stgolabs.net> writes:

> I am able to trigger this a few seconds into running pi_stress (from
> rt-tests, quite a non network workload). But this is not the only one.
> I'm going through some logs to see what other test is triggering it.

Looking at the at the caveats section of pi_stress(8), this is expected:

"The pi_stress test threads run as SCHED_FIFO or SCHED_RR threads, which
means that they can starve critical system threads. It is advisable to
change the scheduling policy of critical system threads to be SCHED_FIFO
prior to running pi_stress and use a priority of 10 or higher, to
prevent those threads from being starved by the stress test."

Are the other workloads similar to pi_stress?


Cheers,
--
Vinicius


