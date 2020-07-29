Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FA9232746
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgG2WDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgG2WDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 18:03:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EC52070B;
        Wed, 29 Jul 2020 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596060185;
        bh=LD9BhmIzX4YumPHb5UlSPSVhGGoH73D44GF0F7CO2KM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t1Z2YYv/zGzV0WjL6nMyk9d4+0lxJ5BK5pzCLoBg+KXA6KgnpM9uz/9UJR8T6NUfp
         /Gry3A4MRb8H2cT0E9TIDZDoY8MRdV1kYf2eeW6ShLXH19PmXGIUH26VRrbRi6m1PU
         xI9JKvzi+AKoI6ur+8IpK5u15en1pAEC0VlG6tvA=
Date:   Wed, 29 Jul 2020 15:03:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next] hinic: add generating mailbox random index
 support
Message-ID: <20200729150303.0cbe7948@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200729005919.11293-1-luobin9@huawei.com>
References: <20200729005919.11293-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 08:59:19 +0800 Luo bin wrote:
> add support to generate mailbox random id for VF to ensure that
> the mailbox message from VF is valid and PF should check whether
> the cmd from VF is supported before passing it to hw.

This is hard to review. I don't see how the addition of
hinic_mbox_check_cmd_valid() correlates to the random id 
thing. Please split this into two or more patches making
one logical change each.

