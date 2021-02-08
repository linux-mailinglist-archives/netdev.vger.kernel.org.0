Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B91313B9D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhBHRxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233901AbhBHRwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:52:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65F6D64E7D;
        Mon,  8 Feb 2021 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612806710;
        bh=bCiGBXtCLN+Ucd3tEwkHpGMNdULn+ciI9GbwA8Nbmfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cT7oZVYE6NnaFcS8p4ImS+l/vIthyQDFVO8yBagTXoHMz4ryRjRBa84NtDN1nR6qY
         Jr2+i4yrHV65R9qhhenuuuNoddeTY5xjd4Z6AxDV/CcuUSgNh0xo5kJXLtBrr0laaU
         kUTbx4ZH0i6qdjE4SJ3rx/SBs4I/uSALcmmBxFXQdpEP/4zAwmzBqIOMnugyMhMEZZ
         xODPnAVefbrUVUy1ygbAI1PzhVMQWucwOml9MqjuzBON+myXvTebiE15mBgZTyHPix
         mNf3w+aY7QyudWZB6j2Byr/x08aPzbUMIE7nCTbLQW+qpHNqq09zE8MZzpz1hAFUNk
         EskCZPF3D0XcA==
Date:   Mon, 8 Feb 2021 09:51:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: pull-request: wireless-drivers-2021-02-05
Message-ID: <20210208095149.1b7c1074@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208082253.GA2593@lore-desk>
References: <20210205163434.14D94C433ED@smtp.codeaurora.org>
        <20210206093537.0bfaf0db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210206194325.GA134674@lore-desk>
        <87r1ls5svl.fsf@codeaurora.org>
        <CAJ0CqmUkyKN_1MxSKejp90ONBtCTrsF1HUGRdh9+xNkdEjcwPg@mail.gmail.com>
        <87mtwf562q.fsf@codeaurora.org>
        <20210208082253.GA2593@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 09:22:53 +0100 Lorenzo Bianconi wrote:
> > > I will post two followup patches later today. I think the issues are
> > > not harmful but it will be easier to post them to wireless-drivers
> > > tree, agree?  
> > 
> > Most likely Linus releases the final v5.11 next Sunday, so we are very
> > close to release. If this is not urgent I would rather wait for the
> > merge window to open (on Sunday) and apply the patch for v5.12 to avoid
> > a last minute rush. Would that work?  
> 
> Sure, I guess it is not urgent.

Agreed, thanks!
