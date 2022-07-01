Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D1856336B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 14:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbiGAMUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 08:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiGAMUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 08:20:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B48314D39;
        Fri,  1 Jul 2022 05:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656678005; x=1688214005;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=L28F0IQuGJkDXQWYuN+rHaYbWwAfIFpmSFRtOHDrx1g=;
  b=IijNPyZF4A1ieGaPQ+tCG3NINQiJGa8wPfc6CsxybkWZ8p+YRn7d5OPC
   lkbn8ld/KIGmpVhwo9L55OI0bu1yGlRCQqRcEqD4DnAdpQAni8IjE1bCz
   pRmZdY91t67uJH/jQsYSAbwxIbf+YdVO7PmyPf7zhzumpnWfcGLnSJ1GI
   BOJm6kTJvXcznenjeCw94EGwVrwXUAE0fSZrkZ+4Jq0pyTU9dn8B1a7u8
   TyIpqPwiCFSGOogkSd1BmL70GLM40sS2/Wck5rCrnXqynwFfNUiCD7lyV
   SXzy3phFsuYB5FeMOz5cvTpD9f+cHooa+jS7SZCKl8So/bksT5Ix7UBNn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282670256"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="282670256"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 05:20:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="596242291"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jul 2022 05:20:03 -0700
Date:   Fri, 1 Jul 2022 14:20:02 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: adjust XDP SOCKETS after file movement
Message-ID: <Yr7mcjRq57laZGEY@boxer>
References: <20220701042810.26362-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220701042810.26362-1-lukas.bulwahn@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 06:28:10AM +0200, Lukas Bulwahn wrote:
> Commit f36600634282 ("libbpf: move xsk.{c,h} into selftests/bpf") moves
> files tools/{lib => testing/selftests}/bpf/xsk.[ch], but misses to adjust
> the XDP SOCKETS (AF_XDP) section in MAINTAINERS.
> 
> Adjust the file entry after this file movement.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Andrii, please ack.
> 
> Alexei, please pick this minor non-urgent clean-up on top of the commit above.
> 
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fa4bfa3d10bf..27d9e65b9a85 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22042,7 +22042,7 @@ F:	include/uapi/linux/xdp_diag.h
>  F:	include/net/netns/xdp.h
>  F:	net/xdp/
>  F:	samples/bpf/xdpsock*
> -F:	tools/lib/bpf/xsk*
> +F:	tools/testing/selftests/bpf/xsk*

Magnus, this doesn't cover xdpxceiver.
How about we move the lib part and xdpxceiver part to a dedicated
directory? Or would it be too nested from main dir POV?

>  
>  XEN BLOCK SUBSYSTEM
>  M:	Roger Pau Monné <roger.pau@citrix.com>
> -- 
> 2.17.1
> 
