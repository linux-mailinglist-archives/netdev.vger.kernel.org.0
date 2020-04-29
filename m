Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488071BD0F4
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgD2ARs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgD2ARs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 20:17:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B416F20737;
        Wed, 29 Apr 2020 00:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588119467;
        bh=wXzRwXtEJNQkNUxjsHEkgriDlRCjnmOIRgtkPRrhR2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q6QWfsyg0dDrsEZfIeyNBJnJRBsaK2KDhgOs+ko/3LCn3IA9CCm1+WdcvG1t3E351
         874BU9oXjlHdAfI1xHMRd6nR/PVh16sqfqjTvJMJCGL8ZmRHjgw8FDHOlWMTvhb+0N
         GnN1WCdBXxSinnyjVSiAy8fvFThdGRQcs6uKO/qg=
Date:   Tue, 28 Apr 2020 17:17:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute2 v3] devlink: add support for DEVLINK_CMD_REGION_NEW
Message-ID: <20200428171746.765d09d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200428204323.1691163-1-jacob.e.keller@intel.com>
References: <20200428204323.1691163-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 13:43:24 -0700 Jacob Keller wrote:
> Add support to request that a new snapshot be taken immediately for
> a devlink region. To avoid confusion, the desired snapshot id must be
> provided.
> 
> Note that if a region does not support snapshots on demand, the kernel
> will reject the request with -EOPNOTSUP.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-and-tested-by: Jakub Kicinski <kuba@kernel.org>
