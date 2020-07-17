Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E41A224622
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 00:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgGQWFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 18:05:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:7980 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbgGQWFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 18:05:08 -0400
IronPort-SDR: zZsHE0MR7mlUFxfCy4AcNWdexRbx3ceDyRdISc49nhM5lYxE2b4c/AXR//QIrUvPDjShIGSqOb
 nPw99FIUuwxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="149672642"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="149672642"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 15:05:08 -0700
IronPort-SDR: aoSwOedjzN+h4QAfwehahZGErEBSzwcnY67T1+hWY1ak0veXEwxed0aPzRKBVjc5mil06a5GA9
 7CTzQYaWCBsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="460993570"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.94.160]) ([10.212.94.160])
  by orsmga005.jf.intel.com with ESMTP; 17 Jul 2020 15:05:07 -0700
Subject: Re: [PATCH net-next 1/3] docs: networking: timestamping: rename last
 section to "Known bugs".
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-2-olteanv@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ba9626e0-e82f-bf6c-25fc-856aedb2a8ec@intel.com>
Date:   Fri, 17 Jul 2020 15:05:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717161027.1408240-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
> One more quirk of the timestamping infrastructure will be documented
> shortly. Rename the section from "Other caveats for MAC drivers" to
> simply "Known bugs". This uncovers some bad phrasing at the beginning of
> the section, which is now corrected.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  Documentation/networking/timestamping.rst | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> index 5fa4e2274dd9..9a1f4cb4ce9e 100644
> --- a/Documentation/networking/timestamping.rst
> +++ b/Documentation/networking/timestamping.rst
> @@ -711,14 +711,14 @@ discoverable and attachable to a ``struct phy_device`` through Device Tree, and
>  for the rest, they use the same mii_ts infrastructure as those. See
>  Documentation/devicetree/bindings/ptp/timestamper.txt for more details.
>  
> -3.2.4 Other caveats for MAC drivers
> -^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> -
> -Stacked PHCs, especially DSA (but not only) - since that doesn't require any
> -modification to MAC drivers, so it is more difficult to ensure correctness of
> -all possible code paths - is that they uncover bugs which were impossible to
> -trigger before the existence of stacked PTP clocks.  One example has to do with
> -this line of code, already presented earlier::
> +3.2.4 Known bugs
> +^^^^^^^^^^^^^^^^
> +
> +One caveat with stacked PHCs, especially DSA (but not only) - since that
> +doesn't require any modification to MAC drivers, so it is more difficult to
> +ensure correctness of all possible code paths - is that they uncover bugs which
> +were impossible to trigger before the existence of stacked PTP clocks.
> +One example has to do with this line of code, already presented earlier::
>  

The interjection between - - is really long and made it difficult to
parse this statement. Maybe re-word it like

One caveat with stacked PHCs is that they uncover bugs which were
impossible to trigger otherwise, as it is more difficult to ensure
correctness of all possible code flows. This is especially true of DSA
since it does not require any modifications to the MAC drivers to setup.
One example has to do with this line of code, already presented earlier::


>        skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>  
> 
