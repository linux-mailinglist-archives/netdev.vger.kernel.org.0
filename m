Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CA7371F77
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 20:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhECSWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 14:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhECSWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 14:22:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DC0C061761;
        Mon,  3 May 2021 11:21:13 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d11so6577099wrw.8;
        Mon, 03 May 2021 11:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JH9uEbFZLY261RSwVYxFlsQtuJncx5cqZ11oI51lAM0=;
        b=RsH1aj2SWOf7/OWs6Lj6sH6NuMbg63P1+KsTqkyzR1WEWHEMpxniHYsHrBMf4mwO0S
         aB0cEatMVEkWzFNyCiWSQGetrUetLHNO6RR/K3+JVfZYObmqUE0BBEYnsvCpzUbcHEDP
         eje01Z1hETfrHhLD/G8M3eclFKeJ5rQ5tULTYcAV309yYrdZRlj99WNZEmWETTs3J1oz
         yAKOGjFaRC+9HE9Avcs2txy1M7xdI2mNzzMFLNIYEZ9LjTbqasnlV4pfSTQd+s60nq3W
         HWoQV78p5AsqZ/dQ1L5u313GH94nBiWYZhIAAFX47FDAYShixu6AP6Jvxk9De89/SdY8
         NkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JH9uEbFZLY261RSwVYxFlsQtuJncx5cqZ11oI51lAM0=;
        b=DLsL7qb6kvG04ldRAyzsjQ9AQQDvEmTGeyHkOMKENCfed2PPzk7BJfiEd/sED8LWJS
         GBBTWUYREZJ93R0V4qzyo16JkT8O245+1j7TPvUeKUHDJB6zLCHPnqzDJ/GdM+cMH2+R
         FbFFmP65fFH423YkQxye2Gf5B7TVdLWy126GJ+lvcD3zEJuvnaOLRVwpXgWDoMP+zbix
         y0lGRD/jPWn5ewhcckj0ckdkP6R9Z9b8TwUTB+DszoiuRL5KFbw855HhyQd47gLTJZQX
         DUlxpzzKVDqktNb4z1uIhUqZTUJ3obqvqq7rdJAbtmbwzUPhHdrF0K/FcWWkxDZQxg9C
         WVHA==
X-Gm-Message-State: AOAM533O+V+MQ/ehaiWIPqy9xxqF0AYLHDrETACGg1u6I1laK+c0XXap
        aRvu6K0mfe6fp2SeH98CLWnL4HNM2TiKz82H39Q=
X-Google-Smtp-Source: ABdhPJz1nRQ6kJzh7PewOUUDY4/llzeUg1g/85JQFPFE81/cAxRnMCa9uKpEY5nUNYP8vftC4K6q38CMskJBbjTfX2U=
X-Received: by 2002:adf:dc4f:: with SMTP id m15mr26720403wrj.420.1620066072241;
 Mon, 03 May 2021 11:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210503102323.17804-1-msuchanek@suse.de>
In-Reply-To: <20210503102323.17804-1-msuchanek@suse.de>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Mon, 3 May 2021 13:21:00 -0500
Message-ID: <CAOhMmr701LecfuNM+EozqbiTxFvDiXjFdY2aYeKJYaXq9kqVDg@mail.gmail.com>
Subject: Re: [PATCH] ibmvnic: remove default label from to_string switch
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     netdev@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 3, 2021 at 5:54 AM Michal Suchanek <msuchanek@suse.de> wrote:
>
> This way the compiler warns when a new value is added to the enum but
> not the string transation like:

s/transation/translation/

This trick works.
Since the original code does not generate gcc warnings/errors, should
this patch be sent to net-next as an improvement?

>
> drivers/net/ethernet/ibm/ibmvnic.c: In function 'adapter_state_to_string':
> drivers/net/ethernet/ibm/ibmvnic.c:832:2: warning: enumeration value 'VNIC_FOOBAR' not handled in switch [-Wswitch]
>   switch (state) {
>   ^~~~~~
> drivers/net/ethernet/ibm/ibmvnic.c: In function 'reset_reason_to_string':
> drivers/net/ethernet/ibm/ibmvnic.c:1935:2: warning: enumeration value 'VNIC_RESET_FOOBAR' not handled in switch [-Wswitch]
>   switch (reason) {
>   ^~~~~~
>
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---

Acked-by: Lijun Pan <lijunp213@gmail.com>

>  drivers/net/ethernet/ibm/ibmvnic.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 5788bb956d73..4d439413f6d9 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -846,9 +846,8 @@ static const char *adapter_state_to_string(enum vnic_state state)
>                 return "REMOVING";
>         case VNIC_REMOVED:
>                 return "REMOVED";
> -       default:
> -               return "UNKNOWN";
>         }
> +       return "UNKNOWN";
>  }
>
>  static int ibmvnic_login(struct net_device *netdev)
> @@ -1946,9 +1945,8 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
>                 return "TIMEOUT";
>         case VNIC_RESET_CHANGE_PARAM:
>                 return "CHANGE_PARAM";
> -       default:
> -               return "UNKNOWN";
>         }
> +       return "UNKNOWN";
>  }
>
>  /*
> --
> 2.26.2
>
