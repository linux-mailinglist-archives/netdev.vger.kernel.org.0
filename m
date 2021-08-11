Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59993E9A9C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhHKV4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232013AbhHKV4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 17:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B0BF60F11;
        Wed, 11 Aug 2021 21:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628718944;
        bh=OjcYZiWhFRTZCq07evoVeYkTNM2tTVNg1j+/3ZbQ2+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o0hWuaDl4vkVSP5KOvmYNo8KQSvz3ZaZhpQQRZCKbAxX8F53hOLjpdnD1lN11fyyE
         xO5SS6ZxxtksbPBbTGrpA3SP7BMj19UNFmaSXDZtsqCty/Ge8SxBweNG3bT9P8qvw0
         Q6VW1og1bLCiIc/vkwIRzIp3/VhuRUiuhuZ9GHFR35OQARH3sOTepP+YC6K9UyuR54
         J4FAhB6/NiO0pLs3wR02mITm3SS2Ai+Mc4Vrqs/Fmr2B54MNZzla5liyltkFmwYlXJ
         eG/J3gpL6AFyHkR4kWmZw1uCU9LzDYygW0At8E+B3PhrcVW5klmlg3/l+mxsR4Vj5b
         VY2BS21cwsGAw==
Date:   Wed, 11 Aug 2021 14:55:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rao Shoaib <Rao.Shoaib@oracle.com>
Cc:     dvyukov@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        edumazet@google.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] af_unix: Add OOB support
Message-ID: <20210811145543.364a7552@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810183122.518941-1-Rao.Shoaib@oracle.com>
References: <20210810183122.518941-1-Rao.Shoaib@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 11:31:22 -0700 Rao Shoaib wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> syzkaller found that OOB code was holding spinlock
> while calling a function in which it could sleep.
> 
> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> 

No new lines between tags please.

> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>

Would you mind resending with a better subject? Something like
"af_unix: fix possible sleep under spinlock in oob handling"?
