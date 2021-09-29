Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603C841CFE9
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346853AbhI2X1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:27:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40686 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245025AbhI2X1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 19:27:40 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2021 19:27:39 EDT
Received: by one.firstfloor.org (Postfix, from userid 503)
        id 271A6870CD; Thu, 30 Sep 2021 01:20:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1632957641;
        bh=AaZJWxUP4TSjgMgB6emAMxjdQZa18XRr4PJQOGReW10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nrJZedQasG5hp109h1tIz6IiOeyb5cAr7oGiLXuJj35m25FLfzbTNTmpTSiOMSu5g
         YRxYhMg11RWDu90LTJX3gQZhsfGpjUcFEf/XNkUN+vl61JGL4luIE1lI6D2EzCyyBd
         rhMzv+Lkk0wkxfP3ceibqlHM5jf7Ohgo498XwpMw=
Date:   Wed, 29 Sep 2021 16:20:40 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Like Xu <like.xu.linux@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Message-ID: <20210929232040.wtvifnkucfzs7hnu@two.firstfloor.org>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
 <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
 <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
 <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > How should we confirm this? Can we run some tests for this? Or do we
> > need hardware experts' input for this?
> 
> I'll put it on the list to ask the hardware people when I talk to them
> next. But maybe Kan or Andi know without asking.

On modern CPUs it should be sufficient. In fact the perfmon v4 path that
that was recently deleted did it.

I'm not sure about all old CPUs. There was a corner case on older CPUs
(Haswell and Broadwell) with old Microcode where it was needed when entering virtualization
(but that should be fixed now)


-Andi
