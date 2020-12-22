Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0BE2E0C4D
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgLVPCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbgLVPCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 10:02:05 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B427C0613D6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 07:01:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b2so13233533edm.3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 07:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aVWruGcE/Vgy7q+GH/8AbK7dekWv4+aZfA36+pIPLmo=;
        b=ce9EmOfyRI0Ge/qUT7f89YUYzAsW3nX9I62DrhL78suNe3OhHcD6O9BAc/7Ufnf0AN
         zfnHE3QP6sauYJ9UEAnVQkm12e8VqDWusCbSJC6Mdrm6HQO6ozdXOl54iGA+ORdsSi88
         qwtivXvLb5zbs1zi34FWPYRasQR61rjMx4kQt2Rlw9KlpGPGPVlfQSq4iaRYkI+qPJYA
         lQ4w0aF29bSsCa0lbwQBP3h0AZ0R+xhRj0t73L8W90lJmHXlD7hh0+x9EgsDuib+dqqN
         q088eFIFdOVWXj6g5NP6/KgLzn/2m680Fyk3+RqiEC8uzZhpi38In3gixkkXv5vjVvHT
         u3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aVWruGcE/Vgy7q+GH/8AbK7dekWv4+aZfA36+pIPLmo=;
        b=Y4mPA4LZjgHwD5PRYjreZ4lpN3yc5yOIex8d7G3w1NWdytWKEaWwta+9MzQiseGbpf
         s3d/olFj5svwcFaAurPc6zqVdOqN/x8PaBVUffTlkGMhh/XwKWLASzYLsVeb2s0Rd7ds
         65YJE51OtjDVdaBT8TntU9RJddetQJomKTC8DmO+Uh7k+JBEq1kWZ/ZmDScsFpjM7B/z
         yeR8Gx4D8P5Wnca/GvWDuBYBGpwRpbdDaKSZaFlGyyAWMEhwMSoK7Xzjc9wUh7/1iFiP
         r1kfI8XYUx20cwl4qaOnUlRsCkIYJxIy+VRdUmRTje4YeB03lJX1XTQnyS7taAX9cIDx
         3VZg==
X-Gm-Message-State: AOAM532f3eDJ0zZijSweVn98fF9VsnBaNgXAk1JQWN8WQhKGOaiL4RqL
        RH14vP93lhfmzpatEY8peYEP0qnJU1etYJIHKOc=
X-Google-Smtp-Source: ABdhPJzZFvkDIyNFlqRn//LMkftfi9nAey8aWqwMR8FKnIUb21j7YT9VFUApX0ED514Cpdns2p4xA/4Us5qImgM7BjU=
X-Received: by 2002:aa7:dd05:: with SMTP id i5mr20646555edv.223.1608649283426;
 Tue, 22 Dec 2020 07:01:23 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com> <20201222000926.1054993-3-jonathan.lemon@gmail.com>
In-Reply-To: <20201222000926.1054993-3-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 10:00:47 -0500
Message-ID: <CAF=yD-+Y4dboCq-kc3-cwPBd3PrxC-0XXoXxEv0W=0XiJ88zkw@mail.gmail.com>
Subject: Re: [PATCH 02/12 v2 RFC] skbuff: remove unused skb_zcopy_abort function
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> skb_zcopy_abort() has no in-tree consumers, remove it.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Indeed unused. This was used in the packet and raw zerocopy patches in
the original patchset. But we never merged those, for lack of copy
avoidance benefit at small packet sizes.
