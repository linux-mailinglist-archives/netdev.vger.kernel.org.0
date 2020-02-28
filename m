Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1851736B5
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgB1L5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:57:42 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44018 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgB1L5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:57:42 -0500
Received: by mail-oi1-f194.google.com with SMTP id p125so2557851oif.10
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1O4obvVvKLAwYYBZM+AQ18LdV1elI7eXt7o1/gJyneQ=;
        b=sXAaF8iKjzcVlEHN6GDIFYKh23PMrguoxvSdGx6Lujp018XxheYcYLL7rsZM4Csk+w
         Om4Aa8PXO8quh0pWVWktNd/82+HGeq7Nk8b8m8ANvhvZ2S/8grnDlVpcw1mgS+YgTj7Q
         B8uInsbu6ihoXH6bS+ZQzWxxRCWfCgB+O7D2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1O4obvVvKLAwYYBZM+AQ18LdV1elI7eXt7o1/gJyneQ=;
        b=uL5kKaYq/HSQSfghKtbpGrLsOcOk4WT/OxGULmqVEFUG2JrVliWM1kkhZp85Uf9m05
         mk7k9N5iFGOeZpIoJw/bK51Fx40THld4UUs5rLEtTXr2lQuQLvWnk4D0fiw5m/IWhxXg
         IUbY1oHBobxk+GoviiBn1YaTH5dTQBOrlC49TPGEfwfApbTT7dT6hAo2w+m9u0cPvyZ9
         pgiHC0otTNJLQraSAI9GSzmN4Q0PWxjxz0pdcOK4gD3mCL/SREN8vqcODwjw/HNaAEnm
         rAAqMa2spcppUqXaBrkJJwgKGC58KyHvATe7fhK5Fz6mDTaF0nPhXpS4Rmo1dDiSfdTJ
         CX5w==
X-Gm-Message-State: APjAAAWdY+4NEEXcTQ0/a1bNvxY+ITZ4PiPGeWfq8do1mMEkqWL/x6xf
        UDJLol9uvltLXsuwJLlt911uPpRviFStdga2b1A6JQ==
X-Google-Smtp-Source: APXvYqxeftFzsjngny/QmHkgG9u1BgJecAi1sQEe5ZTVX1cMxK5TGRlqNi+LjOyAtoq5c61t9HYu79xVQLUtmbxEqEQ=
X-Received: by 2002:aca:d4c1:: with SMTP id l184mr2883630oig.172.1582891060661;
 Fri, 28 Feb 2020 03:57:40 -0800 (PST)
MIME-Version: 1.0
References: <20200228115344.17742-1-lmb@cloudflare.com>
In-Reply-To: <20200228115344.17742-1-lmb@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 28 Feb 2020 11:57:29 +0000
Message-ID: <CACAyw9-vUxeyVq-yktXwuTKX6NoEFiX-y88U_751umVviqOSvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/9] bpf: sockmap, sockhash: support storing
 UDP sockets
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 at 11:54, Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Thanks for all the reviews so far! I've fixed the identified bug and addressed
> feedback as much as possible.

This should've been a reply to
https://lore.kernel.org/bpf/20200225135636.5768-1-lmb@cloudflare.com/
"[PATCH bpf-next 0/7] bpf: sockmap, sockhash: support storing UDP sockets"

Sorry!

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
