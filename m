Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039C92F8919
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbhAOXDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:03:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbhAOXDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 18:03:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DFAC23339;
        Fri, 15 Jan 2021 23:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610751767;
        bh=PDPMJXLXN0TL5O/SI7tDKEqEVoDMjZF28//7T7pn4AY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WqxhRB5kDJq15sQEmPKOHT9GidWDbndKCoIzb5Brf8rqhCRcYF88LFNih9W5ic7Ir
         /2ZxDr/sVonNCopp66NOkAPRyJJvBt67O7t4QjGZKokrAzjF90v2sfWOqLeghAUdt1
         HkxEQ2bYhfKBgg/6ftSW/vbLmmleed7FJrb81d8yafb0skT/2bluUMsMrqp9XO3pVE
         TcWZs8gkBtgseWX6Oi+3V1hJfE0VljC2mkuhSqtpefxDh2s4pIWxRQkwNMfDn0fWXK
         8s4okv6Q5PS9TezEw7rUH5z/jZJEqvgT+xc3nlpE9JVFUMTQM5U+kmVDAYTO6PJu6o
         Ctj3gGb/jzcoQ==
Date:   Fri, 15 Jan 2021 15:02:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: LAG fixes
Message-ID: <20210115150246.550ae169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115125259.22542-1-tobias@waldekranz.com>
References: <20210115125259.22542-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 13:52:57 +0100 Tobias Waldekranz wrote:
> The kernel test robot kindly pointed out that Global 2 support in
> mv88e6xxx is optional.
> 
> This also made me realize that we should verify that the hardware
> actually supports LAG offloading before trying to configure it.
> 
> v1 -> v2:
> - Do not allocate LAG ID mappings on unsupported hardware (Vladimir).
> - Simplify _has_lag predicate (Vladimir).

If I'm reading the discussion on v1 right there will be a v3,
LMK if I got it wrong.
