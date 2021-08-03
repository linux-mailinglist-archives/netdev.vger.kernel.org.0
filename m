Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7343DF4CC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbhHCSgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbhHCSgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 14:36:07 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3FFC061757;
        Tue,  3 Aug 2021 11:35:55 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id c16so185011lfc.2;
        Tue, 03 Aug 2021 11:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gnM/Q2IbA1rmJhQAti2D3WKSmmNiqNbaQiA58Kdm/AA=;
        b=EsK/1f5sW74lRxlP+XRUm61t/RG9U6bJl/Rnv58+a9RV4Vt/yn7T/xXjXDsvBxiFt4
         QXc5SN9rDLgTI0sbBY7EXvMAXZQ3YT2Ns1igG9UJ7Y9GdlF4Dhr8gjKDgrsZwH41JE4Q
         A0I/S8u8uqvZ6Do4qS26uYGEKpiTmHl2dl5mqu9DAbonpCdtI8Jph98ubpsxaRUYINt7
         IL08FXQPBCrbw7a4DXrhB+eZwt+nsFIpIwnTo2rcnI/F2IvC1IHOw/A9Lzp7/xyPWm2A
         Mpl5FRywvKEBwEUHvl0Z1h+DTiTWcvK9Dr7zjeXhg5XKvdXQT8ASZdEh0ggbD8wBYnXc
         CNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gnM/Q2IbA1rmJhQAti2D3WKSmmNiqNbaQiA58Kdm/AA=;
        b=ODWI6jTZf0SzHeNY1e4qkKComNfBHvFpgkDP8YcQBDQGeVSP4JGMT0HFyasYXN3ge9
         UBHCM8sSNtUpD039HbDTMcox7SUiW7vrwdgpC9ucaMqD7oYrT63c2O5/foXqrUughY9C
         HLaXHhRyVPfEB/lYYv10S9hoJyOfExutIshszFOHVITOU48jlvTEFhWS/GCWNRMfngGa
         9lryRJkpoXeiP/9bKtcIwOmNr4ZKvBOOWnD8jRiiUcWVIUM6YCZYnaHhIu4fqw8Z6YnM
         0gXdT9M+6MQV4/FUiijx2K7UwwDzsGBkSPVB2NvUh9GatXa0jJP47B78vDQaJg0aFGUN
         rWuQ==
X-Gm-Message-State: AOAM531kuHYDomb3i66rQINuSI/zT1Cu+eVy3IdO+ByshiumlRt+kbjy
        ON0MJdY4i1alqjwfblGjb1Y=
X-Google-Smtp-Source: ABdhPJy6r22BeLJnzSXS7qHETuwNehffbnN8pJ2wS5LA5pRL0CJa0l7AbkmwRUkc/dW4uu80FWYP1g==
X-Received: by 2002:a19:740c:: with SMTP id v12mr16200428lfe.519.1628015753908;
        Tue, 03 Aug 2021 11:35:53 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.73.7])
        by smtp.gmail.com with ESMTPSA id f8sm1319289lfe.141.2021.08.03.11.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 11:35:53 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/8] ravb: Add stats_len to struct
 ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-5-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <766c4067-d8b3-6aaa-5818-b4d9d5c6f42d@gmail.com>
Date:   Tue, 3 Aug 2021 21:35:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-5-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 1:26 PM, Biju Das wrote:

> R-Car provides 30 device stats, whereas RZ/G2L provides only 15. In
> addition, RZ/G2L has stats "rx_queue_0_csum_offload_errors" instead of
> "rx_queue_0_missed_errors".
> 
> Replace RAVB_STATS_LEN macro with a structure variable stats_len to
> struct ravb_hw_info, to support subsequent SoCs without any code changes
> to the ravb_get_sset_count function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]

   Finally a patch that I can agree with. :-)

Reviewed-by: ergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
