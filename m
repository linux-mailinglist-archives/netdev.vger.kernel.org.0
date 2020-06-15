Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE0B1F993A
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgFONpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbgFONpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 09:45:39 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69789C061A0E;
        Mon, 15 Jun 2020 06:45:39 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id y6so6282592edi.3;
        Mon, 15 Jun 2020 06:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=je/VMIDu1HMLGM9aC5+ju34aZPTh4+EiQvNVe0yywUk=;
        b=UKZqmBEO7ucC2dWiEPjv8XBFyyCpKog+HUQdeK6nO43meSndDKovPqIVFaJIcPKQt2
         qis3DkREZXjjAYORy/k4S+tkgwk6V/PwZv2n+/9hMDrA3XXz9q8z8BJw/pyoUfdncHcN
         FkHghwl4qLZrdQL8D33nauz1hUoWgEGgr29kHVcZ4Y8ZrkMfBYitaF0aLcqITqv2AJ5v
         yo0rL2ZTuahGlxVWgfqfUM7T8F7uDPRfTK6wAd2rS0MkryI2XSNJheWIp0oeH265rDwV
         QPKHp40UmdPIxdsAJfVS2hKbxhvGgIPIZt/bDzPIjMwJRdlG/MXKxBU8wR8UydLoWInN
         jZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=je/VMIDu1HMLGM9aC5+ju34aZPTh4+EiQvNVe0yywUk=;
        b=WHx+WRxp6PYqP5F8WzTxiat2iPuXrZ7UjUntIU2yWDewMH+0rZ0XTj67u/LJRdCOGA
         u6XTeuVjeDYHR9uQeyUAiGixyuaFVpyVzfWvD4iB3NB4g8nD98D3hOWd+ANE2cdrGgD9
         jRZ9+IpmhS3JiLUTfYtZEh75sHyKsqKuelSy6pvgRNYE1bc/Lu6idnlboqVaISkrbovE
         3VzvqSK8wBKVWl55/vi2DHnyuTEgIxZ6/oDeHmqiJLtJaIndYaFwTDL9Fn6BfhxW7OqT
         i6kauHTKgcX06t/Efq+7NKbYWiSvBVYRS5B8gVfQBzeE0USCeWnTU1n1BzBdiemjqHjJ
         p4cQ==
X-Gm-Message-State: AOAM531gSic8Uek85h/oJCZaJQz6VjtohMFiR+KeCmwkCUQXCm/KU7rs
        QF2+v8tI2bEq0l6+a+IaRGCE3ALhAylVQz1vS2c=
X-Google-Smtp-Source: ABdhPJw+Q9GuP+rTVV18SrUjho/DrpUXxtFDKmvyMfNj1OIc3VoHXb3Eq/NloFIxXdW6iuD0q8Wbu+lEazNlaR1zGpI=
X-Received: by 2002:aa7:da46:: with SMTP id w6mr23564896eds.31.1592228738168;
 Mon, 15 Jun 2020 06:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com> <20200615130139.83854-5-mika.westerberg@linux.intel.com>
In-Reply-To: <20200615130139.83854-5-mika.westerberg@linux.intel.com>
From:   Yehezkel Bernat <yehezkelshb@gmail.com>
Date:   Mon, 15 Jun 2020 16:45:22 +0300
Message-ID: <CA+CmpXtpAaY+zKG-ofPNYHTChTiDtwCAnd8uYQSqyJ8hLE891Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] thunderbolt: Get rid of E2E workaround
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, Michael Jamet <michael.jamet@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 4:02 PM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
> index ff397c0d5c07..5db2b11ab085 100644
> --- a/include/linux/thunderbolt.h
> +++ b/include/linux/thunderbolt.h
> @@ -504,8 +504,6 @@ struct tb_ring {
>  #define RING_FLAG_NO_SUSPEND   BIT(0)
>  /* Configure the ring to be in frame mode */
>  #define RING_FLAG_FRAME                BIT(1)
> -/* Enable end-to-end flow control */
> -#define RING_FLAG_E2E          BIT(2)
>

Isn't it better to keep it (or mark it as reserved) so it'll not cause
compatibility issues with older versions of the driver or with Windows?
