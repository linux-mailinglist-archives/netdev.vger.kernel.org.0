Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7DDD7C5A
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfJOQwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:52:18 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:45772 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfJOQwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:52:18 -0400
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 08E8B600D27;
        Tue, 15 Oct 2019 18:52:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1571158333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gP7dY/174GGdD6usTpaalR67cnmsiaPwYD5OpFcQfyY=;
        b=axlssqB+DUWqk4taqLCosVffDK8d64AuWwQ15V7uZqtx7iDctmvnRYOYKT+W9sQ0eHsN/C
        6jIbhyD9Sm2mIWuhiqx2sZThjUyh0zi3Yu4hB2KMVydbuj2Tr1PQqK7Q9NC5gMNnk2RdV6
        ZU1x93AcuTKJFTxW0B76PTLkE+3Rtj0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Oct 2019 18:52:12 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mt76x2e hardware restart
In-Reply-To: <20191012165028.GA8739@lore-desk-wlan.lan>
References: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
 <c6d621759c190f7810d898765115f3b4@natalenko.name>
 <9d581001e2e6cece418329842b2b0959@natalenko.name>
 <20191012165028.GA8739@lore-desk-wlan.lan>
Message-ID: <f7695bc79d40bbc96744a639b1243027@natalenko.name>
X-Sender: oleksandr@natalenko.name
User-Agent: Roundcube Webmail/1.3.10
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=arc-20170712; t=1571158333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gP7dY/174GGdD6usTpaalR67cnmsiaPwYD5OpFcQfyY=;
        b=DRapKaMH9Ss4+Y57MDmNYSjvx33aSfwXUw8own30SGyjDa5AMl64qaMDNsqvPX7/s1RUlT
        /QkkeIHxPcKgKgp5SWsPB7WS+D/aWzg/vXK6aNsqs0cbcnq0AIxk4q1eaPz/BTo77lmKqr
        7yVWwSxfpPnFqoATcwt0citzVM5lIws=
ARC-Seal: i=1; s=arc-20170712; d=natalenko.name; t=1571158333; a=rsa-sha256;
        cv=none;
        b=PesOlooj33cKhM+/mIkE91p8YnsF/RM+XyufMQ7N+HwXFSwngv2bnoT5IKQRxPvK2kLS4e
        7/Ja/w9ZpmQ8oiIZboZ0nmfG8W7ad/eC012N804Ng5944lJbgzAaNEkQWMq1YRUDsdWJZ9
        ez1OhgcRkIU+TO6ThLjdLvcKF9Rbz7k=
ARC-Authentication-Results: i=1;
        vulcan.natalenko.name;
        auth=pass smtp.auth=oleksandr@natalenko.name smtp.mailfrom=oleksandr@natalenko.name
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey.

On 12.10.2019 18:50, Lorenzo Bianconi wrote:
> sorry for the delay. Felix and me worked on this issue today. Could you 
> please
> try if the following patch fixes your issue?

Thanks for the answer and the IRC discussion. As agreed I've applied [1] 
and [2], and have just swapped the card to try it again. So far, it 
works fine in 5 GHz band in 802.11ac mode as an AP.

I'll give it more load with my phone over evening, and we can discuss 
what to do next (if needed) tomorrow again. Or feel free to drop me an 
email today.

Thanks for your efforts.

[1] 
https://github.com/LorenzoBianconi/wireless-drivers-next/commit/cf3436c42a297967235a9c9778620c585100529e.patch
[2] 
https://github.com/LorenzoBianconi/wireless-drivers-next/commit/aad256eb62620f9646d39c1aa69234f50c89eed8.patch

-- 
   Oleksandr Natalenko (post-factum)
