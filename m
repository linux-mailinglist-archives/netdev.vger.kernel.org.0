Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C73E3F43
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbfJXWTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 18:19:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbfJXWTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:19:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D37314B79EB5;
        Thu, 24 Oct 2019 15:19:06 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:19:05 -0700 (PDT)
Message-Id: <20191024.151905.769140126627390086.davem@davemloft.net>
To:     u9012063@gmail.com
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        daniel@iogearbox.net, ast@kernel.org, magnus.karlsson@intel.com,
        brouer@redhat.com
Subject: Re: [PATCH net-next] xsk: Enable AF_XDP by default.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571788711-4397-1-git-send-email-u9012063@gmail.com>
References: <1571788711-4397-1-git-send-email-u9012063@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 15:19:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Tue, 22 Oct 2019 16:58:31 -0700

> The patch enables XDP_SOCKETS and XDP_SOCKETS_DIAG used by AF_XDP,
> and its dependency on BPF_SYSCALL.
> 
> Signed-off-by: William Tu <u9012063@gmail.com>

I don't know about this, it's a big change.

The consumers who care will enable these things, and all of our test cases
have appropriate config snippets to make sure they are enabled too.

I'm not applying this.
