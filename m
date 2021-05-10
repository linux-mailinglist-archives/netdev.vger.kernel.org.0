Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0517379657
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 19:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhEJRrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 13:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbhEJRr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 13:47:27 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4924DC06138C
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 10:46:19 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id f1so5464688uaj.10
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 10:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=sZnijD3HN9WKlqOd8Z3dyoGi980FdTOqQZ/5n4gbr28=;
        b=YbsM+etE5AIHtaBk4wdjmD5Cdw65dbCjTJ9ZkYvjzl3Y0UNkY8/9Dg5W+EDpnHLM91
         iyaFWCAep7TObiq4sVyEdAFZk2mQeP1fX99Jj/QoFwA3UURimk9jsMhbBwcHgUaA94lM
         kxm9taXeo3vcssD3TthIy82NnDbjaVn0KctrqxNJilSAUN6KOQrUXKxexfPoRvn7ZO40
         wKr3Bo5UaLKZ5a9UpDVzkc6kUcvH06yNAjgZzY9Lng0LuCj5cTjezHCNNpGruGBCV5JP
         88aJzYPD7I3sAphQrT+zEE7OwxMGhpaSEC6EL+P1QtYw8Sh3x+E5Qi4UYg7rYcD7vR3o
         JrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=sZnijD3HN9WKlqOd8Z3dyoGi980FdTOqQZ/5n4gbr28=;
        b=eOMLo0X3ngK7tStfOTkZqvbSNr/HJ7d0x0ahnl7Rqj7QsIewMFkKzumOUm31fqD3fQ
         I+Bmu4YElGvsSpvOpwkBCMm2aNN/uUop86IqhtVHlI0vpNbAyHXKw7I+4SzMMP+BJA0U
         5DeQMX1kKixVbV0vFA2ZcHfFM5sbxM/dytXgF+ZGlyQ/m3cmxLqhBw/apfQ33Xb/zZYi
         JLDJ6JYOkTCRAIZMyWzD4DRXPjvZIUipceXKuhv928iihTZl37qkx2O7m25z7umC3UIg
         kbu9F8r0/YEGBZkbsmUdqTA1AMvZAjtDtJP6sd1dmDNfptvozLpmyujRQw40OOj62Oz9
         uXZQ==
X-Gm-Message-State: AOAM532ngiZhnVgqAAmPrumkirty/g6sGbWbaeL7zSGQgF5Gz0iqvrjV
        32+loXJ/jG7Tw6WJEbcFXtcJWB2+gU9UA57MY6lDIvrsqgY=
X-Google-Smtp-Source: ABdhPJzNUVr9n1Fffs0MLwbjg2xthNFeP7JMQXTfrFCkXSHbzdjEODmm8hiGhY2T/9jqSqHw/cRbfBIG3qDbz+nts9Q=
X-Received: by 2002:ab0:1430:: with SMTP id b45mr18728806uae.64.1620668778132;
 Mon, 10 May 2021 10:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAHP4M8Va9TuFycrVZmLwBnuPtDRykX__NOxxF9zq0089JJBACA@mail.gmail.com>
In-Reply-To: <CAHP4M8Va9TuFycrVZmLwBnuPtDRykX__NOxxF9zq0089JJBACA@mail.gmail.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Mon, 10 May 2021 23:16:06 +0530
Message-ID: <CAHP4M8VGPhwsfKVX65VGobqJNb9ua6sG-=zhakhqeiMzcKfvEQ@mail.gmail.com>
Subject: Re: Packet Sniffing on Intermediate Nodes
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think my question might be unneeded.
Machine-2 would likely pick up the packets destined for Machine-3,
because of promiscuity.

On Mon, May 10, 2021 at 10:02 PM Ajay Garg <ajaygargnsit@gmail.com> wrote:
>
> Hi All,
>
> I have been playing around with sniffing packets, using raw sockets.
>
> Following is my setup :
>
> * Machine-1 (Sender), with IP 1.2.3.4
> * Machine-2 (Intermediate), with IP 5.6.7.8
> * Machine-3 (Receiver), with IP 9.10.11.12
>
> The packet-path is Machine-1 <=> Machine-2 <=> Machine-3.
> I have an agent installed, one each on all the 3 machines,
> communicating on port 12345.
>
> Following is what I have accomplished so far :
>
> 1.
> I have been able to do communication over raw-sockets.
> Most importantly, Machine-3 (Receiver) is able to receive the packets
> from Machine-1, via raw-socket paradigm.
>
> 2.
> Now, raw sockets in general accept all packets.
> So, the next step was to apply socket-flitering, so that only packets
> intended for port 12345 are received on Machine-3 agent.
>
> This was accomplished via the help from
> https://www.kernel.org/doc/Documentation/networking/filter.txt
>
> 3.
> Now, I intend to sniff packets on Machine-2 (the intermediate node).
>
> Is there a normal / legal way to do this?
> Would be grateful for any pointers.
>
>
> Thanks and Regards,
> Ajay
