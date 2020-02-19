Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7112B164E00
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgBSSwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:52:51 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36003 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSSwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:52:51 -0500
Received: by mail-ed1-f67.google.com with SMTP id j17so30446370edp.3
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 10:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FlXr7wV2KafqGdOhbKCt9JoLv9IROATQnWc8klLsKRk=;
        b=LBbQan9aJkV35o9ORpagGuodQhjd500vLmx3FITffV35yWBxOPcZQtqRkzlPC9ZYhf
         MsvKKmbw2PW3MJ3KvjvhG2L5yqb3ORIVECSahAK+/llLVNOOi/91vFGzYOAaXXK1STKh
         I1ezM8DgDLdWISPXY+lvns8l2ruwUOg4wm5bEA4k9iVlFkHg5C6ai8a9cnjU2oPjZ6hz
         b4DmK16Rjd8rugzKgGSrnKhj7LPvQgEbY6qfZG7I2irHla5mZ20EKYT/js5C/+q10yAO
         AAAOC8RcpOfWANwGE9BOfzsVWMeRI3rDMpFMWxxS/I0ly5AM/469+Jn9gEtv0swKi4xm
         8nlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FlXr7wV2KafqGdOhbKCt9JoLv9IROATQnWc8klLsKRk=;
        b=Q4Sqa3Ya7deDW6IxIzf6sBWrmAs8SA6lUcRQenUwy8k7pMNih/3rXWh5kXNxICQU6s
         ZwufqRqbUdwMkHDe+St7+MuINd3QTwR/5YOqD0GbUn/EouX+/IxSUbBa1FEnFVJFyNQ3
         5PRo+tZZVW7PLT9Vodpp23u535JIm3U7ZXoiKruU4prmn9KCayCW4REwZvwGGxAqyPDu
         C+Re4e7K3k/EUEgIidb1bktQmHa3R5ebl9ItZvOiDp+kG0FltRU8l7ygN8okHB+AJTy4
         0aNH1hnkTy49yKQWpVaiEgnmuCXta4IcVgQdjq3PfMWmc0g204V2p/i7xa3939jesuaz
         ipbg==
X-Gm-Message-State: APjAAAWwOldPNpMyQ7mBNehYsn8WxYryntjQMy01hdxNypso03kPlo0K
        EtM0Pw4tWEGI/pFtFeJa/A6KkSkYGFk+rd7BE1Q=
X-Google-Smtp-Source: APXvYqxdprGkZyTnzzKor9cHp5CNYQA6qWLtQhFnBaCy5XRWxQIj5oZEY72fjyHJSjibdTxwF9Cd9k3g4N8kaqCuM74=
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr26420111ejj.6.1582138370111;
 Wed, 19 Feb 2020 10:52:50 -0800 (PST)
MIME-Version: 1.0
References: <20200218114515.GL18808@shell.armlinux.org.uk> <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
In-Reply-To: <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 19 Feb 2020 20:52:39 +0200
Message-ID: <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 at 02:02, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Why not just revert 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa:
> Don't add vlans when vlan filtering is disabled")? If a driver wants to
> veto the programming of VLANs while it has ports enslaved to a bridge
> that does not have VLAN filtering, it should have enough information to
> not do that operation.
> --
> Florian

It would be worth mentioning that for sja1105 and hypothetical other
users of DSA_TAG_PROTO_8021Q, DSA doing that automatically was
helpful. VLAN manipulations are still being done from tag_8021q.c for
the purpose of DSA tagging, but the fact that the VLAN EtherType is
not 0x8100 means that from the perspective of real VLAN traffic, the
switch is VLAN unaware. DSA was the easiest place to disseminate
between VLAN requests of its own and VLAN requests coming from
switchdev.
Without that logic in DSA, a vlan-unaware bridge would be able to
destroy the configuration done for source port decoding.
Just saying - with enough logic in .port_vlan_prepare, I should still
be able to accept only what's whitelisted to work for tagging, and
then it won't matter who issued that VLAN command.

Thanks,
-Vladimir
