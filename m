Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268F14284DA
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhJKBuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhJKBuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:50:04 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B7CC061570;
        Sun, 10 Oct 2021 18:48:05 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id u20-20020a9d7214000000b0054e170300adso19678322otj.13;
        Sun, 10 Oct 2021 18:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=duoExRnMrV273AZ/oaZqgFgQ2VuLyiS3q2R3PdjunZM=;
        b=BSkqTVx2dSUr3qkiO1SJeWpOuLw4BJoeAb0Se4DxVerueo2LN+bRac0vnSnNUzYt0e
         T3Hb5vLxadZLxGUAj06vjx87bw7L2+q9pcbGNglDIi8JQ8MjT+/gwliezykq+yFHXM6U
         MtsGPqNkMKeztPbR3m4UQuItJE2lzS2sUHh/eMIT64LIRdnBEU5UrbR82cCA6OYOkNqa
         a6Sg+KM98YKTEx9vQOGfQ0bjr2cvVX5UNHpK+wAxwVZVgASsJACZf7Jnj3mtLwI3I2RC
         CeoPExSJQ2mBQhVE0kuKcB/DrLTYbB0vCQmtnRxK/+Gj/TQAtnvbSJtrPjyMutVMZTda
         4Z2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=duoExRnMrV273AZ/oaZqgFgQ2VuLyiS3q2R3PdjunZM=;
        b=5eI6/Ln4t4RnYEgIAPrk2YOmU+Au+G4JSqmzd1Tws7ViiGvoiNFtYFu4/EvI6eJysj
         HCYYFcQ7bwE0/X+pvpmWIqlcvwPdwQr+O5bd05jB6Ijcy0R7wiDP/yuZaA3Bv3Ri4aU7
         XfCEzrI7G7RKsNd0w0s5nkHZ0uWXjKaj/rOQ2fioEtNIB8aciVeTfGNQW7jOpESKxxvP
         Y4n0J/7OJnURYiMEbBKgJ36Fcll+axYcraZdtrmSDOqorCmtrbQXLxCX/xlJZgd1+8WU
         6sm1o9AugIQu0hgNtVgprmHsuEF5lAesUxkkoVk7vbmHQLmYIHFEp/M7Vg6y4Dyfk4P0
         BZkw==
X-Gm-Message-State: AOAM5320FH0WHCwfbm+xI3qoiXX3saU1zOZYiT8v7oMuoOgYS69veVYJ
        FW6T7HZLIc25a79LjB713vE=
X-Google-Smtp-Source: ABdhPJzfnjW9yRbYUmqyekqUG1TfwDv/Xswkuoif7hWoNuiomDatj7UPIW8NMrFc0L4qFq9VTIsrGA==
X-Received: by 2002:a05:6830:1c6d:: with SMTP id s13mr11911304otg.158.1633916885042;
        Sun, 10 Oct 2021 18:48:05 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:802c:b332:26e0:e0aa? ([2600:1700:dfe0:49f0:802c:b332:26e0:e0aa])
        by smtp.gmail.com with ESMTPSA id l25sm1282837oot.36.2021.10.10.18.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 18:48:04 -0700 (PDT)
Message-ID: <ef535d49-f6d2-447e-ff46-090ea9347697@gmail.com>
Date:   Sun, 10 Oct 2021 18:48:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 02/14] dt-bindings: net: dsa: qca8k: Add SGMII
 clock phase properties
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-3-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Add names and descriptions of additional PORT0_PAD_CTRL properties.
> qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
> phase to failling edge.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

This should presumably have Matthew as the Author, so we would see a 
heading with:

From: Matthew Hagan <mnhagan88@gmail.com>
-- 
Florian
