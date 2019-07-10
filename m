Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1E564850
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfGJO0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:26:44 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:43947 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfGJO0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:26:43 -0400
Received: by mail-lf1-f52.google.com with SMTP id c19so1741216lfm.10
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nv9p/G+s9XtbbbTHB54r/CSbDNWoOb77fcrWutVfYq8=;
        b=eBMeHMKybkIEBqDr6w99KrnEXGyDkPz9sItt1EtsmxnQD7Gnwk4wtQy03KZnCF+86K
         q9+1vvKZxI6oR64bYdA05nmnBZ9riEKWeLM6dPEP0dzyNPXobbRLxHqxAq18KGQBFY7q
         HpQs4KXs5sVRXuRO0XnOmYQK8bqn8MR27ymwxrBKRpTxTUlPjcqnpeiMhlc/d+75lYKH
         7ibShzSop6ZSjxPWxWZH3zkjsH/pr5kFYze0THExtPDeoEnl++fzgOQHMeGIaYwTSPGg
         NRaF2ROCpDiEqJZtIbCH7PQend6jhJOY5fgAS+XFw52G4OB6MACNOv376QT/lD9zDojV
         aSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=nv9p/G+s9XtbbbTHB54r/CSbDNWoOb77fcrWutVfYq8=;
        b=fz/Mjdnj+VDYwVZ4EpygT41dU7v2kOvVTDaFdZ8Ug4BcSwRdpaDFZzt8jZgtuy2Tcc
         BVj5skOK3rWUqbcLkRTMoS18Ht0FS8lMhSKVitLaUpZJGkmbl+Gw/cpl3wbrJfN33sc9
         U52+0vORFT0hfwIfNEhJj8OhbrwpNyMxvxEFDc4oPMBhi/75rMYGqLzFt6E7Bif+VnVW
         R7bNRZ1+KtLiRT2iFdUUmtzK3YHA4hAV7g2v/qGvHiOOB02gjSLOdven53thU264YCpG
         41EP8yYdzCHRD8KnK3u9qDUrlGhz1mxlUY5MOxI9q93F/YWKMDjWZfTM89W6gZabZhB7
         SM3A==
X-Gm-Message-State: APjAAAVsp81Fnubruktd7izijGx3RasgdFbAfmLSWr/rJ2SolEFk5wE/
        g/267+hba4FHApthypJFeoJKmg==
X-Google-Smtp-Source: APXvYqwm5UNfCj55WhIv27Loj6GM6O6ploYa29fsoHfI11MRiIhU8qT1ozyqldFfaWQMFLXIXxwmyg==
X-Received: by 2002:a19:4f42:: with SMTP id a2mr14942041lfk.23.1562768801531;
        Wed, 10 Jul 2019 07:26:41 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id n24sm501910ljc.25.2019.07.10.07.26.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jul 2019 07:26:41 -0700 (PDT)
Date:   Wed, 10 Jul 2019 17:26:39 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] davinci_cpdma: don't cast dma_addr_t to
 pointer
Message-ID: <20190710142637.GA5375@khorivan>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190710080106.24237-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190710080106.24237-1-arnd@arndb.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 10:00:33AM +0200, Arnd Bergmann wrote:
>dma_addr_t may be 64-bit wide on 32-bit architectures, so it is not
>valid to cast between it and a pointer:
>
>drivers/net/ethernet/ti/davinci_cpdma.c: In function 'cpdma_chan_submit_si':
>drivers/net/ethernet/ti/davinci_cpdma.c:1047:12: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>drivers/net/ethernet/ti/davinci_cpdma.c: In function 'cpdma_chan_idle_submit_mapped':
>drivers/net/ethernet/ti/davinci_cpdma.c:1114:12: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>drivers/net/ethernet/ti/davinci_cpdma.c: In function 'cpdma_chan_submit_mapped':
>drivers/net/ethernet/ti/davinci_cpdma.c:1164:12: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>
>Solve this by using two separate members in 'struct submit_info'.
>Since this avoids the use of the 'flag' member, the structure does
>not even grow in typical configurations.
>
>Fixes: 6670acacd59e ("net: ethernet: ti: davinci_cpdma: add dma mapped submit")
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Despite "flags" could be used for smth else (who knows), looks ok.
Reviewed-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

-- 
Regards,
Ivan Khoronzhuk
