Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63BB859B6
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730908AbfHHFTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:19:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:61623 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfHHFTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 01:19:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 22:19:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,360,1559545200"; 
   d="scan'208";a="374728302"
Received: from jbrandeb-mobl2.amr.corp.intel.com (HELO localhost) ([10.254.39.134])
  by fmsmga006.fm.intel.com with ESMTP; 07 Aug 2019 22:19:33 -0700
Date:   Wed, 7 Aug 2019 22:19:32 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <jiri@mellanox.com>, <petrm@mellanox.com>, <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>, jesse.brandeburg@intel.com
Subject: Re: [PATCH net 1/2] mlxsw: spectrum: Fix error path in
 mlxsw_sp_module_init()
Message-ID: <20190807221932.00001af2@intel.com>
In-Reply-To: <20190731063315.9381-2-idosch@idosch.org>
References: <20190731063315.9381-1-idosch@idosch.org>
        <20190731063315.9381-2-idosch@idosch.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 09:33:14 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> In case of sp2 pci driver registration fail, fix the error path to
> start with sp1 pci driver unregister.
> 
> Fixes: c3ab435466d5 ("mlxsw: spectrum: Extend to support Spectrum-2 ASIC")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
