Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98144F7876
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfKKQKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:10:53 -0500
Received: from ms.lwn.net ([45.79.88.28]:34572 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfKKQKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 11:10:53 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 710522C0;
        Mon, 11 Nov 2019 16:10:52 +0000 (UTC)
Date:   Mon, 11 Nov 2019 09:10:50 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     David Miller <davem@davemloft.net>, alexei.starovoitov@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, Kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Message-ID: <20191111091050.3ece5112@lwn.net>
In-Reply-To: <20191111081403.GM4131@hirez.programming.kicks-ass.net>
References: <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
        <CAADnVQKmrVGVHM70OT0jc7reRp1LdWTM8dhE1Gde21oxw++jwg@mail.gmail.com>
        <20191108213624.GM3079@worktop.programming.kicks-ass.net>
        <20191108.133924.1397692397131607421.davem@davemloft.net>
        <20191111081403.GM4131@hirez.programming.kicks-ass.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 09:14:03 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Nov 08, 2019 at 01:39:24PM -0800, David Miller wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Fri, 8 Nov 2019 22:36:24 +0100
> >   
> > > The cover leter is not preserved and should therefore  
> >  ...
> > 
> > The cover letter is +ALWAYS+ preserved, we put them in the merge
> > commit.  
> 
> Good to know; is this a netdev special? I've not seen this before.

I read a *lot* of merge commit changelogs; it's not just netdev that does
this.  I try to do it with significant documentation sets as well.  I
agree that changelogs should contain all relevant information, but there
is value in an overview as well.  But then, I make my living in the
overview business...:)

jon
