Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C383E261BAF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731572AbgIHTGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731214AbgIHTFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 15:05:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0B10206DB;
        Tue,  8 Sep 2020 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599591940;
        bh=bvJMSfVCBdBWy15G1E8xhzkMq027MrMy34f0DRh54K0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f8sth351qL3WxQ04WSlLz2hj01zjjnH5vA02L5mqF6LqQcJxK6XH0eAFhtpjTfbyv
         HYn9MQvbgcHLrKkAB8/RD0BJ9wktGJqu+fNHP9UmIQSyFSvH/qnJ1ghCfG1Tteo3H7
         fJDLN/r1Ddh+T5NuYUhOJ7Fe7TVquAtR8DcNH26w=
Date:   Tue, 8 Sep 2020 12:05:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 0/7] net: hns3: misc updates
Message-ID: <20200908120538.4ba70787@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
References: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 10:59:47 +0800 Huazhong Tan wrote:
> There are some misc updates for the HNS3 ethernet driver.
> 
> #1 narrows two local variable range in hclgevf_reset_prepare_wait().
> #2 adds reset failure check in periodic service task.
> #3~#7 adds some cleanups.

Looks trivial:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
