Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2E22C2CCB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390356AbgKXQYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:24:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbgKXQYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:24:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12C1920715;
        Tue, 24 Nov 2020 16:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606235089;
        bh=1Vn4Wt8OwoULfCk6TfBwQGf9M5km1Nq74a6ad2SKloA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pxfCcQ+HNCRsVfWVXd7f+0ykX9zJz8aMSaAsCc266ybL3MKKAenFJcf04Ubj8z7w7
         17M2ASgbH2t6Nlq7rnNAvfx3aQ6M5R+x8ETIiSM9U0BjkAktlBGwo/zcwFbuCMBnOL
         WZBCCITO5Oy7yZkQf3rwryr2eewhcLQp2Q6xYHow=
Date:   Tue, 24 Nov 2020 08:24:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: alias action flags with TCA_ACT_
 prefix
Message-ID: <20201124082448.56a03de5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87v9dv9k8q.fsf@buslov.dev>
References: <20201121160902.808705-1-vlad@buslov.dev>
        <20201123132244.55768678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v9dv9k8q.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 11:28:37 +0200 Vlad Buslov wrote:
> > TCA_FLAG_TERSE_DUMP exists only in net-next, we could rename it, right?  
> 
> You are right. I'll send a fix.

You mean v2, not a follow up, right? :)
