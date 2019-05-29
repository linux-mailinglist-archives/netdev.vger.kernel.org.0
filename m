Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BF32D314
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfE2BIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:08:24 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41828 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfE2BIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:08:24 -0400
Received: by mail-pf1-f196.google.com with SMTP id q17so431930pfq.8
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+VEMZtaxCnMGyHIJoCHjaY/K3zuzHZ7Hx4qZ21F8PRM=;
        b=STactteC4BFGPzq2wt0q1lxNFAqRV+wNYZ5ifZHxeeiNOUMznUyT3PeXZHmX2RwIbC
         BYcW9qVrfBhjARkufCtAROLeLXZ6zWMdsRIQ5PoSNzpprZdq4pXOLOL8g3C6+x2pLqj0
         kxJ00AXbKpoxOURUcJIfVCkgP9CTjtIpxJmJI5yJ63l6oskzq606gpFqZTlwncVbpokn
         /aceaaie0PvR4Ud2N4Cvhu+yrbGOXFPyVwwaPAu+nlwz3sjguJnrs+u/erUvR6288FWK
         xmSqhXrPeqqJMxzP99bdI+37PWOPwhwNO1dsOpumJQ81MklE4UIz587Zm64IZTM2M+2c
         Pmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+VEMZtaxCnMGyHIJoCHjaY/K3zuzHZ7Hx4qZ21F8PRM=;
        b=lXDLdlQXPgRSJN9JXQO8k59VNXdAuI8fi6P4smcQzhOx0wqn2jsz+Qj3hX8unTgnUl
         YM6nTrz/HC5POP4qyI2X1wSyi2z3nM/UalUpZNwiy/PHkT5wvswytti5mNWZ3jjoipj+
         9y6yuHStPkmhI/+/fZmuv6hViXpNb/b+9hHMVWg9QTVVI5lad80L8QKqh44fDkDse3IN
         /AMA2rBqHH9/Y4vlMdyVnlfIRZI6dNHgfqG4mjnhCpL+3DMcwFndyeNAtL/T+Xlbctz0
         UUtmwTMKurPSX4j8CctJUYwzoVJEBioKKFmbmVZTYtCs1N+A25Pl9Cpl+M1BIHbWQ4sA
         S1cQ==
X-Gm-Message-State: APjAAAUZzbBX84M4+udD+F/i+WB+rgPLkAk1T1E7BoHdbea0ey3zu52v
        JErNj44VERXNlDFpQ7BXiDF3OInH
X-Google-Smtp-Source: APXvYqxfUii2EREo0P1W1QhLd4DnuF5nnmCkoyENUc1K2YZRwwmeKo6d448y0fwhUIRW90QEZ6Kkgg==
X-Received: by 2002:a17:90a:5d15:: with SMTP id s21mr8914837pji.126.1559092103170;
        Tue, 28 May 2019 18:08:23 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z18sm15509103pfa.101.2019.05.28.18.08.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 18:08:22 -0700 (PDT)
Subject: Re: [PATCH net 2/2] net: dsa: tag_8021q: Create a stable binary
 format
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org
References: <20190528225005.10628-1-olteanv@gmail.com>
 <20190528225005.10628-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8577fda1-9104-2d2a-980f-91f4bb6c6f8e@gmail.com>
Date:   Tue, 28 May 2019 18:08:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190528225005.10628-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/2019 3:50 PM, Vladimir Oltean wrote:
> Tools like tcpdump need to be able to decode the significance of fake
> VLAN headers that DSA uses to separate switch ports.
> 
> But currently these have no global significance - they are simply an
> ordered list of DSA_MAX_SWITCHES x DSA_MAX_PORTS numbers ending at 4095.
> 
> The reason why this is submitted as a fix is that the existing mapping
> of VIDs should not enter into a stable kernel, so we can pretend that
> only the new format exists. This way tcpdump won't need to try to make
> something out of the VLAN tags on 5.2 kernels.
> 
> Fixes: f9bbe4477c30 ("net: dsa: Optional VLAN-based port separation for switches without tagging")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

This looks a lot nicer actually, and kudos for documenting the format.
-- 
Florian
