Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33371C77F7
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgEFRdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:33:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:35328 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728892AbgEFRdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 13:33:23 -0400
IronPort-SDR: eWBTP632oWShg35La9DNMsoJnQLdV4QTZSlXmdQWJ1KsMvKTsAxlX1emF6i5ajaCKSNU/fXRh/
 nIKm2DxJ7B9w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 10:33:22 -0700
IronPort-SDR: hR4VvPQ1s8LInWNivzxzkSMAvnP0apxEVPJ4nIM8UCZrAXzyiX+MVxaq0FmecwSJPcksCvYdhn
 BHDTRFkDwx1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,360,1583222400"; 
   d="scan'208";a="461835332"
Received: from vvoggu-mobl1.amr.corp.intel.com (HELO ellie) ([10.213.175.52])
  by fmsmga006.fm.intel.com with ESMTP; 06 May 2020 10:33:22 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: hsr: fix incorrect type usage for protocol variable
In-Reply-To: <20200506154107.575-1-m-karicheri2@ti.com>
References: <20200506154107.575-1-m-karicheri2@ti.com>
Date:   Wed, 06 May 2020 10:33:22 -0700
Message-ID: <87368dufx9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Murali,

Murali Karicheri <m-karicheri2@ti.com> writes:

> Fix following sparse checker warning:-
>
> net/hsr/hsr_slave.c:38:18: warning: incorrect type in assignment (different base types)
> net/hsr/hsr_slave.c:38:18:    expected unsigned short [unsigned] [usertype] protocol
> net/hsr/hsr_slave.c:38:18:    got restricted __be16 [usertype] h_proto
> net/hsr/hsr_slave.c:39:25: warning: restricted __be16 degrades to integer
> net/hsr/hsr_slave.c:39:57: warning: restricted __be16 degrades to integer
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---

I think this patch should go via the net tree, as it is a warning fix.
Anyway...

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


-- 
Vinicius
