Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F353523AE40
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgHCUg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgHCUg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:36:56 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AE1C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 13:36:56 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q128so4090266qkd.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 13:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+ECIdSivTniC6/GqAYDee/eqfFoiQyRhRAKJ+QSM+W8=;
        b=kTw28SAqjHAfQP4MZxFMddU47/o9jHAnovFWScZLAc1S8L2ptis+HtPNLXOQgaeJ+q
         Iyil++z95kXTCw0flr5XyLFxrayJvT3TIt/F65PjDSF++pNu1oEyE3Rjpy6lClk5mxUD
         R+4xvc1HC0CkDUL1g3ZbQbrdjlIxtgz7ei5jBmHMlQSGV4pbZA3k2BxiWPQWmUzSfiHL
         dNOApeheLdKqdYQ146w1r2MYrgrCm0SmUALtjHsW1CH3NTnVdip6pbvrI7bCaaPl0c3j
         FPcVvvKKra7uO8PpcEc6fMeqZhFzvTI3am115CIcDUY3bPUOqWMa+MEUIGu5yO3L0qdL
         05gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ECIdSivTniC6/GqAYDee/eqfFoiQyRhRAKJ+QSM+W8=;
        b=ONujtUQ1C28CN2ZTSb4TE+OdDh4KdEr83iQc9kZPTySHQG/fJZDAEA6SPtWhyErtAt
         jM0A9P9XdUrsa0XNup4pZNEBNgfvYFfDozQtoWT6KdMNzgt4jyW/f3KwnSNtY/X/IXfc
         EHAqIHA6riZqrccBkqCcJCblw7jJ2bMpC2Pc7Ykk7P83/v5iys4Do6qIktVnlDpjFe8+
         os/iU8qjItXsUdJYQKmRrLp53wQ96zrvjbUthzZPHktDmZAsxCA6Oh5CfJ6HPVAGMxMg
         bhe67RmUtglDSqv/aMRKj0nnCMAgpqUZ/sET2c59eqLj5fnr04YTS4akqfmorUZXfixi
         NMCA==
X-Gm-Message-State: AOAM5328i7UUdnYiVplllxRsbyWrgl5lVkouHJi+Sdl5MbA/oM3v6lGA
        af7vixItB7nFbRw3JdEh7pE=
X-Google-Smtp-Source: ABdhPJyYO6OvdHqyFGUAl9khQMF5TNU+RgV1hBr+266PbMDJ5V4O71BaMLpTqYuOqc7iyWq4weL4rA==
X-Received: by 2002:a37:613:: with SMTP id 19mr17246137qkg.220.1596487015717;
        Mon, 03 Aug 2020 13:36:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x12sm25188687qta.67.2020.08.03.13.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 13:36:55 -0700 (PDT)
Subject: Re: [PATCH net-next 0/5] net: dsa: loop: Preparatory changes for
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200803200354.45062-1-f.fainelli@gmail.com>
 <20200803203357.GE1919070@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8d8ab871-1d0e-4f6d-70d0-0d8d6dc9d4d2@gmail.com>
Date:   Mon, 3 Aug 2020 13:36:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803203357.GE1919070@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 1:33 PM, Andrew Lunn wrote:
> On Mon, Aug 03, 2020 at 01:03:49PM -0700, Florian Fainelli wrote:
>> Hi David,
>>
>> These patches are all meant to help pave the way for a 802.1Q data path
>> added to the mockup driver, making it more useful than just testing for
>> configuration.
> 
> Could you give some more details. I assume the tag driver is going be
> to more active. At least, that would make sense with the data
> structure moves.

Still working on a 802.1Q data path that allows to carry VLAN tags from
the DSA CPU interface (guest side) to a tap (host side) and from there
you can ping, bridge etc. devices. I am having some problems with the
responses sent back to the guest which are incorrectly tagged on ingress.

You can see the WIP here:
https://github.com/ffainelli/linux/commits/dsa-loop-8021q
-- 
Florian
