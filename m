Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928A3115E5D
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 21:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLGUAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 15:00:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42846 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfLGUAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 15:00:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E629153B510D;
        Sat,  7 Dec 2019 12:00:08 -0800 (PST)
Date:   Sat, 07 Dec 2019 12:00:07 -0800 (PST)
Message-Id: <20191207.120007.1885129473331538826.davem@davemloft.net>
To:     sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mst@redhat.com
Subject: Re: [PATCH] vhost/vsock: accept only packets with the right dst_cid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206143912.153583-1-sgarzare@redhat.com>
References: <20191206143912.153583-1-sgarzare@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 12:00:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>
Date: Fri,  6 Dec 2019 15:39:12 +0100

> When we receive a new packet from the guest, we check if the
> src_cid is correct, but we forgot to check the dst_cid.
> 
> The host should accept only packets where dst_cid is
> equal to the host CID.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Applied.
