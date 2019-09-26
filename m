Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0E7BF323
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfIZMjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:39:14 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39247 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfIZMjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 08:39:14 -0400
Received: by mail-ot1-f65.google.com with SMTP id s22so1834152otr.6;
        Thu, 26 Sep 2019 05:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LcuQ7ub3xc1lC6Iue/J07x04j8viK4+G6DgvRDSpx8E=;
        b=InI/oD8FAT63DMulNKOsFdjG0ifNgBSAZwlyxhacNBANJDsWoyTnj8B1JrGPFP0IQT
         Fta/PdpKHZNu2sczNHbXBbEljlQuenx+zzCUqegDeem04fQJWGSCJ5AYXiVwOEbYi8hq
         GenD6NvAI5iMPPjlsEB8yS57tWwueSFGfL8O/JSaseCPn4n5+ejn187mhYV6ZF/l0aOc
         vkaA8s/ci9lVpZEpuitiE+IEyKMR8q6BWF4C+cZJAG4QeHRtpHIzJ++CHh1OZhyMxDF9
         XzVD9JmIfkBtZhEIR0Zn6XSDZ4/A9UvpjWBrAwvXBnCt4TA0GDvGr7hvl90Dwg8iJKl5
         37dg==
X-Gm-Message-State: APjAAAUkG3dMD6OQ3jmYBejeYTeOjBw8uxZOuSLphHv/YbLUSF+PmdOb
        QRu3fnvDfH2eqvyDNjhdAaqcQ8/zwnEQq772qiI=
X-Google-Smtp-Source: APXvYqwK+L6qOfhnJCpMB+bC2PvjDDWopzyHhl8rU0KuiwBH1/byEkZFYMgUUoydnLf4GTtbLX3oU4i1oWzm0rKoKrc=
X-Received: by 2002:a9d:730d:: with SMTP id e13mr2407068otk.145.1569501553062;
 Thu, 26 Sep 2019 05:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <1569245566-9987-1-git-send-email-biju.das@bp.renesas.com>
In-Reply-To: <1569245566-9987-1-git-send-email-biju.das@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 26 Sep 2019 14:39:01 +0200
Message-ID: <CAMuHMdUZievmwuWD6Tqzbj4AOewH9Qo=Drgm6OfF_zyoxv4QEw@mail.gmail.com>
Subject: Re: [PATCH net-next] dt-bindings: net: ravb: Add support for r8a774b1 SoC
To:     Biju Das <biju.das@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms+renesas@verge.net.au>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Simon Horman <horms@verge.net.au>,
        Chris Paterson <Chris.Paterson2@renesas.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 3:33 PM Biju Das <biju.das@bp.renesas.com> wrote:
> Document RZ/G2N (R8A774B1) SoC bindings.
>
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
