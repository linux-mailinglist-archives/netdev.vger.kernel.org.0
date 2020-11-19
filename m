Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C8D2B9A6C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 19:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgKSSMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 13:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbgKSSMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 13:12:47 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C558EC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 10:12:46 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id k4so6854218edl.0
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 10:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BFBvmo9SnkLr6paSqs8UVetLKIqOW6JUR7s4N2he7Do=;
        b=SwGfFwQ2tVpYeQXrn8RDYJp/nl4WWUJPBsXJYOAzks5ONO0M1s4AAo5ALmi+LIFwSP
         mw00Ar3trQwrhTQZdyNaF1cQfAU6mQxNcUoLQ+ORh0YNB06DmKc9f7pPfEOxVRfcvC5Q
         W/EN2dz3cbw9R5GGok5MqL0s9o4sPdgWA3vs/pAJZSe2N4cUNu/Z6IMpujM0/35aZyOh
         PVNraW8RWOLTpDIaZNgAykAgV5YoJocJKGo+AOonQFy47bahKc8W8/Yq7QsqEznv5sUZ
         8V2k9pKJ4jV+O4VT6R5v7wGP8IGGdJ5oIlClm/94EM924BfMI9UJDx+th5ddbTx4Ylkn
         i9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BFBvmo9SnkLr6paSqs8UVetLKIqOW6JUR7s4N2he7Do=;
        b=VzLUWTMWjyjuaeXCVUcZUGPSGdMXcmeg2tjJxwwUdrfCjP6EV2Yt7H0ZiMAH5MJA6t
         59EZmzj+mmQI7wQEoF95HKZh41VC/s0xRd4O+OWbP0XQmuvtYXHnYmkUhc5kyBCZOOqu
         kvjO0JaGKeQAAMeknTtd6ZrVznA9O3p8dcIBn1/Wo6RH10p8wMlQtEmcMe+3wVqfGYEu
         Kb/NBrN+FMy747gxIl+oHveF4ebwtZWdBuwh/ao3egjPBRagYAe4oBR3E1dCfIhXQWV7
         Vkeqq3w9MsTILBFLxRWNZGZDfMmroQL+aQScb3T9YV1OLe6S5oIPsA2r/mFCnvCv2p4L
         2izQ==
X-Gm-Message-State: AOAM533InfqbvnR8bS65IOEykxD9CbwzlS0y848DWVO0UcK7u+tTv4jz
        LjXteFzhtJeAKErcg5z44bc=
X-Google-Smtp-Source: ABdhPJxBf6GpJZYDJSV7xRt2EdlkoVmnxqd8YolKYu2MKGGv72ScmrOBcctlXgozW54wPBKT1KTDCA==
X-Received: by 2002:a05:6402:1cb8:: with SMTP id cz24mr8082719edb.34.1605809565509;
        Thu, 19 Nov 2020 10:12:45 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id b15sm97231edv.85.2020.11.19.10.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 10:12:44 -0800 (PST)
Date:   Thu, 19 Nov 2020 20:12:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201119181243.nhmoxdpqcvx7kehh@skbuf>
References: <20201119105112.ahkf6g5tjdbmymhk@skbuf>
 <C777W1ZC293J.3GT3X4KIN7PM9@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C777W1ZC293J.3GT3X4KIN7PM9@wkz-x280>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 12:52:14PM +0100, Tobias Waldekranz wrote:
> > it appears that I don't need the .port_lag_change callback, and that the
>
> Ok, does ocelot automatically rebalance the LAG based on link state? I
> took a quick look through the datasheet for another switch from
> Vitesse, and it explicitly states that you need to update a table on
> link changes.
>
> I.e. in this situation:
>
>     br0
>    /  |
>  lag  |
>  /|\  |
> 1 2 3 4
> | | |  \
> | | |   B
> | | |
> 1 2 3
>   A
>
> If you unplug cable 1, does the hardware rebalance all flows between
> A<->B to only use 2 and 3 without software assistance? If not, you
> will loose 1/3 of your flows.

Yes, you're right, the switch doesn't rebalance the aggregation codes
across the remaining ports automatically. In my mind I was subconsiously
hoping that would be the case, because I need to make use of the
information in struct dsa_lag in non-DSA code (long story, but the
drivers/net/dsa/ocelot code shares the implementation with
drivers/net/ethernet/mscc/ocelot* which is a switchdev-only driver).
It doesn't mean that keeping state in dp->lag is the wrong thing to do,
it's just that this is an extra challenge for an already odd driver,
that I will have to see how I deal with :D
