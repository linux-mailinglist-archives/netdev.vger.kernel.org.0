Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B53B3A370
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 04:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfFICy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 22:54:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46738 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfFICy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 22:54:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so3292777pfy.13
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 19:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K2aEF/IkRS6huhyPCOi4PZ2Q+EEL+sY1vtLtCZvHiW0=;
        b=B096U2F+F6Tlx1TnLr5lhiuVS93/mUlsznL9K1Zw84MzeEDoDpVczuptaP9b0QBxAa
         4TWtrLnuggqi+/O8x9v7KzDutWqUvbfdWbPEnSQDAEnWfICVIZMdBk9PBmatYHu9MxUB
         upft7nKm+yigDnWctrAQ8Jx/9PkmFMew4RdskcdwAmSwnsEIWR/+rNjqI/flfP5VOfxe
         8adsQBXj8/qaCx7bQMMHJk+H6Hmj+nLOLcd5WXtYl/sJoro73V39PARJezyI3VUznhPV
         lcLl4ZeTqHGKaZQ1cvmLRP4zDjpngh5a+ywh861KAYQU3Mgj2w7+ys3Qnf/OXptefrEe
         nEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K2aEF/IkRS6huhyPCOi4PZ2Q+EEL+sY1vtLtCZvHiW0=;
        b=pdhafaXE9d7I1AZw9rbXDAZuYdudDmQtVegzFbDXOlUIHMhHRVwpXSPhrSI/DjB7v8
         pgrNw4aAAKT2OVWPrcSWJSJ6V/f8ygV5PvSYOhIlQnyxDxZBkzVwK0Bqf1fQWi7RV2wW
         3Yll4DmLu/oYPz/tBErKRZHFp/eC4X1bI5cmPcISSeswBIztzBqX3bsQfAlnvUwfN6Rp
         Va8vrJ2Nqy8pT6fQBXdI3dItpSvKcwNSjY5fVhO7SKbTab1OhdRCyH2jpigrgkjKcpai
         txs8mz2CNHlRCbSgieXgy4IwAIriH7q2+EbXeD7HbZGcdIdRM8dvTg5WdKi8Ywt859GX
         sZng==
X-Gm-Message-State: APjAAAX74jqe1p8U4MuYniu+Opa8LQ+FKRZn0ZbPQrBPHC/Ra47bdQqD
        93v0S6dTdGjBKRhItnDlqv3wswFl
X-Google-Smtp-Source: APXvYqylvDmRIw5p+C3gJQDuxZDUNt1clJKwAsRg4GqZoS5RD8HHoS+cnu+iPrckDdaAZuTBeuFvrQ==
X-Received: by 2002:a62:754d:: with SMTP id q74mr43944710pfc.211.1560048867156;
        Sat, 08 Jun 2019 19:54:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id o11sm5512506pjp.31.2019.06.08.19.54.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 19:54:26 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: dsa: sja1105: Export the
 sja1105_inhibit_tx function
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190608130344.661-1-olteanv@gmail.com>
 <20190608130344.661-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <284df16f-5f63-5624-a333-bcea4ff61219@gmail.com>
Date:   Sat, 8 Jun 2019 19:54:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190608130344.661-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/2019 6:03 AM, Vladimir Oltean wrote:
> This will be used to stop egress traffic in .phylink_mac_link_up.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
