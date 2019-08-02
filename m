Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B5F7FD4C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392872AbfHBPQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:16:07 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45455 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732689AbfHBPQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:16:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id m23so73116758lje.12
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 08:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4HyieNTDenv6VWcHEFYLRAPAieyya6zJPUYi5cwvXW0=;
        b=fR9DEUIWcG30CbzXdBi/IMZZi5nHEXjGK3PsIrQFgzPXw87BOtXny0/MEoZTfRLA7j
         4D9jesiAcyWAVz94e7H97rvhgJQeLMHmC1tLvtOvG6DgHB69S7SCpqmG13cehtM1lr0V
         n3TDdG/34967dkEWhE66yKE6PUwy9FJbqVYQzY9Rsvk82d99tzIEM2iY4X+dzGLycYuU
         MPC5zBWhhBVfhPvPyuEg4/zc1HAy0pFiMFRjqQ8C0DhXnwDOBhDbHDQd/SzDsZPlqP2q
         SVI1jpQwiKgZnYnKJ27Osb/TmbMtoCko7AonAE13W6T9YOpKxSsSoCtdgjk5FOuQuNMn
         XU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4HyieNTDenv6VWcHEFYLRAPAieyya6zJPUYi5cwvXW0=;
        b=P7cb4uzW00yazcylXAA7wXi4VCoTs8fiWVUWweuBGtBZHewKExdOfEgJJeuy9V3i/Q
         rxrzl/ggsatdlQb+md39mpH2Wld9nZUYzZyR16G73rDv7vqAcmuYsnHQFz5b4lT7u//b
         L77rmg4yq9OJOtajCBh1HA6jy+77NYaeD2/EFguvdLIz66RWZRKg4k5pX9kGFIiCSlwc
         2JLHHi9UqQ+JZn4K17ZbiHNe9SZjGNaZUBz96+7ZzxR+S4Hq8EEPeRyTfeS7G5ik31Zs
         zfGa1sEqEy2RKinfTrTdF5MdMSH5uvECXL31NqKm5K1/rNdi7zXLqk116puexgcWPTi8
         Qljg==
X-Gm-Message-State: APjAAAVJtDoledcDK4t6pcCphGnW6g9saFU/hzVioO/LNzP4D5ncZSTB
        /mBPFrvb8fKwS8L2nFWiUYYj0P864t2ysN8od58=
X-Google-Smtp-Source: APXvYqxoSmyWo7+TjQ9/80gI7LUOG/09/ks8YXXGytUS9lj2bGz64PznVWDvI4IWIrhyDso4Vc+7ub7dgaM9Yn/ZIoE=
X-Received: by 2002:a2e:968e:: with SMTP id q14mr66972979lji.195.1564758961211;
 Fri, 02 Aug 2019 08:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190801185648.27653-1-dsahern@kernel.org> <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
 <7b95042e-e586-2ca2-2a26-f5aea5a8184b@gmail.com>
In-Reply-To: <7b95042e-e586-2ca2-2a26-f5aea5a8184b@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 2 Aug 2019 08:15:49 -0700
Message-ID: <CAADnVQJ7GUX=EWP0RWxpe71cGx2cTMyKHsA+6RRX0P05FPMg3w@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 9:11 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/1/19 6:19 PM, Alexei Starovoitov wrote:
> > Do you really need 'sleep 1' everywhere?
> > It makes them so slow to run...
> > What happens if you just remove it ? Tests will fail? Why?
>
> yes, the sleep 1 is needed. A server process is getting launched into
> the background. It's status is not relevant; the client's is the key.
> The server needs time to initialize. And, yes I tried forking and it
> gets hung up with bash and capturing the output for verbose mode.

That means that the tests are not suitable for CI servers
where cpus are pegged to 100% and multiple tests run in parallel.
The test will be flaky :(
