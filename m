Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E52224DE7B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHURcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:32:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:39431 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgHURcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:32:12 -0400
IronPort-SDR: +QPSrj803aQLfVPzDiJpF47oqXQ3ap7A5zkxl5opXHCvk+hTXLxADZJ7Gpa1E28T1GpXMq3e9N
 3oI8E/+vIDyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="143374883"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="143374883"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:32:12 -0700
IronPort-SDR: nqi6Wh7JnDJ0s74w7uDC3FhdFGtLz2qP0XfnmD7S8ZEStl0LhetHHcCqN5Zq4OJ8OgMonKqK6y
 /jtkePvOEp3g==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="298010508"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:32:11 -0700
Date:   Fri, 21 Aug 2020 10:32:10 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH net-next 01/11] qed: move out devlink logic into a new
 file
Message-ID: <20200821103210.0000587b@intel.com>
In-Reply-To: <20200727184310.462-2-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
        <20200727184310.462-2-irusskikh@marvell.com>
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
