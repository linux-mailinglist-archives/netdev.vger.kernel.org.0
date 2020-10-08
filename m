Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE7287BFD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgJHTBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgJHTBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 15:01:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A1AE207DE;
        Thu,  8 Oct 2020 19:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602183664;
        bh=u1+nAdeduhuzNSeqC+wxHGVbWEObfY1vCaEpzelvXt8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1UWCNxhpsk25BfUUCGQ7X9C7EIlcLJHmh8wy3CkyRUzIbxyvnZHx/bmOp/YZGu7gB
         NU9kTI9YcKmTh0qUqAV8Qmr1WPRuITbBgqc/89l9nLF+tB6iQpf/MhjSTqLOVt0R6C
         ZMhydLMRsWBiyMeUGIicLFA5DKpi7Ci+0uNxuok4=
Date:   Thu, 8 Oct 2020 12:01:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>
Subject: Re: [PATCH net-next] virtio_net: handle non-napi callers to
 virtnet_poll_tx
Message-ID: <20201008120102.0167559c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008183436.3093286-1-jonathan.lemon@gmail.com>
References: <20201008183436.3093286-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 11:34:36 -0700 Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> netcons will call napi_poll with a budget of 0, indicating
> a non-napi caller (and also called with irqs disabled).  Call
> free_old_xmit_skbs() with the is_napi parameter set correctly.

This is a fix, can we get a Fixes tag, please?
