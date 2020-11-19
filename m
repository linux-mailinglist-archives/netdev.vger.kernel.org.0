Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3F52B925D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 13:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgKSMOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 07:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbgKSMOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 07:14:12 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F2DC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 04:14:10 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id d17so7876550lfq.10
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 04:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=43Lm+cdFIN23Awmx15ktrV2KZ2DgXdJjk7MI28AP6nI=;
        b=dYjn1VLqdhw8ghmRfr11UnbT3RKvIUB8IMbPr16+26+bUmhH8B5qd0i25YNYKFOE5h
         f/1pQh+0815TO5nD+ZDAQDB0Aw4N2UWdF1ayPDu8Bp8k3hvRqdW2kjhsOU9YLXT6tjvI
         u7x3CSwmKogcL8JEoaEsCh5h6o6egKfjrsheMUgCyYXO1AvvXMFy1QNi9+2cw+cPKJ4o
         vBx7XAlArEPex1hlQpGjDkPf/4RY187yEAKDs3VLgWfKo1QOcYYoehbV+JPSvql8N0Ly
         hcIgAA4Aum5QZBSJDo4HebnYQE7M8s8ufUcK+BDV0edttSEXapfyrwf3/XLBR/53hsqF
         1krQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=43Lm+cdFIN23Awmx15ktrV2KZ2DgXdJjk7MI28AP6nI=;
        b=CjP9XkBS6zRcWms9yWF72R7eICmnXkE85XuSphQ8xoapzxAfhSm+tX5rDysyAsHBbu
         yQZSwWxZ2ElfEs+gqIyOXcEkQM9GsapSJzG1TMKe6A1symDMuQ0HDD7/AvtAvwgTgYXq
         ejFK010oHIx+ZLnYtrRuwUG9QlUrS7x6snzmiiWILJntJtsx3VpvpUibxBJoUQU9Z9Pp
         yHm7nVDN+0Tm887R7TOnXWPQ9eQJaXwJR/stksi1Ie4pR92KCi+8tGHw/Yy2mObXSMSX
         OeJ8JxSbyORvqmbb/k3fAu9u3LQEVGV9ziFDCjICJiLfYpTm95hxzZce2o1bf3C+gYzQ
         JJ/Q==
X-Gm-Message-State: AOAM530CuWe9HBQcBNSu+9rRBFczlObwj1j9u+1POCBQeCAIyQDZGQ7M
        vt4VYXwKE0o/j0Plerx6E3ONgg==
X-Google-Smtp-Source: ABdhPJz76gvFOp/7qY00aQXJQs4VS6O3//Zk3t0tGCPQlevC9in80/loXZtS5hHm0lTtXPp46Bkj6A==
X-Received: by 2002:a19:d02:: with SMTP id 2mr5600282lfn.294.1605788048911;
        Thu, 19 Nov 2020 04:14:08 -0800 (PST)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y11sm3441693lfl.119.2020.11.19.04.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 04:14:08 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>
Date:   Thu, 19 Nov 2020 12:52:14 +0100
Message-Id: <C777W1ZC293J.3GT3X4KIN7PM9@wkz-x280>
In-Reply-To: <20201119105112.ahkf6g5tjdbmymhk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Nov 19, 2020 at 1:51 PM CET, Vladimir Oltean wrote:
> I have tested these patches on ocelot/felix and all is OK there, I would
> appreciate if you could resend as non-RFC. In the case of my hardware,

For sure, I am working on it as we speak. I was mostly waiting for the
dsa-tag-unification series to make its way to net-next first as v1
depends on that. But then I remembered that I had to test against the
bonding driver (I have used team up to this point), and there is some
bug there that I need to squash first.

> it appears that I don't need the .port_lag_change callback, and that the

Ok, does ocelot automatically rebalance the LAG based on link state? I
took a quick look through the datasheet for another switch from
Vitesse, and it explicitly states that you need to update a table on
link changes.

I.e. in this situation:

    br0
   /  |
 lag  |
 /|\  |
1 2 3 4
| | |  \
| | |   B
| | |
1 2 3
  A

If you unplug cable 1, does the hardware rebalance all flows between
A<->B to only use 2 and 3 without software assistance? If not, you
will loose 1/3 of your flows.

> source port that is being put in the DSA header is still the physical
> port ID and not the logical port ID (the LAG number). That being said,

Ok, yeah I really wish this was true for mv88e6xxx as well.

> the framework you've built is clearly nice and works well even with
> bridging a bond.

Thank you!
