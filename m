Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C442C6E49
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbgK1Bw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 20:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730301AbgK1BqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 20:46:15 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77D6422245;
        Sat, 28 Nov 2020 01:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606527480;
        bh=xjoBRj8lNe3pFLGJfMSdn9YhJbS//eW7jNEtaknfjRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=atX4fEJuxwnALezSi9FaGZUYianc6cnjrmhy2mJeC22Up1WMIKmDacAY9Rs40QicE
         3JUA9vjVt5gCzyv6jHCiatN1UM+VyBS/vQnZekwAWDiwRepSIwhFouzHaHddw1dbDx
         p72kCyt4GZfD380XBWJAk+8M1wjt8rrrSYLuyqV8=
Date:   Fri, 27 Nov 2020 17:37:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     jmaloy@redhat.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Subject: Re: [net-next v2 0/3] tipc: some minor improvements
Message-ID: <20201127173759.72017b52@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201125182915.711370-1-jmaloy@redhat.com>
References: <20201125182915.711370-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 13:29:12 -0500 jmaloy@redhat.com wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> We add some improvements that will be useful in future commits.

Applied, thanks!
