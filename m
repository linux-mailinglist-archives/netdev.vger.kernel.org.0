Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6C28D65C
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 00:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgJMWBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 18:01:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:7401 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgJMWBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 18:01:09 -0400
IronPort-SDR: Bd2LgM3qlBnb2yfx7G5pdhT3MlLSWjI4jlepT9+M42ImGREnpLisNTehcvMe/QPASsrehAb0i4
 4GVhp/nVfW5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="250686415"
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="250686415"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 15:01:09 -0700
IronPort-SDR: ToVhdH2VAtIHbB7hGPVNvyPLfEZNQSmGRyRg4EVj49UMevEF1HfIuZC2SHMo5/F/njAUmFGJ07
 r/AcmQcabifg==
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="463658440"
Received: from alexissu-mobl.amr.corp.intel.com (HELO [10.212.1.230]) ([10.212.1.230])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 15:01:08 -0700
Subject: Re: [PATCH v2 22/24] ice: docs fix a devlink info that broke a table
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1602590106.git.mchehab+huawei@kernel.org>
 <79d341b6be03e9ffbe489d7110348357971a5fc8.1602590106.git.mchehab+huawei@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1c894002-7d96-3b28-b612-56b392ba5c2d@intel.com>
Date:   Tue, 13 Oct 2020 15:01:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <79d341b6be03e9ffbe489d7110348357971a5fc8.1602590106.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2020 5:14 AM, Mauro Carvalho Chehab wrote:
> Changeset 410d06879c01 ("ice: add the DDP Track ID to devlink info")
> added description for a new devlink field, but forgot to add
> one of its columns, causing it to break:
> 
> 	.../Documentation/networking/devlink/ice.rst:15: WARNING: Error parsing content block for the "list-table" directive: uniform two-level bullet list expected, but row 11 does not contain the same number of items as row 1 (3 vs 4).
> 
> 	.. list-table:: devlink info versions implemented
> 	    :widths: 5 5 5 90
> ...
> 	    * - ``fw.app.bundle_id``
> 	      - 0xc0000001
> 	      - Unique identifier for the DDP package loaded in the device. Also
> 	        referred to as the DDP Track ID. Can be used to uniquely identify
> 	        the specific DDP package.
> 
> Add the type field to the ``fw.app.bundle_id`` row.
> 
> Fixes: 410d06879c01 ("ice: add the DDP Track ID to devlink info")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Yep, looks correct. Thanks for the fix!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  Documentation/networking/devlink/ice.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
> index b165181d5d4d..a432dc419fa4 100644
> --- a/Documentation/networking/devlink/ice.rst
> +++ b/Documentation/networking/devlink/ice.rst
> @@ -70,6 +70,7 @@ The ``ice`` driver reports the following versions
>          that both the name (as reported by ``fw.app.name``) and version are
>          required to uniquely identify the package.
>      * - ``fw.app.bundle_id``
> +      - running
>        - 0xc0000001
>        - Unique identifier for the DDP package loaded in the device. Also
>          referred to as the DDP Track ID. Can be used to uniquely identify
> 
