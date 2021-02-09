Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723A03155C8
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhBISW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233056AbhBISTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 13:19:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED69B60C41;
        Tue,  9 Feb 2021 18:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612894700;
        bh=tAVP255E1NFtk8A5SEiRaLvt6rxH9PThmZ/rIu2QbEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IJQZY0UpmKYO125mu/O3rA0txCm7q5cY0e/QR8myC6wu3Ns2TCdadFpUOuBWmhkAJ
         Y/LdyXHy9mFB7inOhDrqEMHEk0h4ByvyyAL+D9Jk7GJBJRIaxQd2u6GVmZZ1Sk6WK9
         Qi8/pCdAU3kwmDJEuwNjUqv+4UtkeCIdgfUBgBKDGki/uQg8y+r2121btDh8XB5yIv
         0+kAmr1tTpEVy4TPeVZWGNN4kFNU1i3+zq9Eq/EApX4JA3p2C269Y8/8PuT/l+A2j1
         xIeFT79+XaPN9rASlgAYQgA5JpEEbr0dPhJwEF+XvL4e5KfQ20V+hRgKx/e5S8RZhF
         f4c5xlntNe/vQ==
Date:   Tue, 9 Feb 2021 10:18:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>
Subject: Re: [PATCH net 0/3] net: hns3: fixes for -net
Message-ID: <20210209101818.0c907fd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
References: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 17:03:04 +0800 Huazhong Tan wrote:
> The parameters sent from vf may be unreliable. If these
> parameters are used directly, memory overwriting may occur.

Acked-by: Jakub Kicinski <kuba@kernel.org>
