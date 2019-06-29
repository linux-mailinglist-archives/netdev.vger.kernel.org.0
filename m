Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCE35ADAC
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 01:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfF2XEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 19:04:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45891 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfF2XEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 19:04:53 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so9829532wre.12
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 16:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:reply-to:subject:cc:references:to:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JQlWdrHMuMumm4PKJxXoY+iumXD5P2618q5S/Z0Z7U0=;
        b=mQAORRWB1eHD6zI7IC0ac92gcSnUmYkehCqPC6Kcdd0pu0KAws7f8wUM6wiDEei5Mz
         Nsuxp4a4Xjg4dLiU+V/YDI7TtfOGCncOsd7EUigiSwGaeqJFAE9+nJhxMOnjgTtJhKN7
         rUjseGCeDMGPdpmtBwg+InR99vv+rPKQ3ssZnDRuERH3IixyTZzPEXsmE7WIipzFZc7A
         DhpbYbmsme8yq0ntn3p+kkl7kDiASOpWyw+AV4VvNfsrudm/Zl0kLwgY3nonEU6fCK/q
         50NZO8+DWr9jkTVgq76lrMt6cDuTZZ56CzD9YZuuKz2rmP9sRbrDQkhd9VKVhCp954q+
         LkWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:cc:references:to:openpgp
         :autocrypt:message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=JQlWdrHMuMumm4PKJxXoY+iumXD5P2618q5S/Z0Z7U0=;
        b=TyiOGlXKqmjOiY2UPt5/m/flrX+HNKgjV7GVxfdeHi/PlqeIfBL97TdbGSx6jJc24u
         4P12LdpcgXN94KLeKWiyldTgJR3jGUGK3GTWqG/9/YzjaaB5P8NRlkpbsi+RlIc+ZS6T
         rbn8kt+zaH9YT270ovvwxJPvyxsFpvKazRO0DICxDIOM0aYXP/4+6wzdKCWj6alBpJT8
         bvjFsgwBsSMXdnFVT4wDXlP0NnuVIBhfkTTT4nTkDvxyte5akiF8tcso6sapI8HXhvlv
         7Mnx/UZeE2lv0wR30zKSDmdvWkYcgDKkVoUEhmGltP6kC5XigeJEAX5jYX9wZaV7FpX3
         VqQA==
X-Gm-Message-State: APjAAAVnm0nmrgUzl+qcAtJqcnC8eUykpfUb5BxaSKRExj0dFeX5UcG3
        nb4I+rEr3jq6pzkmvX2fTl+/VT3AgKo=
X-Google-Smtp-Source: APXvYqzpjxo2/hrES5RPvd2F+1m/qLEyj62LXLfLs2vYxnz1TqRUbvd0bGklogGL/90O0S8Lanuu6Q==
X-Received: by 2002:adf:9267:: with SMTP id 94mr8187792wrj.109.1561849490215;
        Sat, 29 Jun 2019 16:04:50 -0700 (PDT)
Received: from [192.168.84.205] ([134.101.180.17])
        by smtp.gmail.com with ESMTPSA id v65sm6738317wme.31.2019.06.29.16.04.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 29 Jun 2019 16:04:49 -0700 (PDT)
From:   vtolkm@googlemail.com
X-Google-Original-From: vtolkm@gmail.com
Reply-To: vtolkm@gmail.com
Subject: Re: loss of connectivity after enabling vlan_filtering
Cc:     Andrew Lunn <andrew@lunn.ch>
References: <e5252bf0-f9c1-3e40-aebd-8c091dbb3e64@gmail.com>
 <20190629224927.GA26554@lunn.ch>
To:     netdev@vger.kernel.org
Openpgp: id=640E6954D6F535488EDDC809729CFF47A416598B
Autocrypt: addr=vtolkm@gmail.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <6226b473-b232-e1d3-40e9-18d118dd82c4@gmail.com>
Date:   Sun, 30 Jun 2019 01:04:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190629224927.GA26554@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/06/2019 00:49, Andrew Lunn wrote:
> On Sun, Jun 30, 2019 at 12:01:38AM +0200, vtolkm@googlemail.com wrote:
>> * DSA MV88E6060
>> * iproute2 v.5.0.0-2.0
>> * OpenWRT 19.07 with kernel 4.14.131 armv7l
> The mv88e6060 driver is very simple. It has no support for VLANs. It
> does not even have support for offloading bridging between ports to
> the switch.
>
> The data sheet for this device is open. So if you want to hack on the
> driver, you could do.
>
> 	Andrew

Are you sure? That is a bit confusing after reading
https://lore.kernel.org/patchwork/patch/575746/
