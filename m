Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB093518B
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFDVAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:00:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44689 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDVAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:00:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so4599803pfe.11;
        Tue, 04 Jun 2019 14:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pUm0A2fiHDD5iuDzT1paXS/sbVY5jmeSfZnM1voD+pE=;
        b=bBb19qUlZ4wCwYJyGvkMlJZk5uWtE5f0xVnPHMMgaILkUKWuYi0WQuGpSZ01NDDyi0
         WyfC8e3PSA7PutMOcQkfvOd4Ju45+w6A6F97PUBYJaBU++vdjtKKDpGmUJNNoMYfKlLE
         3yL9VAI/vW8BWpVGf42cRe37zIu0WW0VbZUfW9nRLKG1IR8FAR121IbRT1TTcCPW3H+B
         wWia9HRNxUXFuLZnjsQGC5C2inRaUgCVswlS9a6s9CdptTruJSBL0I2QWd2s32tjmjac
         q02PYj2bpTLZITaoNDrmc/DzeMWRBbghxu2tzjx/29UjmzhvtXx+CoGrHhGCPeRv/Dv6
         yrkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pUm0A2fiHDD5iuDzT1paXS/sbVY5jmeSfZnM1voD+pE=;
        b=iOcmh2cNXcljkpC7utqICYHjaP9Y3NMwK3SFSaZTnimKGTxaxCoeBqz8E2aSvs6btC
         iK8ERpE4O7UOIZKtOieTiontTTrlOJb369n9VD8/wN8f8q4Th+A21HsNmfOSV5gouySR
         8vakP+hNZaTrid83FyhXlWkSe2v4POpAklGk/sulDHJoETBIFAYcBLiWn38VEXVBnjU5
         j82xf+3aUMifmxH6Y0D1mPrzOswx+6ExFrdRr2QQqbIAFUvN30WTnZH17XC6tlomosWL
         ofsInOHPMZVXBlsW2rOwoA2BYyByrEL0eso7TqIEOnXupjfbw3mxs68sR2PnRVICQnZ5
         TZYQ==
X-Gm-Message-State: APjAAAWrUX5yMJAH0RdML3tAaNR/ofgHdb+HTV9CnbdH4EWzMFzABez3
        6Me2KEa+216HAIQhgqHzBSga5czI
X-Google-Smtp-Source: APXvYqxQ/Hcqa+12EnpAK4GsuwxyHv31ipziKZP6NNP9siDbIFDgRygQRpYG27lB/deQYvZCtRPuiA==
X-Received: by 2002:a65:5003:: with SMTP id f3mr678683pgo.336.1559682006712;
        Tue, 04 Jun 2019 14:00:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id i22sm18735149pfa.127.2019.06.04.14.00.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 14:00:06 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 10/17] net: dsa: sja1105: Build a minimal
 understanding of meta frames
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604170756.14338-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <12eaf60b-83e9-dd93-dd93-56a19158d307@gmail.com>
Date:   Tue, 4 Jun 2019 14:00:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604170756.14338-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2019 10:07 AM, Vladimir Oltean wrote:
> Meta frames are sent on the CPU port by the switch if RX timestamping is
> enabled. They contain a partial timestamp of the previous frame.
> 
> They are Ethernet frames with the Ethernet header constructed out of:
> 
> - SJA1105_META_DMAC
> - SJA1105_META_SMAC
> - ETH_P_SJA1105_META
> 
> The Ethernet payload will be decoded in a follow-up patch.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
