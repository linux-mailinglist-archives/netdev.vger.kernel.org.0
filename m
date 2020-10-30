Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A9D29FBD7
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgJ3C6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgJ3C60 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 22:58:26 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BFA12076E;
        Fri, 30 Oct 2020 02:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604026705;
        bh=zdm1QsQQhBdbEXo1vJJAAvf31PZPJgsCdX0MVm5iQds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zK029j+/sc9Dz4QKTArUHZtSPZxdGcvP9k4eSRjl8IOkQHWw77OnzDcYfynT/fJEs
         j925E0rHhlllK73dOBTBGz1zn2tepxIkPlLwjbpIV7E3Xn7K98kPIrdVNfTMt+f5cO
         Nra2TrsfqmzS9ocTM7wHLknfzns+IYfqgTJhgtvU=
Date:   Thu, 29 Oct 2020 19:58:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH -next] net/mac8390: discard unnecessary breaks
Message-ID: <20201029195824.5f1d4d37@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027135159.71444-1-zhangqilong3@huawei.com>
References: <20201027135159.71444-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 21:51:59 +0800 Zhang Qilong wrote:
> The 'break' is unnecessary because of previous 'return',
> and we could discard it.
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

Applied.
