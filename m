Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFC6859B8
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbfHHFT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:19:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:29551 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfHHFT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 01:19:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 22:19:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,360,1559545200"; 
   d="scan'208";a="374728390"
Received: from jbrandeb-mobl2.amr.corp.intel.com (HELO localhost) ([10.254.39.134])
  by fmsmga006.fm.intel.com with ESMTP; 07 Aug 2019 22:19:58 -0700
Date:   Wed, 7 Aug 2019 22:19:57 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <jiri@mellanox.com>, <petrm@mellanox.com>, <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>, jesse.brandeburg@intel.com
Subject: Re: [PATCH net 2/2] mlxsw: spectrum_buffers: Further reduce pool
 size on Spectrum-2
Message-ID: <20190807221957.0000144a@intel.com>
In-Reply-To: <20190731063315.9381-3-idosch@idosch.org>
References: <20190731063315.9381-1-idosch@idosch.org>
        <20190731063315.9381-3-idosch@idosch.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 09:33:15 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> From: Petr Machata <petrm@mellanox.com>
> 
> In commit e891ce1dd2a5 ("mlxsw: spectrum_buffers: Reduce pool size on
> Spectrum-2"), pool size was reduced to mitigate a problem in port buffer
> usage of ports split four ways. It turns out that this work around does not
> solve the issue, and a further reduction is required.
> 
> Thus reduce the size of pool 0 by another 2.7 MiB, and round down to the
> whole number of cells.
> 
> Fixes: e891ce1dd2a5 ("mlxsw: spectrum_buffers: Reduce pool size on Spectrum-2")
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
