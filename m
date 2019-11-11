Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28D49F6F94
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 09:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfKKIOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 03:14:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfKKIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 03:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7c6KOc9PXt8sYF2qW2Nd+YShPoSjXANPYV/7Nqo0zZA=; b=Mo0k4bAkKxS6eH6z1SkXE87TI
        66rB1bEDpIl3gg5btBt9HYw1d5gmygizq3qQK7cJnxTR5uYYnD0CS1G+VT4McKHkQeulWcczeHReP
        HtpUKxWkyS1Euti+mzDcRDaAZzbwYl2sOu43vFaVmzk/+Pqv8tcobj1FBmzHYAI84l2Q0JIDqL1Bl
        m8oAngNtDPBOUcRnvliZIsrGlqOCFD3EVpoR/OGXmfnohEVz39DZ3YwyBnMH34kFWORgTwQdNeMs/
        acEddsPbOOUqrFYD2c7vOkZTpiwSMhgShizXBUcGlcNCkqz8RgbQyat1Fy+bZ2p1CLxF9ZCbGDrbN
        gXdIlb5cQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iU4pq-0007xS-Af; Mon, 11 Nov 2019 08:14:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 94C3C3056BE;
        Mon, 11 Nov 2019 09:12:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 942682027043D; Mon, 11 Nov 2019 09:14:03 +0100 (CET)
Date:   Mon, 11 Nov 2019 09:14:03 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     alexei.starovoitov@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        x86@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Message-ID: <20191111081403.GM4131@hirez.programming.kicks-ass.net>
References: <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
 <CAADnVQKmrVGVHM70OT0jc7reRp1LdWTM8dhE1Gde21oxw++jwg@mail.gmail.com>
 <20191108213624.GM3079@worktop.programming.kicks-ass.net>
 <20191108.133924.1397692397131607421.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108.133924.1397692397131607421.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 01:39:24PM -0800, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 8 Nov 2019 22:36:24 +0100
> 
> > The cover leter is not preserved and should therefore
>  ...
> 
> The cover letter is +ALWAYS+ preserved, we put them in the merge
> commit.

Good to know; is this a netdev special? I've not seen this before.

Is there a convenient git command to find the merge commit for a given
regular commit? Say I've used git-blame to find a troublesome commit,
then how do I find the merge commit for it?

Also, I still think this does not excuse weak individual Changelogs.
