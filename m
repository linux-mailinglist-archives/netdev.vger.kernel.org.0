Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7953128F63D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 17:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389849AbgJOP56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 11:57:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:64591 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389693AbgJOP56 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 11:57:58 -0400
IronPort-SDR: 7UfthZC5SV2olv3E+TPr6bg2cP5yw+ee//cBHDF3ZNstmMqVGgNybENH5Lb9VXlisTJ082iEz/
 HK9hb/ija1wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9775"; a="154208837"
X-IronPort-AV: E=Sophos;i="5.77,379,1596524400"; 
   d="scan'208";a="154208837"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2020 08:57:56 -0700
IronPort-SDR: 2fEcDkTMiDsFsQZpE/PxuLjHlRc3sFohxvG+QbcmQ/1qYJt6WLg64JKsryNqKAjhqi/8UdrZOK
 FOJ94EU+IXkA==
X-IronPort-AV: E=Sophos;i="5.77,379,1596524400"; 
   d="scan'208";a="314563155"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.210.38])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2020 08:57:55 -0700
Date:   Thu, 15 Oct 2020 08:57:54 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     sundeep.lkml@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 01/10] octeontx2-af: Update get/set resource
 count functions
Message-ID: <20201015085754.000037d9@intel.com>
In-Reply-To: <1602584792-22274-2-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
        <1602584792-22274-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sundeep.lkml@gmail.com wrote:

> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Since multiple blocks of same type are present in
> 98xx, modify functions which get resource count and
> which update resource count to work with individual
> block address instead of block type.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>

LGTM

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
