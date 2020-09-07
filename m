Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37492260544
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgIGTuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgIGTuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 15:50:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A69621532;
        Mon,  7 Sep 2020 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599508206;
        bh=M5OYcR4m+EqEtkMC81feY55AZj2KopYR9aNotzpviHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n+5Ao0h7eW3X7KVFIgQZUlol++U7I3cQIZsG9vXoHfbrf9Cf4seeeV6cMVEnl6+kG
         vt1rrxPNaolfr0vXt8TFRf5a09hikwbvH1eejlUqRe4Hpr4w/8H6P4JMBb8/5SHf/+
         iVzrP1LjV3OV2thoq65Z5SCcXdkkKIb2mZZGzXPA=
Date:   Mon, 7 Sep 2020 12:50:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net] netdevice.h: fix xdp_state kernel-doc warning
Message-ID: <20200907125005.3df7dfeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c50a22ba-a6ce-186a-a061-f9326d10914c@infradead.org>
References: <c50a22ba-a6ce-186a-a061-f9326d10914c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 20:32:30 -0700 Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix kernel-doc warning in <linux/netdevice.h>:
> 
> ../include/linux/netdevice.h:2158: warning: Function parameter or member 'xdp_state' not described in 'net_device'
> 
> Fixes: 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
