Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E5839C58
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 12:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfFHKPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 06:15:31 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43481 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfFHKPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 06:15:31 -0400
Received: by mail-ed1-f66.google.com with SMTP id w33so6291800edb.10
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 03:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FhPigM2l4/XGwCGH2BHacJ2gqOXP2L1dTAacIzTqJ1U=;
        b=tfwWqiWBVq66DkCRwGVxsVWhwZFeYaRm5WThMGjECKtXY9fXT1POEIVhkRn0VL0ic6
         XSIeinGm5SFQZvniOPv3HjjFJUX45ESL65RYlTxviFCwMGfFFtyTTBgdEi8MiKgCbLsI
         lOkfBs1RgfaufqpVuV/ULvd4MzIDRsZKbEZHcx70N7tL8xX4stG7rilsOzgTZxE4KGOj
         LJTUqiexF88Ern2lGJrNSp2tVIqW0nVNe9N9u5C+qmHSoz/mUp/4we05SwowCdNIMkGJ
         3gwEKa25Sg/SUGnBy87JbCdyAA8OhV0QmoYb0uez6LK3eWh0gcC+aUQWaKpM2tzWkcAR
         aUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FhPigM2l4/XGwCGH2BHacJ2gqOXP2L1dTAacIzTqJ1U=;
        b=uPcruX7sHcHskhngFrUdajHP9L3qpTeDKrsPctwpFVj+9wDhDGUWoQhuGnRZKAwdo0
         DcdUqwP39U1uYE3c5cVmZS8QVTwXvILshwbIjAkTgvlm+BdhXhiRosOxfJmFbhXGY/7A
         KPkN29MTshm5lNgzdQ/ZhtemawgY7W4pKUluobk1mr+7ahNGBLt4AuL9i0iraaDSVopG
         kgi39GTJGYrvcNq3Ic0/TfRpYIzdiMiIdFyJrhRKNtH2R9rweAsmAQ57APeYR1qrqprg
         OS9t8iDr4YeoR5Tt/MGc2w1hqb6/sSHrGWiT0JSW+09FeufbBkPBZJm8YyaDGHb+0lio
         Bfow==
X-Gm-Message-State: APjAAAVTH7QqaZjTk5xe1IeGDiKHjmZR9Ru4VEkJRMLa/thh0j+fGfWr
        uHSyrPY0VSVUOjrSrv7c/GQ=
X-Google-Smtp-Source: APXvYqzoi9XulrNxUS7tLHFQktO/HALO4okeQ1pzHyWRcuFO7ls1Io2gBqBUxudm/ROt6L08JKeGFQ==
X-Received: by 2002:a50:9846:: with SMTP id h6mr7572312edb.263.1559988929773;
        Sat, 08 Jun 2019 03:15:29 -0700 (PDT)
Received: from ?IPv6:2a02:8084:601c:ef00:991d:267c:9ed8:7bbb? ([2a02:8084:601c:ef00:991d:267c:9ed8:7bbb])
        by smtp.gmail.com with ESMTPSA id ay25sm833078ejb.26.2019.06.08.03.15.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 03:15:29 -0700 (PDT)
Subject: Re: [RFC v2 PATCH 3/5] ipv6: Paramterize TLV parsing
To:     Tom Herbert <tom@herbertland.com>, davem@davemloft.net,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
 <1559933708-13947-4-git-send-email-tom@quantonium.net>
From:   David Lebrun <dav.lebrun@gmail.com>
Message-ID: <6d286041-ea1f-2b1c-35a8-5d530d168a13@gmail.com>
Date:   Sat, 8 Jun 2019 11:15:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559933708-13947-4-git-send-email-tom@quantonium.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 19:55, Tom Herbert wrote:
> +			  bool (*unknown_opt)(struct sk_buff *skb, int optoff,
> +					      bool disallow_unknowns))

What about changing this boolean argument to 'allow_unknowns' (here, in 
ip6_tlvopt_unknown() and ip6_parse_tlv()) to avoid using negative names ?
