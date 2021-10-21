Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CEC436D70
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhJUW2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhJUW17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 18:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB860610C8;
        Thu, 21 Oct 2021 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634855143;
        bh=P53xN0HFhBDKg5N+w+paAcJWqc4j9qmF1P2F3vps5l0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HwcNMAO9ShDZxFbxJpdKKg+nqv8lb1dAumhFWjGpPHdqNsNM5K0cN1af8rj6FiMap
         k63x/HIJI9bDrpc8nukMsGoKR2XSvYxoNROCLuIW5qAYnx8OvQ+x2VUIAq5aPvsPSi
         SpEckfGOtVFC7bNiz4UJVNTJZPXiqMyM1rRS8bNbSiZ7cJM94pKiT6r2WWqs+lyU/W
         MqJkdgrnuGwMT9xhRC57GyI1liEiDawxaFqKpEEbuXjvsZiXZwUSw1S9aJaIZSGaei
         PbYQB1PxlQvLH1WrHBP/xrZ/UmM1SzqgQkC4bJDTwDB+WocnmojQw5+/V+DrPEXs26
         MkDQ/jJS/3Q+w==
Date:   Thu, 21 Oct 2021 15:25:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        dsahern@kernel.org, pablo@netfilter.org, crosser@average.org,
        lschlesinger@drivenets.com
Subject: Re: [PATCH net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
Message-ID: <20211021152541.48340f37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211021144857.29714-3-fw@strlen.de>
References: <20211021144857.29714-1-fw@strlen.de>
        <20211021144857.29714-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 16:48:57 +0200 Florian Westphal wrote:
> +		nf_ct_set(skb, 0, IP_CT_UNTRACKED);

drivers/net/vrf.c:431:32: warning: Using plain integer as NULL pointer
