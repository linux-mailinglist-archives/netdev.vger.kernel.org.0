Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C59633E0AE
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhCPViP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhCPVh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0524E64DF0;
        Tue, 16 Mar 2021 21:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615930678;
        bh=/Wp1VJrmKmqXE0oo2vwWwXpBvd/xhNubrkciEhZ7HwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K63G76znfslp8HYsGmaz4/ruhH7TzA98kHXqHDymqpYVWjjPKjDpXBIgsBfACk7Jj
         tq1eAkNNy0bMOjqV7gqsAoM28VOc2is+KjhI2mwA4e9DeaWFcZUoP0ND7YINeNj75b
         MjVm3jvQo+izo2RgEgCePMkuIT0IUaErMJNadagNG+FWMp4VNfuzej7z8i+IxobrHj
         zed0lmXAcLZVQAsC+8JIEf5NHHnL3TkkIac2URecudCyxPtrwtRfQfILRUnSk2SmW5
         CqUlWc7RQ7zYW5aSeFQ3ou3S7wXhTI3fRDinfsW4zBNgtuLyzJGKKhnd1c0O7wISWo
         YWv83UYNaeNrw==
Date:   Tue, 16 Mar 2021 14:37:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarvis Jiang <jarvis.w.jiang@gmail.com>
Cc:     davem@davemloft.net, rppt@linux.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, cchen50@lenovo.com, mpearson@lenovo.com
Subject: Re: [PATCH] Add MHI bus support and driver for T99W175 5G modem
Message-ID: <20210316143756.45ef6d91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316124237.3469-1-jarvis.w.jiang@gmail.com>
References: <20210316124237.3469-1-jarvis.w.jiang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 05:42:37 -0700 Jarvis Jiang wrote:
>  drivers/bus/mhi/devices/mhi_netdev.c          | 1830 +++++++++++++

There's already a drivers/net/mhi/

Please make sure the drivers live in their respective subsystem.

Virtio drivers don't sit under drivers/virtio, and most certainly not
under drivers/bus/virtio...

>  drivers/bus/mhi/devices/mhi_satellite.c       | 1155 +++++++++
>  drivers/bus/mhi/devices/mhi_uci.c             |  802 ++++++

Ugh, can you clarify what's the source of this code dump and if you're
coordinating with others working on Qualcomm drivers?
