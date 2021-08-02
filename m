Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8623DDDB5
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhHBQbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhHBQbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E8460FC0;
        Mon,  2 Aug 2021 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627921851;
        bh=8jE3OUxJl9dbV/Xx+Vz/QVOO/iSlqKM/+hmL/9lbkD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TTHTtbpm21w0nqjLTebJFvefzdBg5PDyP37z1fWUduVzpWeKfP34nEKt0QEJL1vVh
         bvfuuSY+86Yv6txP5Ms2834d0zHfUhHDVeV4up9H8WgW83r6xg9eLS2An2B0zX0VJH
         TlN6DpbW5g7ZINK+uQJFrMPCW38PgopsS7Tl3KXynnRpTzvtTyZSD0HLpFb/f5gd8t
         e2abbU4N5UHeCZmEXgOY6973lkeVcNTldC45k9KjB/WNvRu4WixG7AEE9iUcbtlviz
         UbCpU7LQdk34jJOB3nBcjzxUZ0KaULNxpRK+c/y8X2yXwenrNdcPK+cGVxpslVvPbU
         CcoE62NH6J17Q==
Date:   Mon, 2 Aug 2021 09:30:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] neighbour: Rename procfs entry
Message-ID: <20210802093050.67c361f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210802035745.29934-1-yajun.deng@linux.dev>
References: <20210802035745.29934-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Aug 2021 11:57:45 +0800 Yajun Deng wrote:
> Use gc_thresh_{min, default, max} instead of gc_thresh{1, 2, 3}.
> This is more friendly for user.

We can't rename files in procfs after they had been present 
in an official kernel release. They are uABI. Same goes for 
your default -> current rename patch.

You also forgot to update documentation. 
