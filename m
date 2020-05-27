Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95571E48D0
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388828AbgE0P4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:56:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:22331 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbgE0P4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 11:56:18 -0400
IronPort-SDR: DUR7626C4qgR3m+cxOnq/Bct9PdyfSey5x9YTgd5JRj2wnbmNJAuqXhmwyAH0ituuFHfXYcG5t
 a4tK/g6Qiq2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 08:56:17 -0700
IronPort-SDR: yGuV4xpMZr+zNio7qTLq5DGkrGYGLUPipVRGTokL6bhXNdfndk0b3tQB9CFvntq2utX+Bn0cCk
 BL0FMl1gkTnA==
X-IronPort-AV: E=Sophos;i="5.73,441,1583222400"; 
   d="scan'208";a="442572372"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.202.202]) ([10.254.202.202])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 08:56:15 -0700
Subject: Re: [PATCH 5/9] RDMA/rdmavt: remove FMR memory registration
To:     Max Gurtovoy <maxg@mellanox.com>, jgg@mellanox.com,
        dledford@redhat.com, leon@kernel.org, galpress@amazon.com,
        netdev@vger.kernel.org, sagi@grimberg.me,
        linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com
Cc:     aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com
References: <20200527094634.24240-1-maxg@mellanox.com>
 <20200527094634.24240-6-maxg@mellanox.com>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <7b9775c9-0a37-4d8e-c30b-25f65a609eee@intel.com>
Date:   Wed, 27 May 2020 11:56:13 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200527094634.24240-6-maxg@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/2020 5:46 AM, Max Gurtovoy wrote:
> Use FRWR method to register memory by default and remove the ancient and
> unsafe FMR method.
> 
> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>

See the expected failures.

Tested-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

