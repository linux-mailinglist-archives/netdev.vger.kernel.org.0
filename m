Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7250248DFE
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgHRSaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:30:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:32379 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHRSay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:30:54 -0400
IronPort-SDR: 0Uw3B1NnzfhgUa/sG1ZaojbETyzVJiggeGOpkFbVnE8TdT4wkbQW18AyqUOBkULd4O3AMzGTfK
 tUphSzRB+HqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="219288186"
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="219288186"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:30:54 -0700
IronPort-SDR: oj0ejtypoatnOF/6Jfpv4z3pZWgSMXINAyyeEt2NDboMQ3FCTxbQQTboobVnvDt29S+V+xr7AT
 75jZaHEVqThw==
X-IronPort-AV: E=Sophos;i="5.76,328,1592895600"; 
   d="scan'208";a="441320016"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.158.55])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 11:30:54 -0700
Date:   Tue, 18 Aug 2020 11:30:52 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Qingyu Li <ieatmuttonchuan@gmail.com>
Cc:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <isdn@linux-pingi.de>,
        <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/bluetooth/cmtp/sock.c: add CAP_NET_RAW check.
Message-ID: <20200818113052.000032ce@intel.com>
In-Reply-To: <20200818081555.GA1349@oppo>
References: <20200818081555.GA1349@oppo>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 16:15:55 +0800
Qingyu Li <ieatmuttonchuan@gmail.com> wrote:

> When creating a raw PF_BLUETOOTH socket,
> CAP_NET_RAW needs to be checked first.

Please see my previous replies.
