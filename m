Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2226A13B370
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 21:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgANUKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 15:10:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:16977 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANUKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 15:10:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 12:10:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,320,1574150400"; 
   d="scan'208";a="256442291"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jan 2020 12:10:50 -0800
Subject: Re: [PATCH] devlink: fix typos in qed documentation
To:     netdev@vger.kernel.org
Cc:     Michal Kalderon <mkalderon@marvell.com>
References: <20200114200918.2753721-1-jacob.e.keller@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <a965462d-1451-34b0-4be0-902d0c096cbf@intel.com>
Date:   Tue, 14 Jan 2020 12:10:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200114200918.2753721-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/2020 12:09 PM, Jacob Keller wrote:
> Review of the recently added documentation file for the qed driver
> noticed a couple of typos. Fix them now.
> 
> Noticed-by: Michal Kalderon <mkalderon@marvell.com>
> Fixes: 0f261c3ca09e ("devlink: add a driver-specific file for the qed driver")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

This fixes some typos in the recently merged devlink documentation
refactor patches on net-next.

Thanks,
Jake

> ---
>  Documentation/networking/devlink/qed.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/devlink/qed.rst b/Documentation/networking/devlink/qed.rst
> index e7e17acf1eca..805c6f63621a 100644
> --- a/Documentation/networking/devlink/qed.rst
> +++ b/Documentation/networking/devlink/qed.rst
> @@ -22,5 +22,5 @@ The ``qed`` driver implements the following driver-specific parameters.
>     * - ``iwarp_cmt``
>       - Boolean
>       - runtime
> -     - Enable iWARP functionality for 100g devices. Notee that this impacts
> -       L2 performance, and is therefor not enabled by default.
> +     - Enable iWARP functionality for 100g devices. Note that this impacts
> +       L2 performance, and is therefore not enabled by default.
> 
