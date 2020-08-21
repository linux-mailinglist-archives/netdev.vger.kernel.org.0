Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B6224DED5
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHURqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:46:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:29452 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgHURqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:46:24 -0400
IronPort-SDR: pm3E+9C1f9bZOswhGPPs3a4VmV14z7Kt2IN9HqKXTmQt4c1J62kDe+6u0OVMt+wbQbELbt2aiU
 lysJipbiQgiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="217136625"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="217136625"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:46:23 -0700
IronPort-SDR: qVxi9sC9r3g2mccLF3Lmmr72UgAlouHsoxYjfZRTRFWgqraUD/nlpcQG3kWksNhs3Tpa37OM8w
 KvBY52sIWHjA==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="293898186"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:46:22 -0700
Date:   Fri, 21 Aug 2020 10:46:20 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH net-next 06/11] qed: health reporter init deinit seq
Message-ID: <20200821104620.00006efc@intel.com>
In-Reply-To: <20200727184310.462-7-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
        <20200727184310.462-7-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> Here we declare health reporter ops (empty for now)
> and register these in qed probe and remove callbacks.
> 
> This way we get devlink attached to all kind of qed* PCI
> device entities: networking or storage offload entity.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

I'm not really sure what the point of separating the ops skeleton code
from the implementation in the next patch, but

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
