Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D406276602
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgIXBrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXBrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:47:04 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2463AC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:47:19 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id m13so1657889otl.9
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q+VwV4ucp8F5pqihn4JE+6ZhmH8uOE5H2MuEefawB+4=;
        b=YLtPrWJfAiSmfFtcn6JmaFQvt36t/6BhrPWe6CIVei25HKkvWTyAQprZg07jriswvx
         pzbycZYhfLhr1CeVbXEkzKUVBJlnf3W7BkkbSLfthcIWnQGVPOAseKQ68R/rz0V9QAYE
         UkI5+mgLZyCKo1sfZLKVL4PksHKmYSdvpTOSDkdpjwUZRF36lJxa8vNJPpLNUr8i9wCW
         c298pmjCAQablYimYVvfG5WlMILFtp1eIhssYhEnigislc3vkUHhyBonLZecUeRQMOtD
         rtAva38i2cnArX07kW1LvU9PUAkKf81yp0GbxqhwXXej4C3SOq8ZB9qmXgu+3hSXFlg6
         hPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q+VwV4ucp8F5pqihn4JE+6ZhmH8uOE5H2MuEefawB+4=;
        b=hmMF5fC+IS4o4UDSWa+T45d/95Ijsn1airab5Jmbl2WAXXY2nLjNNz75Y/24e2iSbn
         QQ7pQmHb/4eM7WtzQ+B4Fdv3rWFBbhhmRh1j6n+etdlsQFeeZViIdi8uXlmhcYusiKMn
         Z6KuKNlXwbfZXCZY44CVU5cQX+iKPiQWgJettWQafeVSOE2I4cSWr6H2+9eQvyYr20Y2
         t9dacNH+rPRzEF1aDieIEYDLADxQoTv/3iallM7dFnAaZvubW1kIiSolbByoD119cKg2
         a6lU8S3lE3XpqWDsfAFUP+Xt+tthsTJIupH1CtSnlqwe3ghN8HsM9ebRMqEfSmf1LNo9
         fOFg==
X-Gm-Message-State: AOAM532TacyCiSdna01t9mKtjRkARi2h3U3JFlIre/FIetRUW4Bnp1gr
        8Gj7aIypJDT1LP4ku1KqeOwOImMgkn2TtA==
X-Google-Smtp-Source: ABdhPJyTAkE2ZIq0EraiNuPDJwarRc+XkCfCEUt7ba7f9TPYVHiiE6tNMI+qnE3C9jahz/sqCazj+A==
X-Received: by 2002:a9d:a24:: with SMTP id 33mr1463645otg.305.1600912037906;
        Wed, 23 Sep 2020 18:47:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:b155:90bc:6427:b416])
        by smtp.googlemail.com with ESMTPSA id p8sm433822oot.29.2020.09.23.18.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 18:47:17 -0700 (PDT)
Subject: Re: ip rule iif oif and vrf
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20200922131122.GB1601@ICIPI.localdomain>
 <2bea9311-e6b6-91ea-574a-4aa7838d53ea@gmail.com>
 <20200923235002.GA25818@ICIPI.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ccba2d59-58ad-40ca-0a09-b55c90e9145e@gmail.com>
Date:   Wed, 23 Sep 2020 19:47:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923235002.GA25818@ICIPI.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 5:50 PM, Stephen Suryaputra wrote:
> 
> I have a reproducer using namespaces attached in this email (gre_setup.sh).

Thanks for the script. Very helpful.

Interesting setup.


# +-------+     +----------+   +----------+   +-------+
# | h0    |     |    r0    |   |    r1    |   |    h1 |
# |    v00+-----+v00    v01+---+v10    v11+---+v11    |
# |       |     |          |   |          |   |       |
# +-------+     +----------+   +----------+   +-------+
#                  |    <===gre===>    |
#                  | gre01       gre10 |
#                  |                   |
#          vrf_r0t | vrf_r0c   vrf_r1c | vrf_r1t
#         (tenant)        (core)         (tenant)
# h0_v00 10.0.0.2/24     r0_v00 10.0.0.1/24
# r0_v01 1.1.1.1/24      r1_v10 1.1.1.2/24
# h1_v11 11.0.0.2/24     r1_v11 11.0.0.1/24
# gre01 2.2.2.1/30       gre10 2.2.2.2/30


You have route leaking for the jump from tenant to core and the gre
devices in the core VRF. For the jump from core to tenant, you are
trying to use fib rules based on gre device index.

Yea, that is not going to work since the skb->dev is set to the VRF
device and it is not a simple change to remove that swap.

If I remove the fib rules and add VRF route leaking from core to tenant
it works. Why is that not an option? Overlapping tenant addresses?

One thought to get around it is adding support for a new FIB rule type
-- say l3mdev_port. That rule can look at the real ingress device which
is saved in the skb->cb as IPCB(skb)->iif.
