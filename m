Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F182FF48
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfE3PS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:18:28 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35280 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfE3PSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:18:24 -0400
Received: by mail-lj1-f194.google.com with SMTP id h11so6463137ljb.2
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhzfRULewEHaCRT6mzuG/5AfQCQ0SPnyNVaSsb2cUuY=;
        b=Zl1nyrsvIC2ma+vC7BqQmGA22XdoOYPDsNvklgiCfOWuInopHqlR4RSb75STxF4Hdc
         cOY5zV77nMr5CyJNu8PQVNNViyUKQtiuBG3nvV8AR4a2mbxDjs1GgdLThEJsBQK1QUEQ
         rJBJe4Lgw1qK7GvXsN05QXJFPWrT/Ky1cJEuItX7m2yY4f1uDOnrzUS52r4mta0/cgsc
         Sza3X686JJ+ZT3rk1rQtT+dP80PbkZk6MoHePftHvUxX3PvkSMPFedL6Rzbq3NKBjJ6s
         c376siLOt5VQSI2CaYGsM8EAguvTNmCRuZC5zmmF3wtLXfL4bBtZsds0dG7qeQTuII4T
         gxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhzfRULewEHaCRT6mzuG/5AfQCQ0SPnyNVaSsb2cUuY=;
        b=mxcHh16TqQSQf9ueKCZdANeL2ZeO76n5Dkt8HOoA4dlp27dQUHrOkbxQ0VWoloiUvr
         lPnN2OzlKWzJK08H9OU/7vbRRdyv1os4/oxayFuPLTDynP+8pkEoZDVQz3fiGjCPsy+e
         NiBMCdcq/0ihWaHNgqUhHADsWT7c6rQMc0wN9RZaC8PvwRylndz1zFZp2gLvpv3zOJO8
         /dEUck/MqXGC+kvmSBz4hBp2iuD9goeRs2FsOxHrcAzS0401tBqv4Re0YHdsnOLh8yZJ
         fl7BE6Af694/9I81FzoeSYOkVKMqGvTW3XFuif3Jibp4bCUnO7emQ5235CDbjF8ZM6DM
         iBTg==
X-Gm-Message-State: APjAAAU9U9rKdhSyAWFcwDj4x4foCCm0Ht/2EaEv2Jf2Lq+l9CdjgZ56
        H2Fz8Bf37sR2wFVdJ+Ru3pgqbFoyrEGiS5eG2htIQg==
X-Google-Smtp-Source: APXvYqz8LZ8CDHjjAu31ZNzP782kR9lxL6G4iufItRGGE3l+2V/W23rctAXzwzCS6W/0bWKtq5B9JjDzdR5a4npfQxY=
X-Received: by 2002:a2e:9c09:: with SMTP id s9mr2460986lji.74.1559229502682;
 Thu, 30 May 2019 08:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190530030800.1683-1-dsahern@kernel.org> <CAADnVQ+nHXrFOutkdGfD9HxMfRYQuUJwK8UMPGtbrMQBNH4Ddg@mail.gmail.com>
 <d110441b-8d69-0d11-207f-96716d7bc725@gmail.com>
In-Reply-To: <d110441b-8d69-0d11-207f-96716d7bc725@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 30 May 2019 08:18:10 -0700
Message-ID: <CAADnVQJ-aBTFC1BeMiNRD=42qcdw83D_t0zDVzEX+OfFvt7K0g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 8:16 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/30/19 9:06 AM, Alexei Starovoitov wrote:
> > Huge number of core changes and zero tests.
>
> As mentioned in a past response, there are a number of tests under
> selftests that exercise the code paths affected by this change.

I see zero new tests added.
