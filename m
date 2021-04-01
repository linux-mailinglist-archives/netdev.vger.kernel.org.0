Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13CA351787
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhDARmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbhDARgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:36:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD7CC0319C7
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:20:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lS0zN-0002UD-Vo; Thu, 01 Apr 2021 19:20:14 +0200
Date:   Thu, 1 Apr 2021 19:20:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 2/2] mptcp: revert "mptcp: provide subflow aware
 release function"
Message-ID: <20210401172013.GD13699@breakpoint.cc>
References: <cover.1617295578.git.pabeni@redhat.com>
 <ad4571485ca31026738cf57d67d68d681997a012.1617295578.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad4571485ca31026738cf57d67d68d681997a012.1617295578.git.pabeni@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> wrote:
> This change reverts commit ad98dd37051e ("mptcp: provide subflow aware
> release function"). The latter introduced a deadlock spotted by
> syzkaller and is not needed anymore after the previous commit.
> 
> Fixes: ad98dd37051e ("mptcp: provide subflow aware release function")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Paolo, thanks for passing this to -net.

Acked-by: Florian Westphal <fw@strlen.de>
