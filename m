Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B092796994
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbfHTTkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:40:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37961 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTTkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:40:06 -0400
Received: by mail-pg1-f193.google.com with SMTP id e11so3798568pga.5
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 12:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0d1Wao2eMsUFCeZCT/Y15FbMRfgbIu5b4xutg3vxBVE=;
        b=D9iPJgcl9jEKbBkH5rOvFa5c8hDJU81ClNdpUmPLpCf+JTjact+bJC3HTbqu7RR6+M
         YEZIRKT3FUOTl1TDh8YN21mM5Pd1ycc0Qfhkm7u1pKQ5dlDkzrOWSym3SdwMUwKTfSpE
         WcUW0JwZaZqVTl16bvTYRQjp+uqpxFFHOgrBQyUmWI2JU2gDlzA54C0DStJGHivPFlfl
         oBjafjRpkAqRqC+wPYG3Mvt1SytBXpGq/cNpGWwTIokR8BVUuZ4Gv86rKhdwJmRDMo22
         hpGn+2wZ2S4mVqXvd8bMc6BdEJ3TZXuKQEd2/eydiD7MQsoRz1+rnh8MYaosPvPEhEpW
         Jq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0d1Wao2eMsUFCeZCT/Y15FbMRfgbIu5b4xutg3vxBVE=;
        b=lvWwpRkU5aIMbXAqrTgk/4sXJeKMEaCw1ttVltzTNJ2mNmbOkJORD/82QcGawTdlkw
         6o4mxntgQ0/FL5bko8XPs81SVvHxqBTKyoM9R6aaQAOJz6yAuAEO/YuJ1MYrSbd6ggt8
         7GfE8juLA0Xc6DlXYRbUchzfjBRZHFvCbVwdBmQqWVS/oa8wsJWyZorxBYn6HYmdRjAI
         gYjxkmcwNjDclqldPwFhNElJy9PkwOQUZgJ7BPOTYklxVdHHEGCkKnSfG5G2cY4HAueH
         piRiUdnZSLRSf1EZUZ6AT81qe0MvSjj/5BuNtZOzpoTdYN2K+55Ql5PJKSui9jR+101e
         o7+Q==
X-Gm-Message-State: APjAAAXcHaxJ4o5Pky48ytncO7tPbK/cxQ7CWcVWZdOik5dnc4YimByX
        MXsQZSm4qQpukxuW1TpSTD3obQi/
X-Google-Smtp-Source: APXvYqwksgIIYFq8jR4dAJqiwPRnt96VT71/RHe28dwTNHsBcy1edCWUGhF0+O9rt9P1FtWM1UxQ+g==
X-Received: by 2002:aa7:85d6:: with SMTP id z22mr30701342pfn.262.1566330005057;
        Tue, 20 Aug 2019 12:40:05 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u7sm20978890pfm.96.2019.08.20.12.40.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 12:40:04 -0700 (PDT)
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain>
 <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
 <20190820135213.GB11752@t480s.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
Date:   Tue, 20 Aug 2019 12:40:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820135213.GB11752@t480s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 10:52 AM, Vivien Didelot wrote:
> Hi Vladimir,
> 
> On Tue, 20 Aug 2019 12:54:44 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
>> I can agree that this isn't one of my brightest moments. But at least
>> we get to see Cunningham's law in action :)
>> When dsa_8021q is cleaning up the switch's VLAN table for the bridge
>> to use it, it is good to really clean it up, i.e. not leave any VLAN
>> installed on the upstream ports.
>> But I think this is just an academical concern at this point. In
>> vlan_filtering mode, the CPU port will accept VLAN frames with the
>> dsa_8021q ID's, but they will eventually get dropped due to no
>> destination. The real breaker is the pvid change. If something like
>> patch 4/6 gets accepted I will drop this one.
> 
> I wish Ward had mentioned to submit such academical concern as RFC :)
> 
> Please submit smaller series, targeting a single functional problem each,
> with clear and detailed messages.

Also, I don't think this change set is useful per-se, if we take care of
removing VLANs on user facing ports, and VLAN filtering is turned on,
then a frame ingressing an user port with a VLAN that is not part of the
VLAN table/entries should simply be discarded on ingress, or on egress
to the CPU port (depending on where the switch performs VID checking),
so the CPU port cannot possibly receive such a frame, and so removing it
from the CPU port is correct from a reference counting perspective, but
useless in practice. Thoughts?
-- 
Florian
