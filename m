Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB014582F8
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 11:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbhKUKuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 05:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237987AbhKUKuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 05:50:40 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA49C061574;
        Sun, 21 Nov 2021 02:47:35 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id l25so46922315eda.11;
        Sun, 21 Nov 2021 02:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MXLo+ltgSmCvyGffXWjUxfxqUK//tZmJbyrhfQ9Q0t0=;
        b=g5r1kyroze1qFZ3o47+fhGaEUI3MgKiusnrLbcyk0k7571xBgSxdaKNk7s/JodvL92
         D3mrafLfQZv9SXvt6PoNwSk8KrfVOFklS3q1eU0FrCAYGwySmyj48RSKZe2P/AYj8oYb
         +nnebsxSgm5hAeFqPZlodMzp/1M5UL/pZ/InpJQ9rYdcszHfVV4UXQP14OctUziLuZoI
         gMUBd1mtMFIsyuTj1KJ7imKiYBFbK+4b4mziXFuPVC1rgO5iZ9TcbZ0cDDAzVGopHXOe
         gf2Dm7R0QjGSCFI0qsL7BU19uDujxvRNTOZX5Whw5fGOtHBJSia/IWrX/ysl5ChE+bZm
         iMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MXLo+ltgSmCvyGffXWjUxfxqUK//tZmJbyrhfQ9Q0t0=;
        b=IFOkjoH3Zudjl4W3RLxmlrTWLsUZtWim14tGNk+WwCRPMFoYcWNbVRVdLtgpKZm9th
         Yz02VNKvRhHeF6a1Mpl27CRfjUalkUtD4UeQcPWOYJPDCkTtwoEgWa1vNHWLGvHS1HKk
         l/Slu+lKBJtkHigci+GWAmVt8OPLdgsXMH3RwvqG0A3bQ0/ezS2EMTg58CLMX2+RV8xo
         5fnTaQNOdXdKi6usNw4yj3Xg6RuHvyozrbZxBWlv6GnjH9vkJHujLScpW3czz+WqNOQm
         rhmjijsygCxbf71GEGw4cryZ1oC1IPtVjhp9+UMoIFkL6rf/ZZNNgQAyTb6Nv9NGz6qb
         s7xA==
X-Gm-Message-State: AOAM533WvdHsWFvkrZJqjE05GMxP3du34m+yhP/uIZJOk5HRRjmywYud
        NM64IvhiA01XSsMzeS5lQCmzqD+oNor48YMn+Bg=
X-Google-Smtp-Source: ABdhPJw8mBzy1laOl7vp8X7saDuoWaIte2D0YeXSxEbpq6sqKZ1ZmJFHIeXR1AT+f/g3diZzKrhlmiTDeJwMTQRIJlo=
X-Received: by 2002:a17:907:2d0e:: with SMTP id gs14mr29452540ejc.249.1637491653691;
 Sun, 21 Nov 2021 02:47:33 -0800 (PST)
MIME-Version: 1.0
References: <20211118124812.106538-1-imagedong@tencent.com>
 <67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com> <CADxym3ZfBVAecK-oFdMVV2gkOV6iUrq5XGkRZx3yXCuXDOS=2A@mail.gmail.com>
 <9ad07da4-8523-b861-6111-729b8d1d6d57@gmail.com>
In-Reply-To: <9ad07da4-8523-b861-6111-729b8d1d6d57@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sun, 21 Nov 2021 18:47:21 +0800
Message-ID: <CADxym3bTScvYzpUzvz62zpUvqksbfW-f=JpCUHbEJCagjY6wuQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
To:     David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 11:54 AM David Ahern <dsahern@gmail.com> wrote:
>
[...]
>
> But it integrates into existing tooling which is a big win.
>
> Ido gave the references for his work:
> https://github.com/nhorman/dropwatch/pull/11
> https://github.com/nhorman/dropwatch/commit/199440959a288dd97e3b7ae701d4e78968cddab7
>

I have been thinking about this all day, and I think your words make sense.
Indeed, this can make use of the frame of the 'drop monitor' module of kernel
and the userspace tools of wireshark, dropwatch, etc. And this idea is more
suitable for the aim of 'get the reason for packet drop'. However, the
shortcoming
of this idea is that it can't reuse the drop reason for the 'snmp'
frame.

With creating a tracepoint for 'snmp', it can make use of the 'snmp' frame and
the modifications can be easier. However, it's not friendly to the
users, such as
dropwatch, wireshark, etc. And it seems it is a little redundant with what
the tracepoint for 'kfree_sbk()' do. However, I think it's not
difficult to develop
a userspace tool. In fact, I have already write a tool based on BCC, which is
able to make use of 'snmp' tracepoint, such as:

$ sudo ./nettrace.py --tracer snmp -p udp --addr 192.168.122.8
begin tracing......
785487.366412: [snmp][udplite_noports]: UDP: 192.168.122.8:35310 ->
192.168.122.1:7979

And it can monitor packet drop of udp with ip 192.168.122.8 (filter by port,
statistics type are supported too).

And maybe we can integrate tracepoint of  'snmp' into 'drop monitor' with
NET_DM_ATTR_SNMP, just link NET_DM_ATTR_SW_DROPS and
NET_DM_ATTR_HW_DROPS?

@Steven What do you think? I think I'm ok with both ideas, as my main target
is to get the reason for the packet drop. As for the idea of
'kfree_skb_with_reason', I'm just a little worry about if we can accept the
modification it brings in.

Thanks!
Menglong Dong

> And the Wireshark dissector is also upstream:
> https://github.com/wireshark/wireshark/commit/a94a860c0644ec3b8a129fd243674a2e376ce1c8
>
> i.e., the skb is already pushed to userspace for packet analysis. You
> would just be augmenting more metadata along with it and not reinventing
> all of this for just snmp counter based drops.
