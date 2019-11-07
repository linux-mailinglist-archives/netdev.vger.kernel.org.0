Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA86F3C5B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfKGX5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:57:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGX5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:57:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 274571537E8FB;
        Thu,  7 Nov 2019 15:57:10 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:57:09 -0800 (PST)
Message-Id: <20191107.155709.1716879557397915384.davem@davemloft.net>
To:     parav@mellanox.com
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, saeedm@mellanox.com, kwankhede@nvidia.com,
        leon@kernel.org, cohuck@redhat.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107160448.20962-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:57:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>
Date: Thu,  7 Nov 2019 10:04:48 -0600

> This series adds the support for mlx5 sub function devices using
> mediated device with eswitch switchdev mode.

I think at a minimum there needs to be deeper explanations in the commit log
messages and thus I expect a respin of this series.

Thanks.
