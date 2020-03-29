Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581EE196CB6
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 12:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgC2Kyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 06:54:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35576 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbgC2Kyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 06:54:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id d5so17457300wrn.2
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 03:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XTK3qrueWbdi+Lw3QU3crLi0vqzasYPSkkflIrLo0pQ=;
        b=bxZAhX1MKmAbPRSkkdly9M0GKbPRC3ai24/qDzGudKSERp+QCUPzG2RmiOMyqijrZC
         Wne6UAErKM3AY4WeQfdkDgq94RcFV9SWcL7+kWRtK8dHrGw9cPfNVebzW4WLVVEIxc1O
         0DpADV/P8NcZx60LaP1JDx4LFThYwn+HM/keYh9SLOGjRIQyiDHO/aPzX5ddxXX4jUYg
         WA78zwVhG6JW4960o8pzCMwt94lvshjLGyF6pHr/DeTqye7xTAe6IVusVpfXj/xnDq4l
         Wqrhr6vaKVX854m32jMedii4MPgTNELS9QSPwrqNfeOWeSWjrc2LaLO35u4ygY5DIgVm
         yJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XTK3qrueWbdi+Lw3QU3crLi0vqzasYPSkkflIrLo0pQ=;
        b=pDrYdBLkbaeg2SfEXcs/Itb9rbChHuhNPaJm2uRoZYGjW/L12xLvs7kanpE9DFkDLh
         qFi9qCOh9KI6D4aXdHLtLFBqGWTgLFL5xu9ykK4+d66t0h15Y/maZx6WTsMRYSrjspJL
         cSEPWh+TaifxmC8MwJ5fwAHlsj1yyBxck9mhEFlaChjOiovyUFv9Uuk8lwua149n5kSI
         h4HRk7z1eAz7aDH/VvbxnvDu0ySSMgek6pc8lQ73zVIiWLOd7L8k3VW10bgewasHe/6P
         XW+Xs1gcx4w01pp3KmKCXzEq28w7f/foQWxq58y6sXnGXOYADVEdue/Sk9c+U+CGwcyR
         Nrog==
X-Gm-Message-State: ANhLgQ1ltq4gOquLF0IrG44hIHUqkONeKbcmHCwzfA6Begbf2Lb8t0RL
        0pQVhC98kkuvoTR7p4tNylQ=
X-Google-Smtp-Source: ADFU+vs9BoIUAOIgrgrh6y+tgkGZEB2glf9bkkVLQjDuw5DsJskmTv8RuslB0tbkEO5m9A6l000KvQ==
X-Received: by 2002:adf:ee52:: with SMTP id w18mr9229446wro.245.1585479271185;
        Sun, 29 Mar 2020 03:54:31 -0700 (PDT)
Received: from [10.8.0.2] (host81-135-135-131.range81-135.btcentralplus.com. [81.135.135.131])
        by smtp.googlemail.com with ESMTPSA id b7sm16496965wrn.67.2020.03.29.03.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 03:54:30 -0700 (PDT)
Subject: Re: 5.6.0-rc7+ fails to connect to wifi network
From:   Chris Clayton <chris2553@googlemail.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, jouni@codeaurora.org,
        johannes.berg@intel.com
References: <870207cc-2b47-be26-33b6-ec3971122ab8@googlemail.com>
Message-ID: <58a4d4b4-a372-9f38-2ceb-8386f8444d61@googlemail.com>
Date:   Sun, 29 Mar 2020 11:54:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <870207cc-2b47-be26-33b6-ec3971122ab8@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/03/2020 11:06, Chris Clayton wrote:
> Hi,
> 
> I did a pull from Linus' tree this morning. It included the latest network fixes. Unfortunately, the resultant kernel
> fails to connect to my home wifi network. 5.4.28 connects fine as does 5.6.0-rc7+ built at the parent commit of the
> network merge (i.e. commit 906c40438bb669b253d0daeaf5f37a9f78a81b41 - Merge branch 'i2c/for-current' of
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux).
> 
> The output from dmesg from the failed boot is attached. I've obfuscated the mac addresses of my BT router and of a
> wifi-extender.
> 
> Let me know if I can provide any additional diagnostics and/or test any patches.

I've bisected this and landed at:

ce2e1ca703071723ca2dd94d492a5ab6d15050da is the first bad commit
commit ce2e1ca703071723ca2dd94d492a5ab6d15050da
Author: Jouni Malinen <jouni@codeaurora.org>
Date:   Thu Mar 26 15:51:34 2020 +0100

    mac80211: Check port authorization in the ieee80211_tx_dequeue() case

    mac80211 used to check port authorization in the Data frame enqueue case
    when going through start_xmit(). However, that authorization status may
    change while the frame is waiting in a queue. Add a similar check in the
    dequeue case to avoid sending previously accepted frames after
    authorization change. This provides additional protection against
    potential leaking of frames after a station has been disconnected and
    the keys for it are being removed.

    Cc: stable@vger.kernel.org
    Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
    Link: https://lore.kernel.org/r/20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

 net/mac80211/tx.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Jouni and Johannes added to recipients.

> 
> Please cc me in any reply as I'm not subscribed.
> 
> Thanks.
> 
