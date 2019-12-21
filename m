Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF85D12874A
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfLUFKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:10:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfLUFKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:10:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 297B0153CA121;
        Fri, 20 Dec 2019 21:10:09 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:10:08 -0800 (PST)
Message-Id: <20191220.211008.1078307833860411304.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     jhansen@vmware.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefanha@redhat.com,
        decui@microsoft.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v3 00/11] VSOCK: add vsock_test test suite
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218180708.120337-1-sgarzare@redhat.com>
References: <20191218180708.120337-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:10:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 18 Dec 2019 19:06:57 +0100

> The vsock_diag.ko module already has a test suite but the core AF_VSOCK
> functionality has no tests. This patch series adds several test cases that
> exercise AF_VSOCK SOCK_STREAM socket semantics (send/recv, connect/accept,
> half-closed connections, simultaneous connections).
> 
> The v1 of this series was originally sent by Stefan.
> 
> v3:
> - Patch 6:
>   * check the byte received in the recv_byte()
>   * use send(2)/recv(2) instead of write(2)/read(2) to test also flags
>     (e.g. MSG_PEEK)
> - Patch 8:
>   * removed unnecessary control_expectln("CLOSED") [Stefan].
> - removed patches 9,10,11 added in the v2
> - new Patch 9 add parameters to list and skip tests (e.g. useful for vmci
>   that doesn't support half-closed socket in the host)
> - new Patch 10 prints a list of options in the help
> - new Patch 11 tests MSG_PEEK flags of recv(2)
> 
> v2: https://patchwork.ozlabs.org/cover/1140538/
> v1: https://patchwork.ozlabs.org/cover/847998/

Series applied, thanks.
