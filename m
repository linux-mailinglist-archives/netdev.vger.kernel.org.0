Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725753F1D66
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbhHSQBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhHSQBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 12:01:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57457C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:01:10 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x27so14020143lfu.5
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=GClqOFxFEfC+krefx64HgWgWYCi/YRwdN7djuSeQf4U=;
        b=sDyifaj3eNNHcpO2QoAnYYjlFqNV9jsxHXWLw0hSH9gHYupXSH3AYMPL4D+7gce/M8
         36FyYRX9os3bv8RjgqqSA7vtD37MAAV0op6s+l8oviK9LVXDw6R6RplgFscWEvxwO+rJ
         Ge9r5BRcZwWqWWybi8Wnn6asbhxxdG19/P8jQA9WsHBAYdkNvyfAfOGFJcNQjqpFUV/8
         b+fKeKUQ7sQhtmwE9pZ/pbEhG31qmnYtCATiIjzCYoKqWW0gkG4ns80qrO6zmq0FLWKG
         E9T7HmeTcHkQhCRAEK/iHE8isQVJ8vbdLP5cfs+khY4yvOsRLDMhT1XhmKTptu90f8KD
         DoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GClqOFxFEfC+krefx64HgWgWYCi/YRwdN7djuSeQf4U=;
        b=NL548crV90EnO9HwvmGhZbY7GnttFYV494NAVcWag8t+TRdqMMpVu51cPJBv0duIP/
         uDHZcm8vHyVLoWpHJxtECK/aPRK0QePPF30wFl3fUKyaSAv2Q/q9J8nH5vCR+3WciRdd
         FXXQaEvXjGE81mcRMxd5sPu4VIYs17kg0Eqxp5ITbSaO3j4bSEl1yRg+cm7BKgBJxaxD
         oQLl2yqvOPOQtjahqG2p7rseVPdrcIm/n8H+N+pqmfDwLbt98KM1ZL815JwYzdi8z63y
         BVzkxDA0jFYXy4MFhSaXmdNkXHPcDT0WFTWjgMuXTD9DV/oeQJc11hgCe7gAP2HfwQM0
         Jd2Q==
X-Gm-Message-State: AOAM532E+AtjO8nsJrBIX//CX8tmc3CmpN4GocgWq1mbyTFuEM98kg1U
        rL0h+SPhHud08upJApqigCo=
X-Google-Smtp-Source: ABdhPJxoAq0FUyM3u5+RYVoK7AjggZpWA/LnLxzJ8X6othdFB7ro4TZEIZsBcKWSAcWAhwmjtgKf+Q==
X-Received: by 2002:a05:6512:ac4:: with SMTP id n4mr10995422lfu.475.1629388867150;
        Thu, 19 Aug 2021 09:01:07 -0700 (PDT)
Received: from wbg (h-155-4-221-58.NA.cust.bahnhof.se. [155.4.221.58])
        by smtp.gmail.com with ESMTPSA id n2sm344695lfu.109.2021.08.19.09.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 09:01:06 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next 00/15] net: bridge: multicast: add vlan support
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
Date:   Thu, 19 Aug 2021 18:01:05 +0200
Message-ID: <875yw1qv9a.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hik, everyone!

On Mon, Jul 19, 2021 at 20:06, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> This patchset adds initial per-vlan multicast support, most of the code
> deals with moving to multicast context pointers from bridge/port pointers.

Awesome work, this looks very interesting! :)  I've already built and
tested net-next for regressions on Marvell SOHO switches, looking good
so far.

Curious, are you planning querier per-vlan, including use-ifaddr support
as well?  In our in-house hack, which I posted a few years ago, we added
some "dumpster diving" to inet_select_addr(), but it got rather tricky.
So I've been leaning towards having that in userspace instead.

> Future patch-sets which build on this one (in order):
>  - iproute2 support for all the new uAPIs

I'm very eager to try out all the new IGMP per-VLAN stuff, do you have
any branch of the iproute2 support available yet for testing?  For now
I've hard-coded BROPT_MCAST_VLAN_SNOOPING_ENABLED in br_multicast_init()
as a workaround, and everything seems to work just as expected :-)

Best regards
 /Joachim
