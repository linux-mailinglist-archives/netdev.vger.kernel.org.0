Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AE5258172
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgHaS7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgHaS7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 14:59:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 785BD206FA;
        Mon, 31 Aug 2020 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598900361;
        bh=5UgcUqxc/SGYEeJgPb8komp3CVw3WewY9q80HuOrfc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eeCcECK49tqdgHitTotsiExHWwk0a6II0jf0NI0iSO/h/8sFZ1Eu7rBiw1oTnvumV
         PaWjlo1TKCtguo7k3SpxRyhGQ9/PW8i8wPaPkkejyK4qcGGyOnQ2IjWqJG+CH7VMdx
         N6+1IU91pXVizwWGc1RtevE2TEzO0D4VN04olN3U=
Date:   Mon, 31 Aug 2020 11:59:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next v3 1/3] hinic: add support to query sq info
Message-ID: <20200831115920.71969dbc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200829005520.27364-2-luobin9@huawei.com>
References: <20200829005520.27364-1-luobin9@huawei.com>
        <20200829005520.27364-2-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Aug 2020 08:55:18 +0800 Luo bin wrote:
> add debugfs node for querying sq info, for example:
> cat /sys/kernel/debug/hinic/0000:15:00.0/SQs/0x0/sq_pi
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
