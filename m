Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF21465E69
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 07:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345295AbhLBGyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 01:54:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:43237 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230521AbhLBGx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 01:53:59 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="223869825"
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="223869825"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 22:50:37 -0800
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="512442638"
Received: from vidyasiv-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.65.229])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 22:50:36 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     roots@gmx.de, kuba@kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, stable@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH] igc: Avoid possible deadlock during suspend/resume
In-Reply-To: <YahqnvgmT63iG48E@kroah.com>
References: <87r1awtdx3.fsf@intel.com>
 <20211201185731.236130-1-vinicius.gomes@intel.com>
 <YahqnvgmT63iG48E@kroah.com>
Date:   Wed, 01 Dec 2021 22:50:36 -0800
Message-ID: <87ilw7ts8z.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Wed, Dec 01, 2021 at 10:57:31AM -0800, Vinicius Costa Gomes wrote:
>> Inspired by:
>> https://bugzilla.kernel.org/show_bug.cgi?id=215129
>> 
>
> This changelog does not say anything at all, sorry.  Please explain what
> is happening here as the kernel documentation asks you to.

It was intended as just some patch for the reporter to try while
narrowing the problem down. Sorry for the noise.

I should have thought about removing stable from CC.


Thank you,
-- 
Vinicius
