Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAA433F62C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhCQRBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:01:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:29483 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232329AbhCQRAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:00:46 -0400
IronPort-SDR: gyy1r5ohmXI+5i7K8RRGBJWkwVKAXEaLxgmduqVIdsaKIZwEdyg9cYwWpZlhT3UJw4qSSIvdwf
 SuuLcpo85xkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="187134824"
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="187134824"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 10:00:45 -0700
IronPort-SDR: OvHxno4mREoUHFZRIKk5WYAoZWHH+n2AbIKte/Ujez80a/FP4ygTb/5KVdBotqhXhzep7NhyEZ
 2Uz4kxzF+Ydw==
X-IronPort-AV: E=Sophos;i="5.81,256,1610438400"; 
   d="scan'208";a="372414118"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.10.230])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 10:00:45 -0700
Date:   Wed, 17 Mar 2021 10:00:44 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] net: ethernet: intel: Fix a typo in the file
 ixgbe_dcb_nl.c
Message-ID: <20210317100044.00005f65@intel.com>
In-Reply-To: <20210317100001.2172893-1-unixbhaskar@gmail.com>
References: <20210317100001.2172893-1-unixbhaskar@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bhaskar Chowdhury wrote:

> 
> s/Reprogam/Reprogram/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
