Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4425453F12
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhKQDpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhKQDpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:45:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9191261A64;
        Wed, 17 Nov 2021 03:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637120538;
        bh=+l3JuE8MsnQEtW1urld0f8NM7Yz6o2/WbLG3grWrRU8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f+R3GZXKrggc0bhM348ARAuh8N+FfJn2sH+Q+Q5tWAsx2GxdHh1p8nXQlb7vdBxUG
         2ne7lmepfF+cUmpJSXJ5lDqe0aJashCgpwQVjtfjdpzJa2iQd2wxNYjZwvr2kcTg7v
         S/EBDDNeTOMq3peEYZi8jf9MdP32qOqF1zVAXjCdYVdIKjtVjriE8BZt/nCuw/ccYt
         d5d0FAv0/TdiUHz31zKJF2tSi/DUFEfZYvUCdkjeb3/ah6jq2mfNOkejl4s9frebv3
         8SeBXAHYlBEpGqgroKiVulB6Piru1vfzqqm6fkkWZWNDqlykXM1zDhrHaHayGArMXW
         F7/MlsFFJD9Ug==
Date:   Tue, 16 Nov 2021 19:42:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net 0/2] net: fix the mirred packet drop due to the
 incorrect dst
Message-ID: <20211116194217.5c16b78e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1636734751.git.lucien.xin@gmail.com>
References: <cover.1636734751.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 11:33:10 -0500 Xin Long wrote:
> This issue was found when using OVS HWOL on OVN-k8s. These packets
> dropped on rx path were seen with output dst, which should've been
> dropped from the skbs when redirecting them.
> 
> The 1st patch is to the fix and the 2nd is a selftest to reproduce
> and verify it.

Applied, thanks!
