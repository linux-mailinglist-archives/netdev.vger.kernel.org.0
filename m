Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E033B17E6B
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfEHQqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:46:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfEHQqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:46:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2CC1140751E7;
        Wed,  8 May 2019 09:46:28 -0700 (PDT)
Date:   Wed, 08 May 2019 09:46:28 -0700 (PDT)
Message-Id: <20190508.094628.1716602477350359336.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     paul@paul-moore.com, selinux@vger.kernel.org,
        netdev@vger.kernel.org, tdeseyn@redhat.com,
        marcelo.leitner@gmail.com, richard_c_haines@btinternet.com
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 09:46:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed,  8 May 2019 15:32:51 +0200

> calling connect(AF_UNSPEC) on an already connected TCP socket is an
> established way to disconnect() such socket. After commit 68741a8adab9
> ("selinux: Fix ltp test connect-syscall failure") it no longer works
> and, in the above scenario connect() fails with EAFNOSUPPORT.
> 
> Fix the above falling back to the generic/old code when the address family
> is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
> specific constraints.
> 
> Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
> Reported-by: Tom Deseyn <tdeseyn@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, and queued up for -stable, thanks!
