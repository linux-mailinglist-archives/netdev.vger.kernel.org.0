Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C591473173
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbhLMQSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:18:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35784 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbhLMQSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:18:08 -0500
Date:   Mon, 13 Dec 2021 17:18:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639412286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yhwBkvANimoH2o2ZBk6VaDOT564TAGPulkgSY9BNt1c=;
        b=hM9FzCRR9441ojjTppJgUd6dU9PLRuqkXNdQSov9Hxqa9G0pNqdcNf7ruQhjN4P7LJRCP9
        Y/8+4izBXsjgOT4uUUEt6+H1SDRj9Zi67vyXN4V0th0ZtWA6t2X5erfOVmBllbYy612Itk
        TCro7qKiOvgq2sNEcKIh91GxTTEzPw5RZb5VnXwEHq6q0boHqjSAJ3NPg1+eZibGl/tKOe
        puKqNv6AA7JcsmPHpX0iW0vHImVLk4jgl9QeSbwRnM+TD/WfeI11wSakD4KeR2RQXNrhoi
        V/CbcPH4m3Swa7UyQUr3JhirqMDSKf6jCmigQ7VbL+gtOPmtFXp6rW4e9Okh9g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639412286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yhwBkvANimoH2o2ZBk6VaDOT564TAGPulkgSY9BNt1c=;
        b=xDPlG5NRY+E9gqdp6n6/UCFeCQ6q70tDbLhTsXrvvEqm1XWgMn3G9IzVzZlWnFOOVgSXTW
        HifDCFgI4u3ZsfCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <YbdyPR0keP1wJmCC@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
 <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbckZ8VxICTThXOn@linutronix.de>
 <20211213081556.1a575a28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213081556.1a575a28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-13 08:15:56 [-0800], Jakub Kicinski wrote:
> FWIW I disagree. My version was more readable. The sprinkling of the
> PREEMPT_RT tosh is getting a little annoying. Trying to regress the 
> clarity of the code should be top of mind here.

No worries. Let me spin a new version with a swap.

Sebastian
