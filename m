Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27191CEB50
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgELDYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:24:30 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3448C061A0C;
        Mon, 11 May 2020 20:24:29 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e2so9760495eje.13;
        Mon, 11 May 2020 20:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GGa1hHB8aS6b+kK4UakLNLw0Zey9QpIIZ9ZG51zzzqk=;
        b=syE7Bn2nLNHI1e5lQihzLzLQMEFpyt+y/X6C5z6229MhJOEpxH6/Xbhy2awzcl6ogO
         kfRaj8YZhuooBeEla7wN06VFBHUf7AhXRTuMh8mfOv2LZyMNaMEv7cuwrhc6f2c08RD+
         86WlqjnJ5u3wt7iUmbU5U4uKnYndcZloI9ZMPl4oVJMe+q0DR+0iL44ZkBR+4wwNps/4
         RoYKsGV2ZIBnA6Tp/bYqAMmYBT7dKd5zz02Ec1ZFHAos8TTaZcywhjej+J3TrcFo9L9B
         4ilBa0xgkPIBImim4KZVFzCjYLW32ln4bcG2D56rh/ZfQHbuILTWpTGJp5JOIbTqncTO
         quFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GGa1hHB8aS6b+kK4UakLNLw0Zey9QpIIZ9ZG51zzzqk=;
        b=mRPR5U3irjiGMBGNx3FTPH6/8woQW+8vebvNbKuNaNJTseKChoyggMTpA2177emPaq
         HhGEfrnIb284+rlayjDDx7KVnTw13nvzg0c4D2OjIDahRu9GrB00rYB0msZaSjPN9I/U
         XbBpGvdVEJv7SwofalWmkFLyopTyfRG0pQP1gU4/UA0Hv0uCXVcvgunvh9Uzwtsns+SU
         Mjs2zgOxtIPS25BodIaOxnDTHNhWR8/sUp/2NCCz63x6nuJjDLD+fNHmpqLvBIirsG0C
         4Wpp0hM3LGZI7G7Z3Pq1THHKvb5YMMHGmLaERdiHLtUthm7C5Zeqqlgs68AMB2M8TzF1
         rEdQ==
X-Gm-Message-State: AGi0PuZrUtWrT5VZWFeQgbcLm27kh1owfBlUtrfF0ypTRlqAUcDh2aXW
        WgiNlMBnIXuzvhsbrxZgqiOf9q1B
X-Google-Smtp-Source: APiQypIlMVG8FX5zBdYVHc8/6r3gAqj8+yZkrOAT3HyDmOG2N99d7HI8A5vPSHQZs1ie91O1mHWnlg==
X-Received: by 2002:a17:906:1387:: with SMTP id f7mr15434624ejc.333.1589253868121;
        Mon, 11 May 2020 20:24:28 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x8sm1547136edj.53.2020.05.11.20.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:24:27 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: bcmgenet: add support for ethtool flow
 control
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-5-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5c0bc3b6-e2f3-e08d-d84a-86d00d2dcd4a@gmail.com>
Date:   Mon, 11 May 2020 20:24:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589243050-18217-5-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 5:24 PM, Doug Berger wrote:
> This commit extends the supported ethtool operations to allow MAC
> level flow control to be configured for the bcmgenet driver. It
> provides an example of how the new phy_set_pause function and the
> phy_validate_pause function can be used to configure the desired
> PHY advertising as well as how the phy_get_pause function can be
> used for resolving negotiated pause modes which may be overridden
> by the MAC.
> 
> The ethtool utility can be used to change the configuration to enable
> auto-negotiated symmetric and asymmetric modes as well as manually
> enabling support for RX and TX Pause frames individually.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>

[snip]

Only if you need to respin this patch series, I would rename
_flow_control_autoneg() to bcmgenet_flow_control_autoneg() or something
shorter that still contains bcmgenet_ as a prefix for consistency.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
