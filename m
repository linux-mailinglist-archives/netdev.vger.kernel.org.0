Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874A646DE3
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfFOCrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:47:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57704 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOCrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:47:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9260212B05D34;
        Fri, 14 Jun 2019 19:47:42 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:47:42 -0700 (PDT)
Message-Id: <20190614.194742.1040162810429209822.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hv_netvsc: Set probe mode to sync
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560459955-37900-1-git-send-email-haiyangz@microsoft.com>
References: <1560459955-37900-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:47:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 13 Jun 2019 21:06:53 +0000

> For better consistency of synthetic NIC names, we set the probe mode to
> PROBE_FORCE_SYNCHRONOUS. So the names can be aligned with the vmbus
> channel offer sequence.
> 
> Fixes: af0a5646cb8d ("use the new async probing feature for the hyperv drivers")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied and queued up for -stable.
