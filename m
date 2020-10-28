Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95D929DBA6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbgJ1Xsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388099AbgJ1WrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:47:15 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37B5C0613D1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:47:14 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i2so1013775ljg.4
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=C+42rBvKIdGM3Y5LYQUJBH0oMdtFxp/xiX6aLmLXhZE=;
        b=z9edmOdGlsli0eU4OLju+/gPuDQmIbXpaiJx13dHyqMob1/rOaUyq24SQx0v3CpXgB
         BjAiep00VOkmPhIEUSsH3Kfdmm1IdAYd90QR5jd+OwamlduDoSPeza233SX0FedRnTch
         URnvy8w+W/bR6WmC85MS2rfpNK6bMlcQeXlXH/uOlcRvLlB9nIg/NG9f96bLdi5lJeP9
         gQXsYtw4fwHNdn1PcOFnSANIga3rdlSWvjSRWDWMbJK+nU0RQQtOhSjWjjACkYL4GcI/
         +E32oNSY8LldK9pdqW9ah9fe7af7OdL9y8sFcmCwE9Dix3gKfAheCaRQase4I33Zhi2q
         E/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=C+42rBvKIdGM3Y5LYQUJBH0oMdtFxp/xiX6aLmLXhZE=;
        b=YGZbwUMqXCPE4TKpxPZYDSnAn4jx9gRalgVylNmL7OUaNss6/rAkpO1dQnR30hy+TH
         TcFC01azrL/csGCq7XijGsZRUyxLl3OeKS6bHxRlGqXmSWSFVznH40dS+fFnM7nS5VBM
         Xvm4C1LbU8aivwaPGNS5b1vw43/tiW3PGRahOGviRbLOJrQWfqroz8v0B/tGp5Em2mVE
         95cPRoyo1WuBTqGTzrOha4yMDFzeuhf+YXz/NEuzWnUdI/tGgl8552CeSiJSM5R4eHJO
         NoYOLhHowczPoyrJEFc0x+wWgcXg2PrmFlHL3HQaCvQNShYFzXE0C/HBLt9phsueS0jM
         tZ9g==
X-Gm-Message-State: AOAM531oLRI/eaaNj+wEZ52zl8//3trRe8JpGEp89RDYbIl67hxDJzdp
        VNagM2LZNep8G7sUjoZAPA2u87Y6KCzoFjsz
X-Google-Smtp-Source: ABdhPJwBvXj5bf/Do4CplvmqNAroMWXfjtdb+Gr+0aLd1fn32vJBprxLjnRchT5Bv5telLY3W2QPbg==
X-Received: by 2002:a19:4a16:: with SMTP id x22mr1913853lfa.66.1603845912677;
        Tue, 27 Oct 2020 17:45:12 -0700 (PDT)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id a77sm332164lfd.77.2020.10.27.17.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 17:45:12 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
In-Reply-To: <20201027223628.GG904240@lunn.ch>
References: <20201027105117.23052-1-tobias@waldekranz.com> <20201027223628.GG904240@lunn.ch>
Date:   Wed, 28 Oct 2020 01:45:11 +0100
Message-ID: <87361zuqjs.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 23:36, Andrew Lunn <andrew@lunn.ch> wrote:
> If you are dynamically allocating dsa_lag structures, at run time, you
> need to think about this. But the number of LAGs is limited by the
> number of ports. So i would consider just allocating the worst case
> number at probe, and KISS for runtime.

Oh OK, yeah that just makes stuff easier so that's absolutely fine. I
got the sense that the overall movement within DSA was in the opposite
direction. E.g. didn't the dst use to have an array of ds pointers?
Whereas now you iterate through dst->ports to find them?

>> At least on mv88e6xxx, the exact source port is not available when
>> packets are received on the CPU. The way I see it, there are two ways
>> around that problem:
>
> Does that break team/bonding? Do any of the algorithms send packets on
> specific ports to make sure they are alive? I've not studied how
> team/bonding works, but it must have a way to determine if a link has
> failed and it needs to fallover.

This limitation only applies to FORWARD packets. TO_CPU packets will
still contain device/port. So you have to make sure that the control
packets are trapped and not forwarded to the CPU (e.g. by setting the
Resvd2CPU bits in Global2).

> Where possible, i would keep to the datasheet terminology. So any 6352
> specific function should use 6352 terminology. Any 6390 specific
> function should use 6390 terminology. For code which supports a range
> of generations, we have used the terminology from the first device
> which had the feature. In practice, this probably means trunk is going
> to be used most of the time, and LAG in just 6390 code. Often, the
> glue code in chip.c uses linux stack terminology.

Fair enough, trunking it is then. I don't expect we'll have anything
mv88e6xxx specific using the LAG term in that case. From what I can
tell, the trunk settings have not changed since at least 6095.
