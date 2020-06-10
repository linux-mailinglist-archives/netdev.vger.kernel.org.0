Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC49F1F5D4C
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgFJUk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgFJUk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 16:40:26 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98850C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:40:26 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r18so1495146pgk.11
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 13:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lo0/SE8IXZXwbTZMPh6EGOBfF/IRixoQhYemNfB6AVs=;
        b=EI4b+J1Eja6cdvOSql6vZGqt5/Q1ocogp78JoWNshLKO8Y0x75On5Cu6sYuqlgWZFi
         PdaLrP9H72ak38+zjF7NPxSS025lHlIdqqtr6i55RZGrJzYyXYML8udFFIHp+D/J85ru
         no7Ggavh9RN9+1u5akVdeS4d1i7U0U2j+3aLKtbY/bd8uAbdrsCkVsZnqBMlFXW31u4Q
         FGZeKS8F923YHevgBokxxJFYTQanDeeg5a4rKCga4Zm0+FoTCDpGmpoG/cWiiJcIuwVY
         wavdHfQBIrWq9kJDL7KKHfXAsJGXPicVEVTB/xAn6KX+275FtqULtO0y3UxIYglpQiai
         Y9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lo0/SE8IXZXwbTZMPh6EGOBfF/IRixoQhYemNfB6AVs=;
        b=ZeOlP7wzfO7P7SFLxW1WEI7hPiYDYVBJy8lp6aR9feZiifdcsz9wJ2AOV/G4Z+x9gT
         iRiShF2b5PlDF2k3uigtZ8+9KoglEq7mrSu/SUmtD6KTOjrpCiWX1bm0T1xKupD3etvZ
         WzDjFH3rL0vGhSE+YypJTJRBjEccatmvaDrlIrRfCAF8XqrvP68MZSjGy8wrje/aUk8w
         AttkJic5ia4XY8NdPqZjIsTgm+e7f3SusSIbH7xbiaE/CsttbSz7HEtPFSD/N2pzrri9
         zIt3mgQDndmc9phbiaHQCMBr+wKmzyttuV+czHRg6nNWZcjqPUqBsaiq2v1smjcDVyim
         Aqrw==
X-Gm-Message-State: AOAM531IERq/PE5vZ8zALzcrsXlmz3e/4egvbm2XyhT7eOJ6T/gtqH8E
        jLuIcKRZDvD9NZyZbvUHhLt3B4mC
X-Google-Smtp-Source: ABdhPJyt6CxntjTe+GaxjpD7sAIZ1rS788zylH5dB/LKGvWiAh1BJY8MVyY4wsVUD26v+p7qVzPWHQ==
X-Received: by 2002:a62:5c03:: with SMTP id q3mr4302043pfb.58.1591821625339;
        Wed, 10 Jun 2020 13:40:25 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n1sm788777pfd.156.2020.06.10.13.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 13:40:24 -0700 (PDT)
Subject: Re: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
To:     Andrew Lunn <andrew@lunn.ch>,
        Helmut Grohne <helmut.grohne@intenta.de>
Cc:     netdev@vger.kernel.org
References: <20200610081236.GA31659@laureti-dev>
 <20200610201224.GC19869@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bd14bc16-1f0b-695f-cd00-713c100bfda7@gmail.com>
Date:   Wed, 10 Jun 2020 13:40:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200610201224.GC19869@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/2020 1:12 PM, Andrew Lunn wrote:
> On Wed, Jun 10, 2020 at 10:12:37AM +0200, Helmut Grohne wrote:
>> Hi,
>>
>> I've been trying to write a dt for a board and got quite confused about
>> the RGMII delays. That's why I looked into it and got even more confused
>> by what I found. Different drivers handle this quite differently. Let me
>> summarize.
> 
> Hi Helmut
> 
> In general, in DT, put what you want the PHY to do. If the PCB does
> not add the delay, use rgmii-id. If the PCB does add the delay, then
> use rgmii.
> 
> It is quite confusing, we have had bugs, and some drivers just do odd
> things. In general, the MAC should not add delays. The PHY should add
> delays, based on what is passed via DT. This assumes the PHY actually
> implements the delays, which most PHYs do.

In a MAC to MAC connection, one of the MAC, or both, or the PCB must
ensure that appropriate delays are inserted in order for
the RGMII connection to be functional. Or put differently, you could
view one of the MAC abiding to the 'phy-mode' property as if it was a PHY.

This is the reason why you may find Device Trees like
arch/arm/boot/dts/sun7i-a20-lamobo-r1.dts where we have a stmmac
connected to an external BCM53125 switch and the stmmac sets phy-mode =
'rgmii' while the switch sets phy-mode = 'rgmii-txid' in order to
account for the necessary delay.

The essential problem we have today is that there is no consistent, fool
proof and programmatic way to ensure that when a MAC and PHY or MAC and
MAC are interfaced to each other, that the delays are correct, this is
almost always a trial and error process which is irritating.
-- 
Florian
