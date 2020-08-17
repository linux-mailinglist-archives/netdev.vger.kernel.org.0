Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D089247A75
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 00:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgHQWau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 18:30:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:53192 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgHQWat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 18:30:49 -0400
IronPort-SDR: n7MNRfn3rQyrf8u5gP/GkElab3uvt3c0lBMsMjrUpb2Baaf08H6+mKnwFD2KHW24HDb0ee0yFD
 DGLpNNmdCrlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="219119996"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="219119996"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 15:30:48 -0700
IronPort-SDR: 5AiadvX7J/BmKFR6UjgbtutRrvKoc4QuDhJqVZVkUa/61YaxJpBSkZHZTZAYDYTkwNBzIG80IB
 y5tPAQWZVxoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="496636081"
Received: from jcclancy-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.76.31])
  by fmsmga006.fm.intel.com with ESMTP; 17 Aug 2020 15:30:47 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ethtool enhancements for configuring IET Frame preemption
In-Reply-To: <b7f93fdb-4ad6-a744-056a-6ace37290a8c@ti.com>
References: <b7f93fdb-4ad6-a744-056a-6ace37290a8c@ti.com>
Date:   Mon, 17 Aug 2020 15:30:47 -0700
Message-ID: <87lficsy5k.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Murali,

I was finally able to go back to working on this, and should have
something for review when net-next opens.


Cheers,

Murali Karicheri <m-karicheri2@ti.com> writes:

> Hello Vinicius,
>
> Wondering what is your plan to add the support in ethtool to configure 
> IET frame preemption? Waiting for the next revision of the patch.
>
> Thanks and regards,
> -- 
> Murali Karicheri
> Texas Instruments

-- 
Vinicius
