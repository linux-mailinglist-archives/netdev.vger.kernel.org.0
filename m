Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF953923FE
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhE0A6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233477AbhE0A6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 894A1613C5;
        Thu, 27 May 2021 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622077023;
        bh=+G7xvxkLFc3VlIyRwZDKT3qI02CFK1IsWtJmXxIksUc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J7chhBvYwXGwa+a6tV/dXB5nWFjHR88HqdIw3gBhYTyAVYmcClfkAPbtyGxBkl0Q7
         jep92VKC8Id33wLcQPgk4BTAiZYSR3i8KlDOWyrWhmxyO3BZZB4rpRRHPFLAd04sCi
         oMF59qywCb4QuMIkQipfUyoExiglwIrN8MJTAnoFFORdWjRcG97EDeznvGhaFvz14Q
         kQbzJmDp99f2b1vMJAQ6AVbU77l9Cxrhw3Z9yA2mgg83m5+PAe+cakJorFo6gybwJq
         1gk50rtFUeqpK8tu5rVSUHNDA3/dRV6AP/RaFyH5Lxb1D76j9aTo3P9MK2rj5SIc8E
         7XBXk7bmxxHPA==
Date:   Wed, 26 May 2021 17:57:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <xie.he.0141@gmail.com>, <ms@dev.tdt.de>,
        <willemb@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>
Subject: Re: [PATCH net-next 01/10] net: wan: remove redundant blank lines
Message-ID: <20210526175702.5aecd246@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1622029495-30357-2-git-send-email-huangguangbin2@huawei.com>
References: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
        <1622029495-30357-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 19:44:46 +0800 Guangbin Huang wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patch removes some redundant blank lines.

We already have 4 commits with this exact subject and message in
the tree:

98d728232c98 net: wan: remove redundant blank lines
8890d0a1891a net: wan: remove redundant blank lines
145efe6c279b net: wan: remove redundant blank lines
78524c01edb2 net: wan: remove redundant blank lines

Please use appropriate commit prefix, for example for this series
"net: hdlc_fr:".
