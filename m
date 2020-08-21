Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB3824DEC0
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgHURmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:42:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:33994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgHURmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:42:15 -0400
IronPort-SDR: wxOYpQtle6De3zw2C2MPDwkUPt7t82gFDRpSfTS6eYZpmDTHcxf3Rn7DK8XHCKtEaOd3mrw7ws
 xD/ekha61x7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="143228783"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="143228783"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:42:14 -0700
IronPort-SDR: 8DFTtMNCiTOK7W/W1kfgnmVC5oYrgZTodoBhEaXMMn5OHe4jRkvLBUgakvsXVQe5QA5HxvtRvK
 /c4luAn0gEXQ==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="298012932"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:42:14 -0700
Date:   Fri, 21 Aug 2020 10:42:13 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH net-next 05/11] qed: implement devlink info request
Message-ID: <20200821104213.00006372@intel.com>
In-Reply-To: <20200727184310.462-6-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
        <20200727184310.462-6-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> Here we return existing fw & mfw versions, we also fetch device's
> serial number.
> 
> The base device specific structure (qed_dev_info) was not directly
> available to the base driver before.
> Thus, here we create and store a private copy of this structure
> in qed_dev root object.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

