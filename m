Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC01FA9C4E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbfIEHx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 03:53:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42922 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbfIEHxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 03:53:25 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D49B315385198;
        Thu,  5 Sep 2019 00:53:23 -0700 (PDT)
Date:   Thu, 05 Sep 2019 00:53:22 -0700 (PDT)
Message-Id: <20190905.005322.1525752973478019785.davem@davemloft.net>
To:     mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        stefanha@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] vsock/virtio: a better comment on credit
 update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190903073748.25214-1-mst@redhat.com>
References: <20190903073748.25214-1-mst@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 00:53:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 3 Sep 2019 03:38:16 -0400

> The comment we have is just repeating what the code does.
> Include the *reason* for the condition instead.
> 
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.
