Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF328330F1C
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhCHN1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCHN04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:26:56 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AEBC06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 05:26:56 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id p1so14743041edy.2
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 05:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KvcI+kICoxFmJJAM8JM8i9oBM69AG9tcbWFGpBAobjg=;
        b=JvxtbgaJQ9H1ozQkY/D7PPYBoM8/8zkRFtEgS7wHvE5qf41Qkp3ynIsCYgqz3lXVH0
         NWnpjVLAFYtTFHw3MPns5xkZOBtYzBs8kABYtHdrUSCDqNj8zF3o6pq4TwfC+Aqe5WUC
         TdNREvM+TslraYJLa0+R9aDl7O0KUuohP3enFZlUULAH+aItG3uNU1j8xB5vjurywfUH
         YalG9kdXbzqJCzFSmsaxUCYOn6XPK1YEJXUuQOsYjytxpGhn2kcFdn2j41AA9qAvSAAr
         a/7Aufx0DS1GEIZvCggL5TA4Lp6o7CCxNvSLt6HE9EdYedubXEVbHEvxzPyVt4r62Dyl
         kz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KvcI+kICoxFmJJAM8JM8i9oBM69AG9tcbWFGpBAobjg=;
        b=uNGkmVpFI7DMejx8a6uP6u7HraYRu2zvswZol2GDHg2/531DczuiS1wJZu+1rKBti4
         JkWZUQ/+wow6z8xKb2NYeBPE2/3coDkAqYHeKij0rqrPPKkQVr+okEwo45xEFNnA9qal
         vUosv73Q/ToZmHPqE5jeBod2/cgH0TKr6ZGgn62y4vgBDIgMgqAbR4kNilGykD7SbU43
         ENpM8GhHYhFRzCEdPGTF2sFY37TiwLDWZB7OkpZ5ocB0jIEzpPAEpTKwrFx3eZKkeK4Q
         1xkDG2a78JsUSCxNfD9+2JdbWmx0YqfuW0tA4iwZ+5dKsMH+IotWIgPq2B9hBR0GOLvO
         wJ3Q==
X-Gm-Message-State: AOAM53019bhRJDznjFNxSB6+B/+nZZp+38Mry8UVNhulMrc9O5W29lGl
        bPgFJlT+TXyTKTITo8d1cCeFQa0/ufy2dtnkZEWBzS1tiRs=
X-Google-Smtp-Source: ABdhPJwRF8FcqV19/W2dAjKsAmg/oTiosOZeqg2vigvC8g6BEFE/EH9zFa+N7CC+wGEF24lqodrPXipeBYWbUFsivyw=
X-Received: by 2002:a05:6402:38f:: with SMTP id o15mr6703710edv.361.1615210014747;
 Mon, 08 Mar 2021 05:26:54 -0800 (PST)
MIME-Version: 1.0
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
In-Reply-To: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Mon, 8 Mar 2021 18:56:43 +0530
Message-ID: <CA+sq2CfmwwXONTbcz_C+YMGBRNzbwaq2XGrzje_e=3YuJikeQw@mail.gmail.com>
Subject: Re: Query on new ethtool RSS hashing options
To:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 4:15 PM Sunil Kovvuri <sunil.kovvuri@gmail.com> wrote:
>
> Hi,
>
> We have a requirement where in we want RSS hashing to be done on packet fields
> which are not currently supported by the ethtool.
>
> Current options:
> ehtool -n <dev> rx-flow-hash
> tcp4|udp4|ah4|esp4|sctp4|tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r
>
> Specifically our requirement is to calculate hash with DSA tag (which
> is inserted by switch) plus the TCP/UDP 4-tuple as input.
>
> Is it okay to add such options to the ethtool ?
> or will it be better to add a generic option to take pkt data offset
> and number of bytes ?
>
> Something like
> ethtool -n <dev> rx-flow-hash tcp4 sdfn off <offset in the pkt> num
> <number of bytes/bits>
>
> Any comments, please.
>
> Thanks,
> Sunil.

Apologies for wasting your time.
This hashing support is not needed anymore.

Thanks,
Sunil.
