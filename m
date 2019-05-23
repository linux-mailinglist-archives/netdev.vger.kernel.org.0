Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E4273AB
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbfEWBAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:00:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37188 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWBAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:00:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B78615043932;
        Wed, 22 May 2019 18:00:48 -0700 (PDT)
Date:   Wed, 22 May 2019 18:00:47 -0700 (PDT)
Message-Id: <20190522.180047.238715219030499893.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, decui@microsoft.com, mikelley@microsoft.com,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hv_sock: perf: Allow the socket buffer size
 options to influence the actual socket buffers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BN6PR21MB04652168EAE5D6D7D39BD4AAC0000@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB04652168EAE5D6D7D39BD4AAC0000@BN6PR21MB0465.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 18:00:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>
Date: Wed, 22 May 2019 22:56:07 +0000

> Currently, the hv_sock buffer size is static and can't scale to the
> bandwidth requirements of the application. This change allows the
> applications to influence the socket buffer sizes using the SO_SNDBUF and
> the SO_RCVBUF socket options.
> 
> Few interesting points to note:
> 1. Since the VMBUS does not allow a resize operation of the ring size, the
> socket buffer size option should be set prior to establishing the
> connection for it to take effect.
> 2. Setting the socket option comes with the cost of that much memory being
> reserved/allocated by the kernel, for the lifetime of the connection.
> 
> Perf data:
> Total Data Transfer: 1GB
> Single threaded reader/writer
> Results below are summarized over 10 iterations.
 ...
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>

Applied.
