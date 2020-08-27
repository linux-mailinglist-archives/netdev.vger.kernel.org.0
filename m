Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90912543D8
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgH0KhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgH0KhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:37:08 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87C4C061264;
        Thu, 27 Aug 2020 03:37:07 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id d189so3756414oig.12;
        Thu, 27 Aug 2020 03:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KuaoIMfHLyJIWamoWVAPqeD7Ertfa+2MhldbBJUBVrw=;
        b=XRf1ROSDi/xWvXQNoXRe2i+sqCIDghTb9H9MoXf/szhaeltqhBhDEZr/FFYCRFB6zy
         nT2vLJXyYxaXx58AHy9WAWLZNfuzUPgt3NQ2hyTxPiptl8pTAudEQj+x1WyJqj3LXxiv
         qkaWU243luWMez6wvjyGU+kIq2+xnDVeTMbPFDAyXZnfJW0AlNCQUOn0m3XpKI4a7bA2
         MPXXXJVL0mgW1yH8XhoE+BfELYjzt1pUo8V52CvSRLM1xA0z2ibEeysfiwuodgDpdQee
         C8/Qh+RfrAapjzOexaTIa/uOnj8STyggsjWQ0mqrFrWQzgcpmI6XYMtqVq7OCgr8jS+X
         sBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KuaoIMfHLyJIWamoWVAPqeD7Ertfa+2MhldbBJUBVrw=;
        b=J/oWqpI1SEAFkYtWj4GcWSq4Auuhf8yi3JmpESD1xbVB9uRfAnJSeeHsbUmQX1Vfke
         XHurjzUQLVNj2vW/rYSJvsfHakGF6R3Wtibnh9rr4i2iPzkHmsWGPlN5+Uo/fElcUNko
         09PolrXABlYyeEK+nq5g9J8CoC8C9h6achiLh3bWZsu4XDiF1FWvlRtbhONc0wPE0Hwv
         L/H4AtT6rpV2TGcqBI/4iBdYLxwibVlT43mVr7+ubPrFFi0zMyUT7CRvN3/HjxQSCLFL
         8hsRzgIv6OfEO+a6Lqas5kSbvDaYtqXrznw7C9r3Fq4sowUVgZ8CARQwNQpD44D/6AAc
         hjbQ==
X-Gm-Message-State: AOAM531YSXANQsql1rwYk19oYAZzDeFh/Vnz6WNqb/WD8a2zDQOR7SCA
        P8M40Y/E94hGGF/Yeht/UDu4M+icbGqFfma2ET8=
X-Google-Smtp-Source: ABdhPJz7+RvG6aRT3j85t2k6G6j8hHFH0uz4BK7UgyYd77VKy+00pl24/6V8iV4lW2MpyTyY8+xGHgrhsAMNhs5aLhQ=
X-Received: by 2002:a05:6808:6d2:: with SMTP id m18mr6624752oih.89.1598524627393;
 Thu, 27 Aug 2020 03:37:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1598517739.git.lukas@wunner.de>
In-Reply-To: <cover.1598517739.git.lukas@wunner.de>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Thu, 27 Aug 2020 12:36:55 +0200
Message-ID: <CAF90-Wi4W1U4FSYqyBTqe7sANbdO6=zgr-u+YY+X-gvNmOgc6A@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 0/3] Netfilter egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas, thank you for your patches.

On Thu, Aug 27, 2020 at 10:55 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> Introduce a netfilter egress hook to allow filtering outbound AF_PACKETs
> such as DHCP and to prepare for in-kernel NAT64/NAT46.
>

Actually, we've found 2 additional use cases in container-based nodes
that use the egress hook:

1. intra-node DSR load balancing connectivity
2. container-based outbound security policies

We've been using your previous patch in an experimental project and
it's working fine.

Great job!
