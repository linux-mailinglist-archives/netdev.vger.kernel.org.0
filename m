Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3058D215238
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 07:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgGFFdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 01:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbgGFFdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 01:33:52 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D5220715;
        Mon,  6 Jul 2020 05:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594013631;
        bh=TcMRos0G8hu1ukloPghrRVCDut0liy88Ncfhx1rIjeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tCC107ND6TPSQRqjNG990EfKwJd5etDGVpyOEAJNyd8oLaazu/G5ViN0ugLU+e0oJ
         RZ/eeiIp0tZB9Vo/ZHK0uX4UFPHkF0GilUnUFWZvMt0li2oOrc/4mGhlARXaSA5auy
         uOLHFudo50PuBmiheijpKjTui+fYre972c7d4Kko=
Date:   Mon, 6 Jul 2020 08:33:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-next v1 1/4] rdma: update uapi headers
Message-ID: <20200706053348.GD207186@unreal>
References: <20200624104012.1450880-1-leon@kernel.org>
 <20200624104012.1450880-2-leon@kernel.org>
 <e91ebfe0-87aa-0dc4-7c2c-48004cc761c7@gmail.com>
 <20200705180415.GB207186@unreal>
 <4785306c-f05f-ca63-e8f6-9b6d6b454bd2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4785306c-f05f-ca63-e8f6-9b6d6b454bd2@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 12:07:31PM -0600, David Ahern wrote:
> On 7/5/20 12:04 PM, Leon Romanovsky wrote:
> > RDMA_NLDEV_NUM_OPS is not a command, but enum item to help calculate array
> > size, exactly like devlink_command in include/uapi/linux/devlink.h.
>
> ok. usually the last field is __FOO_MAX not FOO_NUM.

I used same naming style as we had for other enums in rdma_netlink.h.

Thanks
