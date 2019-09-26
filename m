Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D16EBF7B5
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfIZRkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727631AbfIZRkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 13:40:13 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34FC5222C3;
        Thu, 26 Sep 2019 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569519612;
        bh=pj+IteiYKUAR/ZV5fLIvpqvuxeSPbRVObokvF+YpEUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FvmCbjebU8ExKDrgUFxYNa4tlmZdz3h8DfSUQz8t/Q+duEckLUndxbxGjMl+xd5Ax
         DjiRC07Er347pH/JB+PUV/LqrwYIvc3B8a11sgd1Zaq37DAD9D7p5mSMFKAEjlusZ1
         hI9aN6Gm4rQ/8d5lDuNjfpqIbZ4EUQthMQfoY7sI=
Date:   Thu, 26 Sep 2019 20:40:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
Message-ID: <20190926174009.GD14368@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
> From: Shiraz Saleem <shiraz.saleem@intel.com>
>
> Mark i40iw as deprecated/obsolete.
>
> irdma is the replacement driver that supports X722.

Can you simply delete old one and add MODULE_ALIAS() in new driver?

Thanks
