Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE285ADB8
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 01:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfF2XXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 19:23:06 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:47040 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfF2XXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 19:23:05 -0400
Received: by mail-ed1-f67.google.com with SMTP id d4so16907946edr.13
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 16:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:reply-to:to:cc:references:openpgp:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iBAUyxSqwFZQUr949m7w4lO5jsC0EQBRbQjA+G8AhOA=;
        b=VEu7fjuzucR781aHbss3poSEX3AqOrXLj9Do/8Wu72ItQk9UbRLGdvFG4DqIOwwUaQ
         x/tzPLZ41I+TBRX5PdJ8ibIPEVh0rJyE1mtLo6m5QtRQGrSxKNJOmV1ef/cnkEWO3Gs1
         tC+P8Scl2OeYUL7yCZDj9F/jfjdvbgC2rIIPf8CxhoYfkleSEB6UsPb0TyqAIgl7+yll
         SMx9jAEOZmNuuLZhs17D+AwOGrNayLONeSlP/rqAm7/XT04wD45agrlgZi/H33GFvZkF
         bOXNnkd4rnLcKlgLE+hv8pGZJ4FVKJ0LJTBgd1nYOuXcUHl8BzB+Pgce2MALTFrH5PgE
         w3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:openpgp:autocrypt
         :subject:message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=iBAUyxSqwFZQUr949m7w4lO5jsC0EQBRbQjA+G8AhOA=;
        b=nAvQOc37wqQlABx4cEhJRVTyNFbqGxwx544MgGyeUjDqfLEQhgt2zpS4DtUxX7vaC1
         q8ujX7bbssnzOv09It9yOC5bo8SkQZLbqkCcnF8s4upPCeTmJCU6IuWK+3Izsf6SH29E
         ZDq1lcPlRqAZ8qM9AYgXpQxgCKQr+MPBEJwPlwTYr0T4Fd628+ota8NtR7igh7o3rCCP
         LUQL9GFUTVVZM+e8U10OQz28DZaeJx/r+V07/rBoqCpkdE5zKwI9RUPVLX/H6YdMTOd9
         leHL2ExsgFLfxS+8qAfZ5XC/zSwiL1OtGrR4X4O7kjCuy8aLJ9NSzBPHUKYZEUEnv3TE
         xHEA==
X-Gm-Message-State: APjAAAUK5Ny7EAZ7qMt8qCUSvlevjfeoJsPzIYg/uCda2VlnMUonyHXK
        ghFnMzvuRw5EWM7CJnGwZxCf0ju1Gpk=
X-Google-Smtp-Source: APXvYqywMlWMkvPlerRH5xW5ucc1xT2WSF1DGHtKs/dkgPvoZDjwCZjmRVWaB6CLc+rapoZ2S3JBnw==
X-Received: by 2002:a17:906:2557:: with SMTP id j23mr15596013ejb.228.1561850583303;
        Sat, 29 Jun 2019 16:23:03 -0700 (PDT)
Received: from [192.168.84.205] ([134.101.180.17])
        by smtp.gmail.com with ESMTPSA id d44sm2081338eda.75.2019.06.29.16.23.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 29 Jun 2019 16:23:02 -0700 (PDT)
From:   vtolkm@googlemail.com
X-Google-Original-From: vtolkm@gmail.com
Reply-To: vtolkm@gmail.com
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <e5252bf0-f9c1-3e40-aebd-8c091dbb3e64@gmail.com>
 <20190629224927.GA26554@lunn.ch>
 <6226b473-b232-e1d3-40e9-18d118dd82c4@gmail.com>
 <20190629231119.GC26554@lunn.ch>
Openpgp: id=640E6954D6F535488EDDC809729CFF47A416598B
Autocrypt: addr=vtolkm@gmail.com; prefer-encrypt=mutual; keydata=
 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
Subject: Re: loss of connectivity after enabling vlan_filtering
Message-ID: <53bd8ffc-1c0a-334d-67d5-3a74b76670e8@gmail.com>
Date:   Sun, 30 Jun 2019 01:23:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190629231119.GC26554@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/06/2019 01:11, Andrew Lunn wrote:
> On Sun, Jun 30, 2019 at 01:04:50AM +0200, vtolkm@googlemail.com wrote:
>> On 30/06/2019 00:49, Andrew Lunn wrote:
>>> On Sun, Jun 30, 2019 at 12:01:38AM +0200, vtolkm@googlemail.com wrote=
:
>>>> * DSA MV88E6060
>>>> * iproute2 v.5.0.0-2.0
>>>> * OpenWRT 19.07 with kernel 4.14.131 armv7l
>>> The mv88e6060 driver is very simple. It has no support for VLANs. It
>>> does not even have support for offloading bridging between ports to
>>> the switch.
>>>
>>> The data sheet for this device is open. So if you want to hack on the=

>>> driver, you could do.
>>>
>>> 	Andrew
>> Are you sure? That is a bit confusing after reading
>> https://lore.kernel.org/patchwork/patch/575746/
> Quoting that patch:
>
> 	This commit implements the switchdev operations to add, delete
> 	and dump VLANs for the Marvell 88E6352 and compatible switch
> 	chips.
>
> Vivien added support for the 6352. That uses the mv88e6xxx driver, not
> the mv88e6060. And by compatible switches, he meant those in the 6352
> family, so 6172 6176 6240 6352 and probably the 6171 6175 6350 6351.
>
> 	Andrew

A simple soul might infer that mv88e6xxx includes MV88E6060, at least
that happened to me apparently (being said simpleton).
That may as it be, and pardon my continued ignorance, how is it
explained then that a command as

# bridge v a dev {bridge} self vid {n} untagged pvid

reflects in

# bridge v s
a/o
# bridge mo

?

If the commands are not implemented one would expect them to fail in the
first place or not reflecting a change at all?




