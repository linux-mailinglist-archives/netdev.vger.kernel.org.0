Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A786C2711C4
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgITCdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:33:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E31C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:33:34 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so6100239pfi.4
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=umqjKmzBql3FUZl4wYfJJJuHKaRl5oo6uit6AgDEXyE=;
        b=BP2DCCnaLZi3jJqg3b2EAGs28SaYqtecgFNe+3mzvT5rUS5d2Rkd6Dlrn0bWBHTQ24
         Dy2h26LfsULMrki33AcTJt5T+lDVKTXWsGCQS5vbxIPyf5TTVpkWixP2067dzdMu6zt2
         gE2KVGsEtIMkbkXc2k7+g5F7jwblaYV3Zcvqalfx/VOQUst+cIu72085DIVd+b/za2me
         Qsrxh754rjmr42YEfFWqWICQR7E18aJkpC3RQKfrrnJkfOvYksW/YZDWZQZR6tpMFicG
         zs5g5Y11W6xyKzoEb5kiRpjsaNAenpZbi29q+loQS9qBRgd3gHhwkMEDZnezFh+dtXLy
         EOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=umqjKmzBql3FUZl4wYfJJJuHKaRl5oo6uit6AgDEXyE=;
        b=syB/Vi6MnA5ISSPq3lEGmVwePPbExuSK8m8c5nkR94XSQvPxZJpi28j57Pbv3oAGI6
         7/0bugaLuut6G5L/xGP99uDlrp98CugZA+mC2QVDFsB0a7Ko8aH5WPXaZE+dbCEtQFsQ
         8AuHRx0vWhSp3zd/l6esA3dGACsK6X6BF5cxHMdUNSdL6RosqDtD4+xbiQjJPEH8fHvM
         cRuKVQfGiRx2L/fT0NeI95/+dtJ7FJs5O7g5ML2EJt1XirMQ5/TOLgSccJ56/GKZTV4l
         uyu8c/av4tbPF1FFrYXDGW0uE9Q4u2d1U0tahlTuEGNfKdoQEymRecioUHb0Uj2EIT6n
         5Z6g==
X-Gm-Message-State: AOAM5300cmIAsi2GMMsIyVGWScHshWl/7Ay9PUV7y6jsc3ax4t+7GeUy
        4j36jPO7ldptMKThcVAABa8=
X-Google-Smtp-Source: ABdhPJzkrI0PAD5wYpQq+4I2wRcpo3YejVy3c45MhuuopLqPytAH9rZo2pMF7CQY3esqRP/Ttp9/Rw==
X-Received: by 2002:a63:cd0b:: with SMTP id i11mr32315465pgg.306.1600569214371;
        Sat, 19 Sep 2020 19:33:34 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r6sm8223862pfq.11.2020.09.19.19.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:33:33 -0700 (PDT)
Subject: Re: [RFC PATCH 2/9] net: dsa: rename dsa_slave_upper_vlan_check to
 something more suggestive
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bb1472f7-4fe9-17a5-59c5-f77a07ff68b5@gmail.com>
Date:   Sat, 19 Sep 2020 19:33:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> We'll be adding a new check in the PRECHANGEUPPER notifier, where we'll
> need to check some VLAN uppers. It is hard to do that when there is
> already a function named dsa_slave_upper_vlan_check. So rename this one.
> 
> Not to mention that this function probably shouldn't have started with
> "dsa_slave_" in the first place, since the struct net_device argument
> isn't a DSA slave, but an 8021q upper of one.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
