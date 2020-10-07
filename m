Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFB12869FA
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgJGVRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:17:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:46463 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgJGVRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 17:17:53 -0400
IronPort-SDR: Wk36tJ9p+KUdvmjJrjv3Uby2IObJkJAtuNk+tx+dhSX5ZOa/AXqnelhTajREGqaT8D6zTsi7He
 SGpvOIZloUjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="161706390"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="161706390"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:17:53 -0700
IronPort-SDR: /aizg2H1qPYQC4HRKGbI/7cLMAP1S+il1z5S3CJTBswk6Jk51LDXp8fyebt4+slvV6sTQ33ScQ
 rF3lbI65/OPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="316410774"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga006.jf.intel.com with ESMTP; 07 Oct 2020 14:17:51 -0700
Date:   Wed, 7 Oct 2020 23:10:17 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sven.auhagen@voleatech.de
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH 4/7] igb: skb add metasize for xdp
Message-ID: <20201007211017.GC48010@ranger.igk.intel.com>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
 <20201007152506.66217-5-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007152506.66217-5-sven.auhagen@voleatech.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 05:25:03PM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> add metasize if it is set in xdp
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
