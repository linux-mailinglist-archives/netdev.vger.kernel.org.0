Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990C8326A88
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhBZXzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhBZXzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:55:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C35C264EC4;
        Fri, 26 Feb 2021 23:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614383678;
        bh=ZyRF7M8EAoVQk10JZDlX+BxAX1/HXD3aXd6oYrew6Ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gH0M9lJ4/Grg8CE14UPeVrVcuAjh6iZnWJVRi+9/rmIDIQg1qmy/rJqfS9OOpvr/5
         TMgwzyxVx7lRas/DQLt2JSaoYtKctabpyJl2MoHS6eQMOizs+oCSKwoS+Jm4cmiFYB
         MN+WHf2bDnmCbDmwkesaWq2uju3C1859v2Bw6uNSZzR/Glw2PTuK9sJiTb9ZvFJ7KJ
         q1H37HmojLAmf753HW3acmlwp2YalCXtQhxrmVB2v//W86Gq6Hg1FoBuJ7QEcsA9Uz
         0p1X5TOAkhTP9hXkwTEN/AUwmDfs0DFy2C87K5n+Ju7hsql/PKb8P+UCm0RvnllNrv
         mTTHm5N53YjQg==
Date:   Fri, 26 Feb 2021 15:54:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
Message-ID: <20210226155436.69c81cc2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTSdCnCKFrpe-G55rPCq_D7uv4EaQ4z8XW2MOtTRKcWVJYQ@mail.gmail.com>
References: <20210225234631.2547776-1-Jason@zx2c4.com>
        <CA+FuTScmM12PG96k8ZjGd1zCjAaGzjk3cOS+xam+_h6sx2_HDA@mail.gmail.com>
        <CAHmME9o2yPQ+Ai12XcCjF3jMVcMT_aooFCeKkfgFFOnqPmK_yg@mail.gmail.com>
        <CA+FuTSdCnCKFrpe-G55rPCq_D7uv4EaQ4z8XW2MOtTRKcWVJYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 18:28:56 -0500 Willem de Bruijn wrote:
> Please cc: the maintainers for patches that are meant to be merged, btw.

I was about to say. Please repost.
