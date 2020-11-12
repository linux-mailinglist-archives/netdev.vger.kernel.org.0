Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767652B1280
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgKLXIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgKLXId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:08:33 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEAE620797;
        Thu, 12 Nov 2020 23:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605222513;
        bh=T/s0MOU8r30ePQyHLcblDvGDzyMcAG55W3MTMljzs6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yrnh4phPDy7P+Ir6dAsDvVuxEo2R+xjcIGpzFjZLK4Ot6sjZDUohMTCZVZ+limnb0
         a0bmtO5v7GId6VGRs3/GdEFXxjlt8zdi0A+d884w0hyPOSXX9YUvWqN2Bpejt8ARNK
         pjbQ6ChDd2hbeZSs6moo2/h+dZUy/QPEykE2owcQ=
Date:   Thu, 12 Nov 2020 15:08:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 01/13] tcp: factor out tcp_build_frag()
Message-ID: <20201112150831.1c4bb8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8fcb0ad6f324008ccadfd1811d91b3145bbf95fd.1605199807.git.pabeni@redhat.com>
References: <cover.1605199807.git.pabeni@redhat.com>
        <8fcb0ad6f324008ccadfd1811d91b3145bbf95fd.1605199807.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 18:45:21 +0100 Paolo Abeni wrote:
> +		skb = sk_stream_alloc_skb(sk, 0, sk->sk_allocation,
> +				tcp_rtx_and_write_queues_empty(sk));

no good reason to misalign this AFAICT
