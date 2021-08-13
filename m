Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EFA3EBBCC
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 20:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhHMSCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 14:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhHMSCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 14:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4954260C3E;
        Fri, 13 Aug 2021 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628877715;
        bh=57JW60fP/xL7OgjZruB/HJInkjr4EmYWXrGuxijjozA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zy+RFZ/V59YuPdUhzcD4gf+b8DPjYnRHlDvd0M66nvOUBBmlcv7Z3d0iqqTFQ4Wgt
         s4wdKm0BbeHfg2ukU59F8+a8XbJNfuy2hsqK2cYBXCDW0TqSM+GB62m4+headgJEE9
         OKDZpMqWepOFr5OOc5xoOFcfuoHbkNBsdqWg5ZRZ8kXHv+ikoDrmiiByban+Vio/DW
         luBKBgyFYj+1wLd4s8VkjnmGbQJs3HFudnhobKEuAzDfCHc3tToPMrCNeBu0yCCakL
         R4faqdvmNpXIv1rhjYfF7D+TC1J1WHq/niCGQKkOf1fEJNoYIi6+vkjWxZoiIZY3Et
         VLI6V54NheMFg==
Date:   Fri, 13 Aug 2021 11:01:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rao Shoaib <Rao.Shoaib@oracle.com>
Cc:     netdev@vger.kernel.org, viro@zeniv.linux.org.uk,
        edumazet@google.com
Subject: Re: [PATCH v2 1/1] af_unix: fix holding spinlock in oob handling
Message-ID: <20210813110154.392c2baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813175816.647225-2-Rao.Shoaib@oracle.com>
References: <20210813175816.647225-1-Rao.Shoaib@oracle.com>
        <20210813175816.647225-2-Rao.Shoaib@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 10:58:16 -0700 Rao Shoaib wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> syzkaller found that OOB code was holding spinlock
> while calling a function in which it could sleep.
> Also addressed comments from edumazet@google.com.

I applied v1 an hour or so ago, please resend addressing
only the issues pointed out by Eric. Try to separate the
issues each into its own patch. That's easier to review.
