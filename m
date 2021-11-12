Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A4144DFDC
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhKLBoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhKLBow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 20:44:52 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F9AC061766;
        Thu, 11 Nov 2021 17:42:02 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id m14so31632141edd.0;
        Thu, 11 Nov 2021 17:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1DKB9QPoswajpoT5zwf2dnAIQyIiBvEOX2LE4AoRaM=;
        b=FnY0Zq7uRksikoidOWVyVjuGm/jR9uhk4UCwmn0o1Akz2lm95Gf/LcTNcQ2qxvzItP
         tzOr3zpPMZhgSybA4LXXWUu0e0AZNv++csiJnLgKpv6wJ+BmaxbPhh+T05x+qt7cT+Mo
         zHQl6az9oVOlLbXH8i4CIcqgsZm7NphhUwtHxzUxyA4lbVfZTOZNe5127pMdmwBOlJph
         HpIBKNGb6+MUF0Zi1Xx7jE4rvoPj3FodqMzqPFpUz78Wb/zxqioQcXuvZhwiWLBUSvl6
         ocUPUnmzloUzkrpUaUr1+x70bZjz2EQkae0ydSa4ZSyRHkDtz3MwHWyoRl/VcZrOJOBb
         z29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1DKB9QPoswajpoT5zwf2dnAIQyIiBvEOX2LE4AoRaM=;
        b=ZDEHAfiJElNGoBRzHNpeOLxHLh7hmhlrFYdK2IvmJRay8GFHqS7J3sE6qmuTGNsmJW
         Je2VnNqgjAyrcjVI04XtwTEoosAdIxlwkNdyJ+fZQmty2cn81494LNTPL9Bv07UfTOLk
         O8tun5R1IKMMj6/ixOoyMtC7CbSMJxLPc6zqfdH44jT53+s4A+niOmNyKx/lzef+8oQm
         DpC1cVDZzAxELDERNuutL0QHHO7Kd2m3e/p9fwF6Y5I5piQThZly0TXTz9HUXKK2vo9j
         +gNPkJ8K+3tKtGgrOMIWKnB2rHK6mVls1pUqP0FnBgNZ4miuIRpDgTfDEQxbIskBqkG4
         IoyQ==
X-Gm-Message-State: AOAM532vVvnihTagFdkkB96g2fqEZ/SvKcrqrh+nye6+Qn6fTs+9q9fS
        LcSmz4Nd0wMjYLqmOlDzAfgo69NWFMme+zvB2w2CSXZG17s=
X-Google-Smtp-Source: ABdhPJyp+brCCHZoPLdQuR+DxpRxnrLERSJSAhhfU+xiBwZFo4TJH6AZLKCNbvNQ4g2Yv49NsVzKbX/5HHTyvjO5yBY=
X-Received: by 2002:a50:da48:: with SMTP id a8mr15904831edk.146.1636681321216;
 Thu, 11 Nov 2021 17:42:01 -0800 (PST)
MIME-Version: 1.0
References: <20211111133530.2156478-1-imagedong@tencent.com> <20211111060827.5906a2f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111060827.5906a2f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 12 Nov 2021 09:40:47 +0800
Message-ID: <CADxym3bk5+3t9jFmEgCBBYHWvNJx6BJGdjk+-zqiQaJPtLM=Ug@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: snmp: tracepoint support for snmp
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Nov 11, 2021 at 10:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
[...]
>
> I feel like I have seen this idea before. Is this your first posting?
>
> Would you mind including links to previous discussion if you're aware
> of any?

This is the first time that I post this patch. Do you mean that someone
else has done this before? Sorry, I didn't find it~

>
> Regardless:
>
>
> # Form letter - net-next is closed
>
> We have already sent the networking pull request for 5.16
> and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.
>
> Please repost when net-next reopens after 5.16-rc1 is cut.
>

Ok, I'll repost it later. By the way, is this idea acceptable? In fact,
I also introduced the snmp-tracepoint for ICMP, TCP and IP.

Thanks!
Menglong Dong

> Look out for the announcement on the mailing list or check:
> http://vger.kernel.org/~davem/net-next.html
>
> RFC patches sent for review only are obviously welcome at any time.
