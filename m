Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76F624DEF7
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHUR4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:56:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:34565 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgHUR4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:56:52 -0400
IronPort-SDR: NO5iWkGG7Vf7lOjK+bz1wuZDtrPsTeGVvLw4r+9jOe9xhY1v2focCj1SCOzJdZ/y2WlyFc054F
 ucEH17ni9bjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="173637268"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="173637268"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:56:51 -0700
IronPort-SDR: EU3w4syvhtus6AGJYmbR45rrMeomfVV6JdxwlfprXXkytFLPJZabJiAHO6WPkhYaLCjvfc8vLG
 HrECpk0qlN6A==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="293900985"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:56:51 -0700
Date:   Fri, 21 Aug 2020 10:56:50 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v6 net-next 01/10] qed: move out devlink logic into a
 new file
Message-ID: <20200821105650.00003af2@intel.com>
In-Reply-To: <20200820185204.652-2-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
        <20200820185204.652-2-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> We are extending devlink infrastructure, thus move the existing
> stuff into a new file qed_devlink.c
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
