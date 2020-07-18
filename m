Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1C4224AD4
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 12:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGRKyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 06:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgGRKyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 06:54:16 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E1AC0619D2;
        Sat, 18 Jul 2020 03:54:16 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id b25so15443775ljp.6;
        Sat, 18 Jul 2020 03:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=4+Us3oPEnWE7fXo4POm7jubr7S3pUf6WNnSSuhIFOYU=;
        b=ZJEZwKJ6SACK6BlpXIjM3mrudlnE8Febg1rZVWioXZ6IQmaj4huzNHFfML6FAqYiun
         QeuPublMctEtIBmR6iRRCm4fFOsJmKLeTqf2Md7wPUZDaVcAAjPlVNSN3N3ClQ/Mkr3P
         hdalbU/fMgqwAhTTuTTKXwbk5R/Wg8ABbn/mmlYxNhBVrE+r4Y1k7jS/I7LmIXUntFdr
         ve8A4TgcvCjabwIh0u/VvvZGD7ORTxlTJP/j5Jv5JvEKrirQ3B/OkV686ZEHrEbj2XVJ
         eGB+L6MwAveKdaZyu5BUHKzPIrmh8AYzLqx6NqaTaw0CJG37f1V0wMzsHLSbnmpuwB6N
         TnAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=4+Us3oPEnWE7fXo4POm7jubr7S3pUf6WNnSSuhIFOYU=;
        b=bjwy4+Ur1U/viqyh3+RXtg7d7+Nho8ZMlofx0hkxJH9YWi7xwfhO0RFU6zVf00qECI
         BSiDsZQFjz85p85s+ZsDxCXR+ptw97t7h+Xqv2sNK4qr62ww02jt9+Xd9V/Ze6aQYHea
         ooEWLCzE8hfLRZBWEjT/RfKwkiuX+Fu0TqD6eWVZZZfXd2X2OdRfg4+R0dHyAlsORhE6
         UMhOkM1mzCxlVfDN9OegTEVOxubg9cLtY8o49DOimmpdPPQd1yeR9nQ46VQWyDJYwnLT
         zUT4k0AVKmVZBhfhPLl0IUyC5RdLE0DHVGarQ6/cO3CDpE3O13S5Kt4Mz8xv0lmiLdMx
         xvEw==
X-Gm-Message-State: AOAM53022KGH9jr7v2TiJ/XUlGCqY0l8OOSJjp64bSKGxA5G197KubLi
        TC6rdGUv1OWYM0Ifd/RaIyOs/zLT
X-Google-Smtp-Source: ABdhPJwMjNbt2whxYPQA2My4WfIF107OMmWcNbvRSwkRKWEnJGyZ0Tyu+jEHadZxnqOyQrY6WX4X0g==
X-Received: by 2002:a2e:1514:: with SMTP id s20mr6019915ljd.455.1595069654384;
        Sat, 18 Jul 2020 03:54:14 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id g2sm2511992ljj.90.2020.07.18.03.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 03:54:13 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Document more PTP timestamping known quirks
References: <20200717161027.1408240-1-olteanv@gmail.com>
        <87imelj14p.fsf@osv.gnss.ru> <20200717215719.nhuaak2xu4fwebqp@skbuf>
Date:   Sat, 18 Jul 2020 13:54:11 +0300
In-Reply-To: <20200717215719.nhuaak2xu4fwebqp@skbuf> (Vladimir Oltean's
        message of "Sat, 18 Jul 2020 00:57:19 +0300")
Message-ID: <878sfh2iwc.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Sat, Jul 18, 2020 at 12:13:42AM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>> 
>> > I've tried to collect and summarize the conclusions of these discussions:
>> > https://patchwork.ozlabs.org/project/netdev/patch/20200711120842.2631-1-sorganov@gmail.com/
>> > https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-5-kurt@linutronix.de/
>> > which were a bit surprising to me. Make sure they are present in the
>> > documentation.
>> 
>> As one of participants of these discussions, I'm afraid I incline to
>> alternative approach to solving the issues current design has than the one
>> you advocate in these patch series.
>> 
>> I believe its upper-level that should enforce common policies like
>> handling hw time stamping at outermost capable device, not random MAC
>> driver out there.
>> 
>> I'd argue that it's then upper-level that should check PHY features, and
>> then do not bother MAC with ioctl() requests that MAC should not handle
>> in given configuration. This way, the checks for phy_has_hwtstamp()
>> won't be spread over multiple MAC drivers and will happily sit in the
>> upper-level ioctl() handler.
>> 
>> In other words, I mean that it's approach taken in ethtool that I tend
>> to consider being the right one.
>> 
>> Thanks,
>> -- Sergey
>
> Concretely speaking, what are you going to do for
> skb_defer_tx_timestamp() and skb_defer_rx_timestamp()? Not to mention
> subtle bugs like SKBTX_IN_PROGRESS.

I think that we have at least 2 problems here, and what I argue about
above addresses one of them, while you try to get solution for another
one.

> If you don't address those, it's pointless to move the
> phy_has_hwtstamp() check to net/core/dev_ioctl.c.

No, even though solving one problem could be considered pointless
without solving another, it doesn't mean that solving it is pointless. I
do hope you will solve another one.

I believe that logic in ethtool ioctl handling should be moved to clocks
subsystem ioctl handling, and then ethtool should simply forward
relevant calls to clocks subsystem. This will give us single
implementation point that defines which ioctls go to which clocks, and
single point where policy decisions are made, that, besides getting rid
of current inconsistencies, will allow for easier changes of policies in
the future.

That also could be the point that caches time stamping configuration and
gives it back to user space by ioctl request, freeing each driver from
implementing it, along with copying request structures to/from user
space that currently is done in every driver.

I believe such changes are valuable despite particular way the
SKBTX_IN_PROGRESS issue will be resolved.

> The only way I see to fix the bug is to introduce a new netdev flag,
> NETIF_F_PHY_HWTSTAMP or something like that. Then I'd grep for all
> occurrences of phy_has_hwtstamp() in the kernel (which currently amount
> to a whopping 2 users, 3 with your FEC "fix"), and declare this
> netdevice flag in their list of features. Then, phy_has_hwtstamp() and
> phy_has_tsinfo() and what not can be moved to generic places (or at
> least, I think they can), and those places could proceed to advertise
> and enable PHY timestamping only if the MAC declared itself ready. But,
> it is a bit strange to introduce a netdev flag just to fix a bug, I
> think.

To me this sounds like a plan.

In general (please don't take it as direct proposal to fix current
issues), the most flexible solution would be to allow for user space to
select which units will be time stamping (kernel clock being simply one
of them), and to deliver all the time stamps to the user space. This
will need clock IDs to be delivered along with time stamps (that is a
nice thing to have by itself, as I already mentioned elsewhere in
previous discussions.) For now it's just a raw idea, nevertheless to me
it sounds like a suitable goal for future design.

Thanks,
-- Sergey
