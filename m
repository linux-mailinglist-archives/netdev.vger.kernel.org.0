Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82D920B58E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgFZQCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgFZQCk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 12:02:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B102053B;
        Fri, 26 Jun 2020 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593187360;
        bh=VlZgDqQP/WM8Rbwv4KeBEBgHzRnYzItYlXzHXXzEXXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qk9kwUYLE5pDqNF3DSDRknNK1hW485v5m4ZC3K8Gqsd1EFL5ZjvNajh4McxFUz4ew
         4wq3670Lv8liPcfttA1ZxMvF7SWaQvegluDD5LScHg1pPXDqdVk0pUsNbk+effk2zn
         t7bHdEwsA8UHbMXPCrFIJixUWg8AqUUKXlpdl0co=
Date:   Fri, 26 Jun 2020 09:02:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 4/4] mptcp: introduce token KUNIT self-tests
Message-ID: <20200626090238.6914222a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <848d6611c87790a6e4028b856e7c3323a53f2679.1593159603.git.pabeni@redhat.com>
References: <cover.1593159603.git.pabeni@redhat.com>
        <848d6611c87790a6e4028b856e7c3323a53f2679.1593159603.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 12:12:49 +0200 Paolo Abeni wrote:
> Unit tests for the internal MPTCP token APIs, using KUNIT
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Greetings! W=1 C=1 sayeth:

net/mptcp/token.c:318:6: warning: no newline at end of file
net/mptcp/token_test.c:139:22: warning: no newline at end of file
net/mptcp/token_test.c:68:29: warning: incorrect type in assignment (different address spaces)
net/mptcp/token_test.c:68:29:    expected void [noderef] __rcu *icsk_ulp_data
net/mptcp/token_test.c:68:29:    got struct mptcp_subflow_context *ctx
