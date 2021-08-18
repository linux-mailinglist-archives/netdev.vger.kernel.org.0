Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485423EF6E3
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 02:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbhHRAdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 20:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232410AbhHRAdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 20:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2B4460551;
        Wed, 18 Aug 2021 00:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629246747;
        bh=G40XdFtl+lVsj8R2HHLRnmoxhF0m8ERwjEALnqmXa0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xy7tZWB+G4RX8WFtkwlFfWVCANDQMe7IqcIRqb32XgQFUPFGl2x0iYy3jJs/83kzl
         KZP2T5aky2JIWVV7GOr2i/LGSUcwUDGjwMNznGqkCX3WmGhu7V+A6HTCL6RoaT9EJM
         4HWJ26mUdsAuwsz8uLLjC0MLP/jRYxHrzRGMVK6uxmAwNdRHt5k7ewZHeGm9EPyS7Q
         LwPWzB4sOBRdtuaOCG2vex358FAunxGr7hB7dnfmuATYAv1Doe4O2H4bXoWoXcVPSe
         1rVc9RemYtr2SMuFn8dVyNe4Df8zlOQnXGwLfLYf+11iAglVPB87EI1iy0B8kfpES8
         vzJCI5F9TB9bw==
Date:   Tue, 17 Aug 2021 17:32:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicholas Richardson <richardsonnick@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nrrichar@ncsu.edu,
        promanov@google.com, arunkaly@google.com,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Di Zhu <zhudi21@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>,
        Leesoo Ahn <dev@ooseel.net>, Ye Bin <yebin10@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] pktgen: Add IMIX mode
Message-ID: <20210817173226.1f77dd54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210817235141.1136355-1-richardsonnick@google.com>
References: <20210817235141.1136355-1-richardsonnick@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 23:51:35 +0000 Nicholas Richardson wrote:
> From: Nick Richardson <richardsonnick@google.com>
> 
> Adds internet mix (IMIX) mode to pktgen. Internet mix is
> included in many user-space network perf testing tools. It allows
> for the user to specify a distribution of discrete packet sizes to be
> generated. This type of test is common among vendors when perf testing 
> their devices.
> [RFC link: https://datatracker.ietf.org/doc/html/rfc2544#section-9.1]

The previous version was already applied and can't be dropped.
Please send a incremental fix.
