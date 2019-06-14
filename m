Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373FC4553D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfFNHJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 03:09:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35032 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfFNHJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 03:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k4RbWCbwBcKE2XaM1Q8HPG0quV1RdhqSycPKyg7Zrao=; b=lBEX2ynm4Dm3tZONdLQa1fe75
        KnebKJCLoxzlvi0RMdFG7oJnvKBMFVyYXunjh3eHJYXL4X3WhyZtUB/2wYMaO3eJ6gQR4JiPmI9E1
        JiOMxL8PPvdfhoL3ydZJMBiBM6WfZ89J5X5lSqtWW0Gi1yNg+AwzE76UYPZPmMASz000/ZHV3sGeW
        iAduEXHKODxPrAsPwo3VuIW/4Z4T5xKM00hB9q+Z916GkPNpzOZuIvb+wr5ko4Rmi2wGgi39oUSvf
        GDxQs5kfwaKjwUn1+fKPKI0zbVm17BfhnJIkpDhkXL0cfsNMCCZqKB87mkKgqQLrDmaO71aeaWWJU
        QQ96qSbuA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbgKU-0004cU-Te; Fri, 14 Jun 2019 07:08:55 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 43EA020A15636; Fri, 14 Jun 2019 09:08:52 +0200 (CEST)
Date:   Fri, 14 Jun 2019 09:08:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 2/9] objtool: Fix ORC unwinding in non-JIT BPF generated
 code
Message-ID: <20190614070852.GQ3436@hirez.programming.kicks-ass.net>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
 <20190613205710.et5fywop4gfalsa6@ast-mbp.dhcp.thefacebook.com>
 <20190614012030.b6eujm7b4psu62kj@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614012030.b6eujm7b4psu62kj@treble>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 08:20:30PM -0500, Josh Poimboeuf wrote:
> On Thu, Jun 13, 2019 at 01:57:11PM -0700, Alexei Starovoitov wrote:

> > and to patches 8 and 9.
> 
> Well, it's your code, but ... can I ask why?  AT&T syntax is the
> standard for Linux, which is in fact the OS we are developing for.

I agree, all assembly in Linux is AT&T, adding Intel notation only
serves to cause confusion.
