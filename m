Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1814D272
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 22:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgA2VZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 16:25:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:32545 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgA2VZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 16:25:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 13:25:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="223948146"
Received: from cmossx-mobl1.amr.corp.intel.com ([10.251.7.89])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jan 2020 13:25:35 -0800
Date:   Wed, 29 Jan 2020 13:25:35 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@cmossx-mobl1.amr.corp.intel.com
To:     netdev@vger.kernel.org
cc:     mptcp@lists.01.org, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH net] Revert "MAINTAINERS: mptcp@ mailing list is
 moderated"
In-Reply-To: <20200129174137.22948-1-mathew.j.martineau@linux.intel.com>
Message-ID: <alpine.OSX.2.21.2001291321500.9282@cmossx-mobl1.amr.corp.intel.com>
References: <20200129174137.22948-1-mathew.j.martineau@linux.intel.com>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 29 Jan 2020, Mat Martineau wrote:

> This reverts commit 74759e1693311a8d1441de836c4080c192374238.
>
> mptcp@lists.01.org accepts messages from non-subscribers. There was an
> invisible and unexpected server-wide rule limiting the number of
> recipients for subscribers and non-subscribers alike, and that has now
> been turned off for this list.

Apparently the "bypass other rules" setting doesn't bypass this particular 
rule, as one of my own messages just got held up. I'll get it fixed.

--
Mat Martineau
Intel
