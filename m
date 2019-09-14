Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158B0B297C
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 05:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390863AbfINDbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 23:31:24 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:38629 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390570AbfINDbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 23:31:24 -0400
Received: by mail-ot1-f54.google.com with SMTP id h17so27423263otn.5
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 20:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lBsAnRKcYy8BTJHC5GATAkzX4Y3hoPiMP2geDV+eFmk=;
        b=g80nVFmGQwMkcel4zmuA9ByA0cVdruDy+oCN6FEjQx/2i0tf44fgX27nz/cPX6ufWP
         hM6wWaLWoGZytHpqwMlm3bQt9QJQUeIOcbFMiFiYNTmcSNBISIA4RPmKKb2+Jfe4mga9
         xFrTBoNWw2mDKVpSthLtTtyQdenqWCDk1VpB2sd5h7ngP5jVZNce2lsYNAODTJmlEMus
         06nEN11pBRYEpbUsr9ZlZytG4HaJ4H03cQBAkWiVtS9TtOTygFY8mOflThpb7qdFqlQp
         u4HUzTvKtOnCCdQ5NZU2CKJlA3nVKw+W/zm6ivzEHg076VCU5Y2pVwlb6ZKiGOnKoezi
         rvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lBsAnRKcYy8BTJHC5GATAkzX4Y3hoPiMP2geDV+eFmk=;
        b=QLvFl1LKxrRjBrwTQOKlrW7+a+NmuyfB4HnwGei0OlFFnd5Qf6hYbgfNromwIIKlrY
         APE0IiW7ibhEQu5JBT/+/VMynpyMaEZJYp6fyhXKv/PMQnxDfqPlICl7cL8Lf3iWzoAR
         vuoABNlWbfFnsld17oAS4Y+fS4EhJnK+MfJ0Am05zy/zZJ4LTJwpOC1CHwyW0H+3we2B
         pLFi23FUAMNK8cxBsUNPeYgKrjQoUwPNJdT7dLxeVrgdRqQZebQ2Iq+9ALBtxTXuE8/V
         wMEV88BucmbeH2IPgHm4dUQFUw2Ws2sm9/ZRydN9A55ijYFfiQ5cnDDy8L4Tyy5+jXBm
         myCA==
X-Gm-Message-State: APjAAAWr6ZmrGwxwABmOODQ2rs0h4eX3nNUwtnVKNJ/hRR2MI4jAQua2
        XrcXk9Pevrl3LsVXpBZLV4Y=
X-Google-Smtp-Source: APXvYqzjh1MdwxBqFk6CILCeRSDh2SgcBfmLZfrn1QbBmMeJFaV2K5b7VF4bsEnDiikj2j/8SPuWeA==
X-Received: by 2002:a9d:6ac5:: with SMTP id m5mr20044264otq.265.1568431882864;
        Fri, 13 Sep 2019 20:31:22 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i20sm1349315oie.13.2019.09.13.20.31.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 20:31:21 -0700 (PDT)
Subject: Re: SFP support with RGMII MAC via RGMII to SERDES/SGMII PHY?
To:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <6cd331e5-4e50-d061-439a-f97417645497@gmail.com>
Date:   Fri, 13 Sep 2019 20:31:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Russell, Andrew, Heiner,

On 9/13/2019 9:44 AM, George McCollister wrote:
> Every example of phylink SFP support I've seen is using an Ethernet
> MAC with native SGMII.
> Can phylink facilitate support of Fiber and Copper SFP modules
> connected to an RGMII MAC if all of the following are true?

I don't think that use case has been presented before, but phylink
sounds like the tool that should help solve it. From your description
below, it sounds like all the pieces are there to support it. Is the
Ethernet MAC driver upstream?

> 
> 1) The MAC is connected via RGMII to a transceiver/PHY (such as
> Marvell 88E1512) which then connects to the SFP via SERDER/SGMII. If
> you want to see a block diagram it's the first one here:
> https://www.marvell.com/transceivers/assets/Alaska_88E1512-001_product_brief.pdf
> 
> 2) The 1G Ethernet driver has been converted to use phylink.
> 
> 3) An I2C controller on the SoC is connected to the SFP cage.
> 
> 4) TxFault, LOS and MOD-DEF0 are connected to GPIO on the SoC.
> 
> 5) MDIO is connected to the intermediate PHY.
> 
> Any thoughts on what might be missing to support this (if anything)
> would be appreciated-- 
Florian
