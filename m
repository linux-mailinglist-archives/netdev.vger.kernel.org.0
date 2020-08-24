Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABEF250C82
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 01:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgHXXtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 19:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgHXXtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 19:49:10 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF44C061574;
        Mon, 24 Aug 2020 16:49:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p11so2673943pfn.11;
        Mon, 24 Aug 2020 16:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MRFtcPoCikAVvKJYCXbUBDj9joKfZP9gvPiffFziVs4=;
        b=UtFLoRdmhkURy9IIpmgJFC0bgeJ1qVxQ0QHeMe2UlDPEPmZ6paDRATFFCezcM2Qxj2
         ZF/iQHVjRDhyDlHIJ8DtJ4948A3fOqdsASI0586Ex3zP9rBxxE5A/1HtEt6LhJ8Awon3
         R0rDvRFkpO4NK784e+/Yr5aR9BBbET8aF1P6dfUSC2MoYo8+PrYloZRK4n2v1R44P5pX
         N21ZOA7CsN6CSqJELOakhDVX57F53/HLExqfk66OssaZgKc6tevxnTmUdEdIGiQIKu8t
         9i/cHb8iapf7NtaC0cbFyN1XO/u6KV3ZRH08ebogDH6mcPSGxhze/2adaSa2eQP4zArZ
         EtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MRFtcPoCikAVvKJYCXbUBDj9joKfZP9gvPiffFziVs4=;
        b=jdlcuHnxBOBZzxCtYUsH7iDZwPItLTJ8l7m8/6u0iASfXZARKzRb2Mjp9iiHcHYH6Q
         WRubVpFSJCr2Ro5RzFkkIsaloawaj5RQi/X57mW+hnzwC1FTd0ZDhgZdaVZCwYELOyWP
         XR2+sCNe5op1G9Y/GXKkEaZfPDpV5lFsd7uarvaPcxlwiMAzhvanDklL9jxSb28LVCdT
         3949yYAq4ka7e0K580oeTvZhd/yjmK+OSFJUqGDIXJMNVq8ij0Cv64XkVMBbJWxdV9vs
         MeTM610VmpEAyRva1kbFkbKjlbWFiYikShpw/0oegXWMrncNsQixt2WQ6cLLztUUgdpW
         YUJQ==
X-Gm-Message-State: AOAM531piscxEW5KkUSltw4bIMkNgE2QxcMfx9WPK5ikfOtbhM2CsQWa
        SnkWvvHpPtSNHFjcP4o8e8vw7eNBoQvhR93lx6M=
X-Google-Smtp-Source: ABdhPJwDvbqoHpdGgbg6R3mtccIx7uaxGYn/pgnOamBZn5OBTmjxGEOYwWsq4yvvrwrRdZMup3IT4zcbH58wvaa8vms=
X-Received: by 2002:a17:902:8543:: with SMTP id d3mr5418093plo.244.1598312949912;
 Mon, 24 Aug 2020 16:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200821212659.14551-1-xie.he.0141@gmail.com> <20200824.160949.2284526241463900498.davem@davemloft.net>
In-Reply-To: <20200824.160949.2284526241463900498.davem@davemloft.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 24 Aug 2020 16:48:58 -0700
Message-ID: <CAJht_ENk-8ziaJ7FFPr9DVRinDOxaXaH2mJHoYcDw3CCHgx-Zg@mail.gmail.com>
Subject: Re: [PATCH net v2] drivers/net/wan/lapbether: Added needed_tailroom
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 4:09 PM David Miller <davem@davemloft.net> wrote:
>
> Applied, thank you.

Thank you!
