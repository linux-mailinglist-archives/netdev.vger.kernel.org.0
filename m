Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4392E9199C
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfHRU6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 16:58:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49094 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfHRU6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 16:58:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0B3414585EAB;
        Sun, 18 Aug 2019 13:58:12 -0700 (PDT)
Date:   Sun, 18 Aug 2019 13:58:08 -0700 (PDT)
Message-Id: <20190818.135808.1309228891811712533.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ibmvnic: Unmap DMA address of TX descriptor
 buffers after use
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565812625-24364-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1565812625-24364-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 13:58:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Wed, 14 Aug 2019 14:57:05 -0500

> There's no need to wait until a completion is received to unmap
> TX descriptor buffers that have been passed to the hypervisor.
> Instead unmap it when the hypervisor call has completed. This patch
> avoids the possibility that a buffer will not be unmapped because
> a TX completion is lost or mishandled.
> 
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Tested-by: Devesh K. Singh <devesh_singh@in.ibm.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied.
