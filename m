Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8191414C
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfEEREo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:04:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34869 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEREn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:04:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id t87so4874727pfa.2
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zg4lSdpF05TnbuqsOF1RdwZMbOEDqQngl0hGBSXpADQ=;
        b=Wr16h7EZNPdVTRs4D59UcSzc3Yf4kzPjVoS/7oVw+Vx8UmJcdvy1943Myhhn1FJrcG
         fTUpYWNQ9fSnYcFBzGk7Vjo8VpKX+tEcb9lZZBDM244kZdiPe6orpRE8jKIfQ3O9wIqZ
         OgD1ReY1Cxyn751t1mVxN/9G5dDbnetIXaJhgqJy3Wmm5vpcaRz85FjeDkYCN2f+177q
         oCyjW4zUAMbvjPjyzgRCQk+Hg5zDhV+s1YRdvVaukmwqry1QQpJdrHs+pEvsi4mWIPxF
         tBMnUpJYNvsxwDDVWOoo9wzC8a1CzqzCw5i4Lc4w04hjNe1VVxS55k2a36ww0gD1JArN
         QvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zg4lSdpF05TnbuqsOF1RdwZMbOEDqQngl0hGBSXpADQ=;
        b=GlJ3tuMSG0JU1BCLCqLZCHjAxKDSi3z2a2DMRSS6K6Llw2IVLSVlAWlIBEjR6y8tre
         iXsjsvsAZ/+AWVJJYKzcGV2d8OPveH8duapmFnUd4xepoxCDDQtnFXayPmAnXcqgrynw
         kv6jrn1MsqQbNF0Fq8qzuSDXjTwi1ldQwjA/5FRr/WJjEoaIInNlbLmIC174OyDzPyYZ
         WAFz5Us1TCjsORMxtKurW/3aWVG2b92paDlCVhmnaiQhLpsQsMXhdqCbrHJu0JVcBrtP
         r+emM0hr3I1+7TxNj8AdNsVtBFidDCm2vTD/GwMSTO9OziQI5bvc0tNzBj0GqLffRbHd
         b0QQ==
X-Gm-Message-State: APjAAAWzjogJ4MrW2bDGZH2RkgaLdeWyQGc/W0KcZP6oHXAb3UC424zu
        6yPtUbp7B1akkbIckFWaP8Kf2q3c
X-Google-Smtp-Source: APXvYqz/aZtRKW6Up4csm5g73/aW59z1R3GeYzh+0xtAHkBgQR8puyzxx0plw8AEstNzV8q9fDKj8g==
X-Received: by 2002:a62:bd03:: with SMTP id a3mr26836021pff.81.1557075882708;
        Sun, 05 May 2019 10:04:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id a18sm10350560pff.6.2019.05.05.10.04.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:04:41 -0700 (PDT)
Subject: Re: [PATCH net-next v3 10/10] Documentation: net: dsa: sja1105: Add
 info about supported traffic modes
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190505101929.17056-1-olteanv@gmail.com>
 <20190505101929.17056-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e9fecad2-1fcd-954d-65fa-47f0a3ce6821@gmail.com>
Date:   Sun, 5 May 2019 10:04:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505101929.17056-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 3:19 AM, Vladimir Oltean wrote:
> This adds a table which illustrates what combinations of management /
> regular traffic work depending on the state the switch ports are in.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

I have finally put my brain on and understood what you meant with the
vlan_filtering=1 case, which is quite similar, if not identical to what
happens with DSA_TAG_PROTO_NONE where DSA slave network devices are
simply conduit for offloading bridge operations and the data path
continues to be on the DSA master device.
-- 
Florian
