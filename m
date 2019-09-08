Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EACCACA67
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 04:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfIHCs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 22:48:29 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39237 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfIHCs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 22:48:28 -0400
Received: by mail-ot1-f68.google.com with SMTP id n7so9335506otk.6
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 19:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5AMIGemMBCtsVjcKTe+bxh7NtgWzdEfAWWlBxdYon9g=;
        b=sQGsinPJYs2E8svzEy5k7eerJB5/ZHjFbF0ExtUZIfz1daxx45U4OEKHhFdPubxSMD
         ml71HLNF+9OT413liWy5ZjNxo6Vkxj7qN/xKmf9g2xcNqxuSO8nWULMikNGiL1BVSa0g
         eTX67jwEO366JenKtDdceoCla9N//1B078jLPfsdEvMYmFL5NCAQZKxBGIbUk85hWzj2
         jdYhdAAgNcIqO4hDgKblobZJ5LpxYR9m18PaSDxA/ag8c6SohBXtGpKt+y/H/CjTSlP8
         joklHgdL5j4Ky7/fz+nXJalOy/5d9CPvDLkiofAT5+hFCCGP5Cp+6IPNVdUXMO15lbNu
         E59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5AMIGemMBCtsVjcKTe+bxh7NtgWzdEfAWWlBxdYon9g=;
        b=fsgTxthyjrGacvIYNUPEOjPlMvxY/McosFfH9r50WBw/tDoKZy7Jem5rT0qPgYRwX5
         4ZP+sr7bYGVz2BZzDL6a5hqlen3F/Ut+VDk8vRNyFh8bSPDiyGRu6obLLWitNElTjLUv
         t9hvM32DkP0rVt8+uz6BPJGixqq1UAwsx5R9ozKdnIrnFy4EW8aTHkIaFo/k1pcIL9jN
         OhiOm6Cu9H1DjfG/lGD2e99OE7zxKQHtVcZ0+Bv9Gt0dGhe9Nu9hIaCPcYGpHd7nc2aO
         YydNUwt7K1VEfJ5TskDirnLbxRANREg29pH6vpWt69MXjqDQ8eP3Ws0TltInKHMl2tL2
         cqdA==
X-Gm-Message-State: APjAAAVbHPY/cZNdEBVO+mwS4F2zj2FEPgWdERzlTpvWA5ECKiTNIdMl
        EvElB8C0wTE2gDd7QVbd5ec=
X-Google-Smtp-Source: APXvYqxnkSZEGlsZS1E88gNAVeMcoOVRMHrtXM0U7KqbO65o3GxAQonwIPOTHHLXJBR8x0qZZQmiSg==
X-Received: by 2002:a9d:5c13:: with SMTP id o19mr13488032otk.80.1567910907957;
        Sat, 07 Sep 2019 19:48:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c18sm1857279oic.10.2019.09.07.19.48.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 19:48:26 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add RXNFC support
To:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
 <20190907200049.25273-4-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f728912c-53e3-9d7a-8738-7ce247bbfff5@gmail.com>
Date:   Sat, 7 Sep 2019 19:48:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190907200049.25273-4-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2019 1:00 PM, Vivien Didelot wrote:
> Implement the .get_rxnfc and .set_rxnfc DSA operations to configure
> a port's Layer 2 Policy Control List (PCL) via ethtool.
> 
> Currently only dropping frames based on MAC Destination or Source
> Address (including the option VLAN parameter) is supported.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

For the ethtool interface part:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
