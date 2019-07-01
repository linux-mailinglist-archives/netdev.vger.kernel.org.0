Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2EE5C516
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGAVkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:40:52 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:37310 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfGAVkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:40:52 -0400
Received: by mail-wm1-f51.google.com with SMTP id f17so1056938wme.2
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=at25FB2V9moYWLtoDmGNH4ML15nwSE6SpE7coKnBWRw=;
        b=MsKNbd5Sps1pu1c34dQVQ2+SPiiXbR+W4Nf5wJmOqkc+8C1xWX7qk3Ec/TINhVYMyM
         rPo7fYXLDw7Q8/yFnSMG4MLN9Ku12XcYduAjMZTimC70brt88dQwXyg+9pOUKfo6E4Aa
         Q0DfwUw/dQKQecLrhhDF2tCzROU5xyWGTLP+ZXXRgBo91Tx/2OdqaTkyXXSxg82Wr44E
         qpPUFp/Ks/4Tqozv3QGRqboABJE9ewpfSMelsCoPp6kU7ad6Y0CrEXhrBAAg0C8ZcpEW
         Xqr2lBqmWtgsh9/6Na2We0nX1RcDEu5Btz0CkEwbKZ6MAVQZpl79XfWp1A6Z5yBXPJ3i
         Qw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=at25FB2V9moYWLtoDmGNH4ML15nwSE6SpE7coKnBWRw=;
        b=TSOKJ0do15xS0yZCaVIniocZx1kzpDpNcM2PkPCSFvWZ5KDk7eQPqnVxffMnMtKoO8
         oqWFmuin3cpCzeWtJ+P3XF8Ivud4h9zrLDVNkJEbp9vb1hKXfGm4PYQ598I+JENsqa1H
         45t1EYyPwERn/IuB6HQiQWHNjdHrOrFRWFXWbyPGabDb6TrnB3tKg2GNIb8eQ/ob2bBK
         LixE8MiMuVoE3oZpaFo/J4OD0ktKQElfZHN7I8VGAQi40qnr5zkWspsWamtG7jQYtvZd
         27sJqwyEbzycAx+pxe4hlHc/T2guNoIUAaZ1iIYBJk3Ci6vBTWIooMeMiDoQVVsOjTyb
         W2tw==
X-Gm-Message-State: APjAAAVR/FJBbzg6pNjaH+OIh8B9cJSbjo3wIBCaQOX5H3mL0KceSWA7
        WrYR7feVMWddJxytLrXBD7qg5yaV5rBuVaONQocPRw==
X-Google-Smtp-Source: APXvYqz7pG35v5kJM6h1hFTSTQADnLwSOl+SV3geHDpgOuvm62cRC05M9wFRaWZn5PIRSlBwGOvXMNbL3Yy5oz6fzcQ=
X-Received: by 2002:a1c:f018:: with SMTP id a24mr694610wmb.66.1562017249846;
 Mon, 01 Jul 2019 14:40:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190627194309.94291-1-maheshb@google.com> <20190629.122847.986644252948714439.davem@davemloft.net>
In-Reply-To: <20190629.122847.986644252948714439.davem@davemloft.net>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 1 Jul 2019 14:40:32 -0700
Message-ID: <CAF2d9jiYe4XrCSju6W=UicVV4goRbKibo8TAe_P=wU0WPjL+HA@mail.gmail.com>
Subject: Re: [PATCHv2 next 3/3] blackhole_dev: add a selftest
To:     David Miller <davem@davemloft.net>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, michael.chan@broadcom.com,
        dja@axtens.net, mahesh@bandewar.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 12:28 PM David Miller <davem@davemloft.net> wrote:
>
> From: Mahesh Bandewar <maheshb@google.com>
> Date: Thu, 27 Jun 2019 12:43:09 -0700
>
> > +config TEST_BLACKHOLE_DEV
> > +     tristate "Test BPF filter functionality"
>
> I think the tristate string needs to be changed :-)
side effects of copy-paste :(
sending v3
