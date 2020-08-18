Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F01248DF8
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHRS3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:29:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:12408 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHRS3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:29:13 -0400
IronPort-SDR: qEe9DGZi8c/iGxwS/bYtUm0HUqoAUuUMsBhpoZsgKbY/VEHkIN+fuUmM28j1uj8cfGmMw9blRp
 LR7h1THtWr2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="135049959"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="135049959"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:29:11 -0700
IronPort-SDR: tepklzs+fGxGB0rc/EqS7skQCMwXcY2hCWRtlxTCE6bDbEmgmi7qjeoXRbiomB3wN91POAXzCt
 Ysyurc8zLwJg==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="441319270"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:29:11 -0700
Date:   Tue, 18 Aug 2020 11:29:10 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Qingyu Li <ieatmuttonchuan@gmail.com>
Cc:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/bluetooth/bnep/sock.c: add CAP_NET_RAW check.
Message-ID: <20200818112910.000014ea@intel.com>
In-Reply-To: <20200818080703.GA31526@oppo>
References: <20200818080703.GA31526@oppo>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 16:07:03 +0800
Qingyu Li <ieatmuttonchuan@gmail.com> wrote:

> When creating a raw PF_BLUETOOTH socket,
> CAP_NET_RAW needs to be checked first.
> 

These changes should be part of a series (patch 0,1,2 at least), and all
my replies on your other patch apply to this one as well.

