Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7826320F966
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387810AbgF3Q0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387434AbgF3Q0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 12:26:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B94206BE;
        Tue, 30 Jun 2020 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593534406;
        bh=LepBiuzFP0vqeERpZtYouE+9jvZcJiHHMFzk8JoxjZY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H4kVkmdgvimCpEsoWFiYQLEX9kBEvIIawPSPqj8xGeenuGg6swrDykmI/6cV9FPCr
         oN2+ZbOAVZxWaz9Cg9qOJXhfLgCYEPH3Jd8mkcWNzhL4NQz40KZfEe53l4PM4v2Bmt
         VJ2qph6JI++N/4wt63JfP9EtIyGgY5y5/8DAsmEQ=
Date:   Tue, 30 Jun 2020 09:26:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yousuk Seung <ysseung@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH net-next] tcp: call tcp_ack_tstamp() when not fully
 acked
Message-ID: <20200630092644.131af53c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200630020132.2332374-1-ysseung@google.com>
References: <20200630020132.2332374-1-ysseung@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 19:01:32 -0700 Yousuk Seung wrote:
> When skb is coalesced tcp_ack_tstamp() still needs to be called when not
> fully acked in tcp_clean_rtx_queue(), otherwise SCM_TSTAMP_ACK
> timestamps may never be fired. Since the original patch series had
> dependent commits, this patch fixes the issue instead of reverting by
> restoring calls to tcp_ack_tstamp() when skb is not fully acked.
> 
> Fixes: fdb7eb21ddd3 ("tcp: stamp SCM_TSTAMP_ACK later in tcp_clean_rtx_queue())
> Signed-off-by: Yousuk Seung <ysseung@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Fixes tag: Fixes: fdb7eb21ddd3 ("tcp: stamp SCM_TSTAMP_ACK later in tcp_clean_rtx_queue())
Has these problem(s):
	- Subject has leading but no trailing quotes
