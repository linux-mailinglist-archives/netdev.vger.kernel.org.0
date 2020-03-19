Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA818BCD6
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgCSQl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:41:26 -0400
Received: from mail-qv1-f52.google.com ([209.85.219.52]:43070 "EHLO
        mail-qv1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgCSQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:41:26 -0400
Received: by mail-qv1-f52.google.com with SMTP id c28so1339376qvb.10
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 09:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=vyAMExzQFKjpC1p7pxbxvA9MT64/Ex/7RNGh2RuVBzU=;
        b=NJAO/b/i6XXu1vUbBm1trI283ayCvJtoP8TkREHTcrtcmBmxJMN98rJmytZ0ow8GGD
         smgH4ioHLZu/TUXApynMGIOcP4td80//UzTrvKf7gA8e2ElvLpYuG4cnphYZfoeW8Qzj
         Y07ern09OLsIuYut7cUO662Ie5VmdeH8CGLydsrxCtV+mZqJEZZ3nERwy1DhgcpML2n4
         eRpFwQtpdLzVLoAfXyYqrHkMLsQuzgiUgzMcSoOPgCHy0KOWI0jzY7BQiBQ0huNA6m3j
         efcsHtPj1AIjCfto/cuXv/CKUZiYDs97DFmfHxDyQhMUBPRExjlOVoLTRqPunoJggLwZ
         /GIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=vyAMExzQFKjpC1p7pxbxvA9MT64/Ex/7RNGh2RuVBzU=;
        b=Ihczo7ohRhNchSL6H3BKBLXwJKng006UTxLgTMj/U3jeISQc6vqVyxOD8mqXkAUFIY
         ub2KWcszt8Gh+h+Le/0onPVYNkDEV214isqgQFbl/c6XEgfX5gBVMK9jIvrTHeo6UDba
         ouHXdmZee4gBUlilkPJgfQu/IxYiYFu84euredagZ03br6vC3tAj6HO7JY+DrP6zTzKG
         Yf3AVuINtBJIT5D1ng2fKlH5a+zIgIrAPb6MC94E05jG3cfbZ+8sqvMBXUthNU8EGkDI
         B/8wLyZGq3sk12vI6xeUU/Jvou66og0C78UuSdyd0Swx14YEnglzIxZRnmhWk45Xk9mh
         4rcQ==
X-Gm-Message-State: ANhLgQ09T6c/zFjV4rLyyqP7Hj03qAqdW6kWkBZt90wF/JjNWNSyNQUx
        ofAyfaYlrb7qP7TRI294/+uXJ9YJRvA=
X-Google-Smtp-Source: ADFU+vvTOE2pGo10uUVqIQpvDOOHgn7IT+Dw6//5ek7UaNo4N2khjiyp4d8VaB8scYN4LZ0p0ePqiQ==
X-Received: by 2002:a0c:c60a:: with SMTP id v10mr3854353qvi.140.1584636084808;
        Thu, 19 Mar 2020 09:41:24 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b7sm1841891qkc.61.2020.03.19.09.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:41:24 -0700 (PDT)
Date:   Thu, 19 Mar 2020 12:41:23 -0400
Message-ID: <20200319124123.GB3412372@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Cc:     netdev@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Andrew Smith <andrew.smith@digi.com>
Subject: Re: [[PATCH,net]] net: dsa: mt7530: Change the LINK bit to reflect
 the link status
In-Reply-To: <20200319134756.46428-1-opensource@vdorst.com>
References: <20200319134756.46428-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi René,

On Thu, 19 Mar 2020 14:47:56 +0100, René van Dorst <opensource@vdorst.com> wrote:
> Andrew reported:
> 
> After a number of network port link up/down changes, sometimes the switch
> port gets stuck in a state where it thinks it is still transmitting packets
> but the cpu port is not actually transmitting anymore. In this state you
> will see a message on the console
> "mtk_soc_eth 1e100000.ethernet eth0: transmit timed out" and the Tx counter
> in ifconfig will be incrementing on virtual port, but not incrementing on
> cpu port.
> 
> The issue is that MAC TX/RX status has no impact on the link status or
> queue manager of the switch. So the queue manager just queues up packets
> of a disabled port and sends out pause frames when the queue is full.
> 
> Change the LINK bit to reflect the link status.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Reported-by: Andrew Smith <andrew.smith@digi.com>
> Signed-off-by: René van Dorst <opensource@vdorst.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

For the subject prefix, it is preferable to use "[PATCH net]" over
"[[PATCH,net]]". You can easily add this bracketed prefix with git
format-patch's option --subject-prefix="PATCH net".


Thank you,

	Vivien
