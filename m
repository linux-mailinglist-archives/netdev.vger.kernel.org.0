Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF03209B2A
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 10:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390544AbgFYIP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 04:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgFYIP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 04:15:59 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9DB3207FC;
        Thu, 25 Jun 2020 08:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593072958;
        bh=/D6Z8/Znlisf/bVRfPkvOH2d38BpafOLRd9YXIRL/pM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JcxuhEoHepRK1rhPCX182nBePs5fxooQJzCeFt65Qcvn8Akpfz7UcTFjrmoHhrsRa
         9lHcyCv1zWlR+BRO4wuyjfg99tzyORBFRfBu6ioYeb8Ao7BM1Y+iBTV3MfO/8TkUXV
         c8zbGgtPQeQlfcvj+pqEpRYF4/78shWsst4XBSXQ=
Date:   Thu, 25 Jun 2020 11:15:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-next v1 1/4] rdma: update uapi headers
Message-ID: <20200625081554.GB1446285@unreal>
References: <20200624104012.1450880-1-leon@kernel.org>
 <20200624104012.1450880-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624104012.1450880-2-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 01:40:09PM +0300, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg@mellanox.com>
>
> Update rdma_netlink.h file upto kernel commit ba1f4991cc55
> ("RDMA: Add support to dump resource tracker in RAW format")

David,

The SHA was changed because of the rebase on top of our testing branch.
65959522f806 RDMA: Add support to dump resource tracker in RAW format

Do you want me to resend the series?

Thanks
