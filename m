Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B736F170D00
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgB0AKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:10:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:65492 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgB0AKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 19:10:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 16:10:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,490,1574150400"; 
   d="scan'208";a="436836306"
Received: from tvtrimel-mobl2.amr.corp.intel.com ([10.251.11.94])
  by fmsmga005.fm.intel.com with ESMTP; 26 Feb 2020 16:10:05 -0800
Date:   Wed, 26 Feb 2020 16:10:05 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@tvtrimel-mobl2.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/7] mptcp: add work queue skeleton
In-Reply-To: <20200226091452.1116-3-fw@strlen.de>
Message-ID: <alpine.OSX.2.22.394.2002261609470.50710@tvtrimel-mobl2.amr.corp.intel.com>
References: <20200226091452.1116-1-fw@strlen.de> <20200226091452.1116-3-fw@strlen.de>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020, Florian Westphal wrote:

> From: Paolo Abeni <pabeni@redhat.com>
>
> Will be extended with functionality in followup patches.
> Initial user is moving skbs from subflows receive queue to
> the mptcp-level receive queue.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
