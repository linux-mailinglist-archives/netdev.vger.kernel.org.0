Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0148E295709
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 06:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgJVEGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 00:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgJVEGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 00:06:05 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 818FF2225D;
        Thu, 22 Oct 2020 04:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603339564;
        bh=Aqv/u5WQdUXESLzY6LNtgXSnsdKeuS8G++rrSJIp85g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T8zjImjlD+9UfXs+OlHYClovsJDxO+ZXTxxhrV2BzUMIBmADS6aBKWByoOTo1Je0j
         hodM2ZbIGCyTb0MBlG5v2+qP9lrl5D69L3IeurB/GpF77bKe3UpwLCsDxMz+a7aJlW
         jPpXFnk15zLeVeMjKdavF5J14ISyi1/e9J00s95k=
Date:   Wed, 21 Oct 2020 21:06:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2] ibmvnic: save changed mac address to
 adapter->mac_addr
Message-ID: <20201021210602.044c6c61@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201020223919.46106-1-ljp@linux.ibm.com>
References: <20201020223919.46106-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 17:39:19 -0500 Lijun Pan wrote:
> After mac address change request completes successfully, the new mac
> address need to be saved to adapter->mac_addr as well as
> netdev->dev_addr. Otherwise, adapter->mac_addr still holds old
> data.
> 
> Fixes: 62740e97881c ("net/ibmvnic: Update MAC address settings after adapter reset")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

Applied.
