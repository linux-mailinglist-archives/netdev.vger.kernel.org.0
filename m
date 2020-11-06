Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922022A9E9D
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgKFUg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbgKFUg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 15:36:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB52D206FA;
        Fri,  6 Nov 2020 20:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604694986;
        bh=fRMWyMzEoECCSyYfpVX7Aqxc4VWBi6RlZLFJPzrp2a4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QX+XZldXBJVyMg9VGb16T8Giw7pDckxcY1fFBtjXsrfKfrCFnLF/7ZRmIQK+YXgQR
         v7COYq17L3D6ItlCTrBRBfP7+Qj4QgKUInJq9CFiEuQp+oQD5ukSVV24nztVmYJ54U
         0JsPZ80CSuHhCXcWxtaw3r7FpVp68ccdu65oHt7k=
Date:   Fri, 6 Nov 2020 12:36:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, Jamal Hadi Salim <jhs@mojatatu.com>,
        netdev@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2-next] tc: implement support for action terse
 dump
Message-ID: <20201106123624.75567f35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0599db33-3821-dc78-95da-4814fbbb877a@gmail.com>
References: <20201031201644.247605-1-vlad@buslov.dev>
        <20201031202522.247924-1-vlad@buslov.dev>
        <ddd99541-204c-1b29-266f-2d7f4489d403@gmail.com>
        <87wnz25vir.fsf@buslov.dev>
        <178bdf87-8513-625f-1b2e-79ad435bcdf3@mojatatu.com>
        <87y2je9tya.fsf@buslov.dev>
        <0599db33-3821-dc78-95da-4814fbbb877a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 13:25:19 -0700 David Ahern wrote:
> On 11/6/20 12:16 PM, Vlad Buslov wrote:
> >>>  
> >>
> >> Its unfortunate that the TCA_ prefix ended being used for both filters
> >> and actions. Since we only have a couple of flags maybe it is not too
> >> late to have a prefix TCAA_ ? For existing flags something like a
> >> #define TCAA_FLAG_LARGE_DUMP_ON TCA_FLAG_LARGE_DUMP_ON
> >> in the uapi header will help. Of course that would be a separate
> >> patch which will require conversion code in both the kernel and user
> >> space.  
> > 
> > I can send a followup patch, assuming David is satisfied with proposed
> > change.
> 
> fine with me.

In some ways it helps in some ways it adds to a mix of confusing
acronyms in which TC truly excels.

Are we saying that all new action attrs/defines going forward should 
be prefixed with TCAA, and all new filters with TCFA?

Otherwise, if it's a one off, I'd vote for including _ACT in the name
instead.
