Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6743146A1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBICt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:49:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhBICtz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 21:49:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC79C64E3B;
        Tue,  9 Feb 2021 02:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612838954;
        bh=oliKdDZxJ0h7FjRqssiDLuKSuMkP6ehrQ1TJE8eR8KQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ERct2oJxALf/xDyd2plPjtjuvU4G8s5iFOKlhr8qnWw450CT0KDdjfkZWXI2tNGG1
         p16HoDZbnFUiPcxw86NSHI8JQWKTyFNCCbwuhV6D7zX+zt/52wzakY+4Y9INeyI4B9
         SkSIDJy7xFrJnJhHJZjvDu1YvTUcSjRJ0uHwOvg0CJHcbdypJxHZBvlF0nrD0fLF8U
         Yb0sCevDgx0nLrN0THXhOmAyxI1/gSe2k2n/J+39GZktcXtEV5qd5Cmpwqi+zKGVe3
         vNbjFV4hOXQv4Dqp92xG2VhlyXsZ92RNiLmwYywVfpJ2CEdq3jRm4SPvC44r6zvmNG
         0Z5/fR318Tgzw==
Date:   Mon, 8 Feb 2021 18:49:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>
Subject: Re: [PATCH V2 net-next 00/11] net: hns3: some cleanups for -next
Message-ID: <20210208184912.506ea430@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
References: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 10:41:50 +0800 Huazhong Tan wrote:
> There are some cleanups for the HNS3 ethernet driver.
> 
> change log:
> V2: remove previous #3 which should target net.
> 
> previous version:
> V1: https://patchwork.kernel.org/project/netdevbpf/cover/1612784382-27262-1-git-send-email-tanhuazhong@huawei.com/

Thank you!

Acked-by: Jakub Kicinski <kuba@kernel.org>
