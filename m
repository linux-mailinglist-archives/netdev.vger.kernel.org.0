Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E201C1D57CD
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgEOR1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEOR1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:27:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863CBC061A0C;
        Fri, 15 May 2020 10:27:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA83814C6026F;
        Fri, 15 May 2020 10:27:37 -0700 (PDT)
Date:   Fri, 15 May 2020 10:27:36 -0700 (PDT)
Message-Id: <20200515.102736.2093927810365892295.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: move the SIOCDELRT and SIOCADDRT compat_ioctl handlers v2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515131925.3855053-1-hch@lst.de>
References: <20200515131925.3855053-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:27:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Fri, 15 May 2020 15:19:21 +0200

> Changes since v1:
>  - reorder a bunch of variable declarations

Please audit your entire series, the atalk_compat_ioctl() still has the
reverse christmas tree problem.

Thank you.
