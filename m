Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419E5290E32
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 01:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411420AbgJPXcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 19:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393631AbgJPXcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 19:32:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CE0C20878;
        Fri, 16 Oct 2020 23:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602891170;
        bh=6pL1XCVytgmpRnR4l50cm/43H5MnqCsPmvMDP0dsgeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qKxVXH2gVDAeY3+r52ZyJ4SQ7GDqzkoQkqC6xja/S/MPJKffa1kIanTo750ozfbAy
         Pgoa7A9Vgd0DI/xZVQJD7TUKgiMKbZB+n9lA/zSoseEgb2l520n/lxRz/LVRHFucN7
         zIzYA/DcFo0yaQAYSwK/HpB9RkQUrjbXCKehkeUY=
Date:   Fri, 16 Oct 2020 16:32:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     davem@davemloft.net, skhan@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCHv4] selftests: rtnetlink: load fou module for
 kci_test_encap_fou() test
Message-ID: <20201016163248.57af2b95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016041211.18827-1-po-hsu.lin@canonical.com>
References: <20201016041211.18827-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 12:12:11 +0800 Po-Hsu Lin wrote:
> The kci_test_encap_fou() test from kci_test_encap() in rtnetlink.sh
> needs the fou module to work. Otherwise it will fail with:
> 
>   $ ip netns exec "$testns" ip fou add port 7777 ipproto 47
>   RTNETLINK answers: No such file or directory
>   Error talking to the kernel
> 
> Add the CONFIG_NET_FOU into the config file as well. Which needs at
> least to be set as a loadable module.
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Doesn't apply :( Could you rebase on top of:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
