Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046C15E6E64
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiIVV2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIVV2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:28:08 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB8310F736
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:28:07 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id g4so7804807qvo.3
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=KAgCOek1CxTn0NTpIDOxGIhFr/rKgAxoNpMer9fCWoM=;
        b=I+tIxm5yWge9oBYWltiGYuf7SQRCfPf2Ze2pI7CBycuDwUnWnjI2c7SofKB5a+kUZw
         OGoCRS/pLeNS4VMxbSB57EgtgzMNgrxv9I5hh/UFsepW5u1gtQ7D89rw1/8uhmSZg9+4
         qRrlZ8C8oBUvVzpTfUXoRynmbmBDpDQUc1vS7ivOKbqKxAJbeu71ugAjOX2nls1mk/Sv
         5upyhwUaXp1mKmDn0LyAJq3+i71sva1BIu4u9J8Rtk+4w3rJx9PWyC+pwgMyboJWSra5
         rOAilI18E9Lvqi9AlU5fs6cffWIp8J/lCy0SbIha07mJLnU9y0k2rqv1s+/cK79JzTQa
         wXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KAgCOek1CxTn0NTpIDOxGIhFr/rKgAxoNpMer9fCWoM=;
        b=R7scsRrKjZ1D/z+REs7gDxcR28d9bft7SZzURFNwuGmnvtY7Ya16TrZp3RWhThw0pE
         Kfy6ldKUzHN0DFJMG3REQn0wZDB0/RGBK2UdBJVgdvTUyTapib9lJIKVaGvN4IkSFmj2
         Au13DdUD/7c8/EaALmokUSMvz8LYxqAOLmBYcZf89EslMfjrFOkPEj4Un3k1D8Dbdu8O
         cRdtDmdWG6dYop0FGZmw+G+Zd2AwHVsz2ys6Vb3Lp/NZzgasxOvNQxl/0sQHRnIWLgvB
         JqDNWI2Y27I0z7fhM1ho1Nk+d0WrsMfuCn2Hl8/fDD4MwllVjw4DojOjlQZGHsDz41Xo
         hbOw==
X-Gm-Message-State: ACrzQf0bn2dVpgw/n3v8PFxBs6XVzQpcb7CoGF4nUvU1HKKuki+X+WGW
        yOR04OWMzdqGaLteHVrk+wo=
X-Google-Smtp-Source: AMsMyM6g5uSIZMNEZACN9rao3ajxTOttOozB+uYtNQeBkqVpSwwTCmR9YWRegwbEI999OAAKfsMkKQ==
X-Received: by 2002:a0c:8d85:0:b0:497:8b1:d372 with SMTP id t5-20020a0c8d85000000b0049708b1d372mr4431592qvb.68.1663882086272;
        Thu, 22 Sep 2022 14:28:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y7-20020a05620a44c700b006bbc09af9f5sm4866793qkp.101.2022.09.22.14.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 14:28:05 -0700 (PDT)
Message-ID: <d88376a7-3e12-fcca-a61e-58747622328d@gmail.com>
Date:   Thu, 22 Sep 2022 14:28:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921154107.61399763@hermes.local> <Yyu6w8Ovq2/aqzBc@lunn.ch>
 <20220922062405.15837cfe@kernel.org> <20220922180051.qo6swrvz2gqwgtlp@skbuf>
 <20220922123027.74abaaa9@kernel.org> <20220922201319.5b6clcxthiqqnt7j@skbuf>
 <20220922132816.64e057e7@hermes.local>
 <20220922203658.6y2busc4p3mjfp4f@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220922203658.6y2busc4p3mjfp4f@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/22 13:36, Vladimir Oltean wrote:
> On Thu, Sep 22, 2022 at 01:28:16PM -0700, Stephen Hemminger wrote:
>> Not sure where choice of "via" came from.  Other network os's use "next-hop"
>> or just skip having a keyword.
> 
> Jakub was saying:
> 
> $ ip link set dev swp0 type dsa via eth0
> 
> meaning: "make the locally terminated traffic of swp0 go via (through) eth0".
> No direct relationship with IP nexthops.
> 
> It avoids saying that eth0 is a DSA master.

That part was clear (at least to me). I read Stephen's questions as how 
did we come up with the keyword "via" to designated gateways in the 
first place when other network operating systems use "next-hop".

I, too, think of "via" as a printed circuit board term, so using 
"conduit" seems more in line with the vocabulary I could retain my 
muscle memory with.
-- 
Florian
