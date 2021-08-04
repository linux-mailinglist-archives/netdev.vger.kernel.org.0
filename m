Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605883E0A7B
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 00:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhHDWl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 18:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhHDWl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 18:41:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C0560F58;
        Wed,  4 Aug 2021 22:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628116872;
        bh=UGaFB5uCXDamRDdgQnQIGHBo7q3hQIhL2kDpTJA/qb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VdppoAjYUYIb/0NxgehKyNTKht4p6QCKi+7tkUXp93RMlzYeXcffn53uBZC25ypT7
         ZJ3Hnhy/NNJgXvOlFSKgnuQDzNePI6hD1ueaAG3IM9vG1yYp5zp0BcRb+WFhnxZhRi
         K1kE3nU+AOe5YIwiwuauF5FT38J0CH6nByI9cYmoj4abZjoJWQCyNZHBuRTjRrFL7f
         vGXbL6wobTi2KhGU/63O3FrAWA4UMqo2iinCbFyfQiQdtKqS87wQroLitBnzjPdWYd
         UKkFs9yzmx5Fg6nn/SX/Z6dXXS4seGGrnCph77OEMVfOSPOsGMxFSXtIvp+mhQ+Fwl
         Nm9Gbv9y1ycOA==
Date:   Wed, 4 Aug 2021 15:41:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 21/38] virtio_net: Replace deprecated CPU-hotplug
 functions.
Message-ID: <20210804154111.24d92a1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210803141621.780504-22-bigeasy@linutronix.de>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
        <20210803141621.780504-22-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Aug 2021 16:16:04 +0200 Sebastian Andrzej Siewior wrote:
> The functions get_online_cpus() and put_online_cpus() have been
> deprecated during the CPU hotplug rework. They map directly to
> cpus_read_lock() and cpus_read_unlock().
> 
> Replace deprecated CPU-hotplug functions with the official version.
> The behavior remains unchanged.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Applied this one and 21 to net-next, thanks!
