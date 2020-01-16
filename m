Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D50EB13DF7F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgAPQC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:02:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53323 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgAPQC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 11:02:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id m24so4308622wmc.3
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 08:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFh4a4TRf2WK3B41I3jg0SgDGNYjLTYVpVg06g9RX2w=;
        b=dL5u5q1mnBUeWXLsaK7LafNzjKn7fXpaBm04iR+pyPeWunLFa3EopalZdwKnVN9XXE
         GvHwTyeztMwVsm3YO385g1uuvaUY/2BSDayAHhbgAXRhhPChjc1aAeomKRbn470dHBGQ
         0+flbljiOtRW/g52uFwcsxOyUWC/jTrVB6LaQQZWuDxQPr2x8ZZeTE/3l1opUxvXUjnQ
         pBfjs3mxgJL7486yiNjilszZm8lYKXtVSj1TZLIh7ngjOqBtxKHIwttThHR0xQxEMtc2
         ko+JFXfZLLQhesHtYIaIVhETdpBD8UXB6oOcOlRsaC1GcAhZMUPWSpvMraKxkFALeaY7
         dxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFh4a4TRf2WK3B41I3jg0SgDGNYjLTYVpVg06g9RX2w=;
        b=Xwhs+tnJHH9D8HoDr9NDzNKTA20tWKCyIsrblU0lmeniQbmzUnUmOMsaLU3Ud1MWm3
         eBuf5x/oRO20Uv7AQaXVNDqU8Viv+FwAZjRUbQ1V7N8DptW1whpjf5Er0lA1IaTpZzj5
         wptYeu2MzW0i/SPYRrCDd2FPi67yJJ6o1BMqUT4J+2HoX+k+Rb8jSE6xuudMs1jGkJiG
         qi16JrJowpqMkOg3IEF/7Z9H8y1cTFyZFINZxd6692t6KnjMeec6T98qQ0jy1dD4zl8B
         6kr98xH1ImtN3igAXmYw3Uiwbzbtm1j7gZiOYXvmSjzWpq34T6GJKzPAb3IyQZKJshHv
         4LTg==
X-Gm-Message-State: APjAAAVfP3j1hHGGAbBim5nCgFvOxt7q70Mpg6zCOGyp9YIODIb+U3IQ
        Et3LThIK1VHpDHUdIyjBbR425U2UblxkhxDBGQUR/A==
X-Google-Smtp-Source: APXvYqyETr3Zwwyzzk8cTG+shk7ZM6thrcV3vE4sz2Gmd576Zad7K3DJimHiaBvQ/J7TXGHTFwabxvkSCOWshXysBTk=
X-Received: by 2002:a1c:1b41:: with SMTP id b62mr6726745wmb.53.1579190544980;
 Thu, 16 Jan 2020 08:02:24 -0800 (PST)
MIME-Version: 1.0
References: <20200116155701.6636-1-lesliemonis@gmail.com>
In-Reply-To: <20200116155701.6636-1-lesliemonis@gmail.com>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Thu, 16 Jan 2020 21:31:46 +0530
Message-ID: <CAHv+uoHdHjvFwx99FBb9oP2EhOsyuPNbrKyScY8sXUFxyfk6Vg@mail.gmail.com>
Subject: Re: [PATCH] tc: parse attributes with NLA_F_NESTED flag
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 9:27 PM Leslie Monis <lesliemonis@gmail.com> wrote:
>
> The kernel now requires all new nested attributes to set the
> NLA_F_NESTED flag. Enable tc {qdisc,class,filter} to parse
> attributes that have the NLA_F_NESTED flag set.
>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>

I apologize. I forgot to add the [iproute2-next] tag.
