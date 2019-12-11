Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A4D11C03A
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLKXBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:01:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfLKXBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 18:01:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF88D15035C62;
        Wed, 11 Dec 2019 15:01:42 -0800 (PST)
Date:   Wed, 11 Dec 2019 15:01:39 -0800 (PST)
Message-Id: <20191211.150139.57434044982727807.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org, decui@microsoft.com, jhansen@vmware.com,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] vsock: add local transport support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210104307.89346-1-sgarzare@redhat.com>
References: <20191210104307.89346-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Dec 2019 15:01:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 10 Dec 2019 11:43:01 +0100

> v2:
>  - style fixes [Dave]
>  - removed RCU sync and changed 'the_vsock_loopback' in a global
>    static variable [Stefan]
>  - use G2H transport when local transport is not loaded and remote cid
>    is VMADDR_CID_LOCAL [Stefan]
>  - rebased on net-next
> 
> v1: https://patchwork.kernel.org/cover/11251735/
> 
> This series introduces a new transport (vsock_loopback) to handle
> local communication.
...

Series applied, thanks.
