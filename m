Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2255C1CD02E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 05:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgEKDH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 23:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgEKDH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 23:07:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D55F624974;
        Mon, 11 May 2020 03:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589166479;
        bh=abxYgNFlEwXNGsZ6KzRy0a5qyRKkv3JxtvsGEpHaz6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tD6ftBHV+/dCUNFdV0XFZbv7+/SeqX//OcrEvRt/xU5KfXvkNxcAOLXZ8mKbXpd6B
         vXIDtn3CHRfTNksR4vz5GWQfZIcHxNLEQhQ/zqgl1iEcLATxabqmgYoTstZ4MclJx+
         OLQXU07sPvZ+NxqBQvD/PVXwKA0S3axrX45+/HsU=
Date:   Sun, 10 May 2020 20:07:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net v3] hinic: fix a bug of ndo_stop
Message-ID: <20200510200757.13df2439@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200510190108.22847-1-luobin9@huawei.com>
References: <20200510190108.22847-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 19:01:08 +0000 Luo bin wrote:
> if some function in ndo_stop interface returns failure because of
> hardware fault, must go on excuting rest steps rather than return
> failure directly, otherwise will cause memory leak.And bump the
> timeout for SET_FUNC_STATE to ensure that cmd won't return failure
> when hw is busy. Otherwise hw may stomp host memory if we free
> memory regardless of the return value of SET_FUNC_STATE.
> 
> Fixes: 51ba902a16e6 ("net-next/hinic: Initialize hw interface")
> Signed-off-by: Luo bin <luobin9@huawei.com>

Applied, thank you.
