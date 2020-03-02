Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926CE1766CE
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgCBWWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:22:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:28774 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgCBWWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 17:22:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 14:22:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="258118892"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2020 14:22:09 -0800
Subject: Re: [PATCH] devlink: remove trigger command from devlink-region.rst
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us
References: <20200302222119.52140-1-jacob.e.keller@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <76307bc8-0977-e52b-4ff8-ef0b61a6e7b6@intel.com>
Date:   Mon, 2 Mar 2020 14:22:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302222119.52140-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heh, forgot to set subject properly, it should be [net].

Thanks,
Jake

On 3/2/2020 2:21 PM, Jacob Keller wrote:
> The devlink trigger command does not exist. While rewriting the
> documentation for devlink into the reStructuredText format,
> documentation for the trigger command was accidentally merged in. This
> occurred because the author was also working on a potential extension to
> devlink regions which included this trigger command, and accidentally
> squashed the documentation incorrectly.
> 
> Further review eventually settled on using the previously unused "new"
> command instead of creating a new trigger command.
> 
> Fix this by removing mention of the trigger command from the
> documentation.
> 
> Fixes: 0b0f945f5458 ("devlink: add a file documenting devlink regions", 2020-01-10)
> Noticed-by: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  Documentation/networking/devlink/devlink-region.rst | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
> index 1a7683e7acb2..8b46e8591fe0 100644
> --- a/Documentation/networking/devlink/devlink-region.rst
> +++ b/Documentation/networking/devlink/devlink-region.rst
> @@ -40,9 +40,6 @@ example usage
>      # Delete a snapshot using:
>      $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
>  
> -    # Trigger (request) a snapshot be taken:
> -    $ devlink region trigger pci/0000:00:05.0/cr-space
> -
>      # Dump a snapshot:
>      $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
>      0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
> 
