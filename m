Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2323D17D1
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhGUTfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 15:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhGUTfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 15:35:39 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D715C061757;
        Wed, 21 Jul 2021 13:16:14 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id d17so4521747ljq.12;
        Wed, 21 Jul 2021 13:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lSU6HhPh2vArZHQqBT84VHeDv+IVbMxi0i70iGqpdDA=;
        b=Bm/bH7cUl3N+ohBACh18PT4q/J1dhq0ag6ksUY1PG1KU337jkZLMyag314YnLTY4Cy
         bEELvyTCW6riPkII4fUIZhwFmpHwyIMPgM6WvYdPpwfdTgIOf8lG/GVVKkTIxE2YLlAA
         ctaIftOwYbcrA5jcoUJQYpP6aiGqyt6NrMonmlZZs5scU+nZs07YYkaR1Kbsjls7R62J
         tiadkUQRVXOFZQZOqKVBgIb+ZHqu0hTU2QbwSSCaaL85XXUtoMkqBKi8fUzG6hrkJs3W
         +joOBRTqb6qT/pOMcKhjllnvccG5Zmg6BvlVwijMmFBxNsHGExk1KWm6zzYzVY2oeM33
         o/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lSU6HhPh2vArZHQqBT84VHeDv+IVbMxi0i70iGqpdDA=;
        b=VJjCnoVxewvQ9QnrJhiJuPWjlNZgREbd0OLTAxpazwNcp406vW+zRBqy+Pah1KIJ0W
         jAbXjW5zyWD7RBEeqRPq+DsfUHd+MAwDeoFZ7oUMGJzhuVrTFewviccI0jMZxUfxj7s0
         EMgD3hL5F+ICqamm38POZI0B9w1AGohVY9dnVs9LdwhJ01sOerreN+2HXSwJXTrhVxNc
         3RMAnrbgPM0rldr497Nm+vYafMkG0odrjZfw1d5qtDsG7FvazwEPdh6tNkDwnLsr5IOE
         iP1dG2SAYgi9OvYmh9tc4ZbwJePx+kB9QJfvDMoqEJUWf22ZKG/nsgoSrNzALbbgkoHU
         ZyJQ==
X-Gm-Message-State: AOAM531z4ZJX0irvjLsaLQRq9KH1Sra4pImsItd4K1aMIVE64eU8Uu/p
        5s2r4h4fmglJ91joNeTzfJM=
X-Google-Smtp-Source: ABdhPJwzl/cqfyeRR0V/XIPpsvkRPyO7UJEMqpff0bBIju6sfpniyq7R3kXhlLXU3kIoJ9egc6p5Lg==
X-Received: by 2002:a05:651c:382:: with SMTP id e2mr32442416ljp.383.1626898572667;
        Wed, 21 Jul 2021 13:16:12 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.77.130])
        by smtp.gmail.com with ESMTPSA id f17sm2017548ljc.100.2021.07.21.13.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 13:16:12 -0700 (PDT)
Subject: Re: [PATCH] ravb: Fix a typo in comment
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Lunn <andrew@lunn.ch>, Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210721181721.17314-1-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <3068c299-b0b7-b66c-006d-f5f7f58b9552@gmail.com>
Date:   Wed, 21 Jul 2021 23:16:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210721181721.17314-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/21/21 9:17 PM, Biju Das wrote:

> Fix the typo RX->TX in comment, as the code following the comment
> process TX and not RX.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
