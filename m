Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977682976EE
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754809AbgJWSbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754796AbgJWSbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 14:31:34 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C45EA20853;
        Fri, 23 Oct 2020 18:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603477893;
        bh=RTVKpBI+u2l+vzsqXUx6tfb2ovOakmT4NgNf8+EINCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kFlBTtJVLYPtnqW14/h8V5Ej2uFWd6zRUfIhNzjfuhmtj3KpaabFeu0aKwLppziZb
         jfVMlvzj7cJbnpRZUSnz7zK/GjndMvxxN6nExs5etpyqp+nD2fim4SMXqIFbARzahd
         ALiqAYhvHpDds6Y0tZzdlz0lPwcr4M5Cxw+7lTPM=
Date:   Fri, 23 Oct 2020 11:31:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com, ncardwell@google.com
Subject: Re: [net] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
Message-ID: <20201023113131.780be7f6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023174856.200394-1-arjunroy.kdev@gmail.com>
References: <20201023174856.200394-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 10:48:57 -0700 Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> With SO_RCVLOWAT, under memory pressure,
> it is possible to enter a state where:
> 
> 1. We have not received enough bytes to satisfy SO_RCVLOWAT.
> 2. We have not entered buffer pressure (see tcp_rmem_pressure()).
> 3. But, we do not have enough buffer space to accept more packets.

Doesn't apply cleanly to net:

Applying: tcp: Prevent low rmem stalls with SO_RCVLOWAT.
error: sha1 information is lacking or useless (net/ipv4/tcp.c).
error: could not build fake ancestor
hint: Use 'git am --show-current-patch=diff' to see the failed patch
Patch failed at 0001 tcp: Prevent low rmem stalls with SO_RCVLOWAT.
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
