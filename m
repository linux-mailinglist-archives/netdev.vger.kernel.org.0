Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6164CAC750
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394728AbfIGPl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:41:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44833 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391833AbfIGPl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:41:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so5217021pgl.11;
        Sat, 07 Sep 2019 08:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h9jqyJ3/4GccGaL3G3P4ifJgltEHVSdYAm3P0EcL0t8=;
        b=k/JejIbCVQAcADIOpNZKhtcNgDIEGunVSocdOjJYEJ9NhEQR6v3hRKXlzWz4CgA60z
         SLK6EPoAAwwv5X5eWaYaIAiJKLlWQV6KSFPQgoytQSkDgWHQmWH5c5dhQpotz+u75ZNL
         J3Y7FD6XWKx11oGLLA/rM164L8YoAXcfbF446dNaZ1/X4cvMg6oVHI2U8a0hfBvRN2rV
         k4KLO5c85OH1r87Lg7nkawnLA3MmcLvRjk6n7W7S7qRcTIdswuK9GGm21RYRKJs/kwnk
         Fjvtr4XJQvGGC9c0wfnD5yoAxmnB/QrFQLnlBFo9Zj/q2hiyOx9nbckv/9bYuGIgKsM0
         hUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h9jqyJ3/4GccGaL3G3P4ifJgltEHVSdYAm3P0EcL0t8=;
        b=R0jfZwftJPUTeaLuJT1JgtdPFf1eY2ep+zSZF0EgOHOMqSkoZnn1F+i/SXFbZPLovh
         PmLJkeLgEBDiGUo7cpiEjr3zMiJsNiz9whooiAXgS+d7JRrNGzZGhuTM39A/Ow5Amn7A
         SfvFaiaZ6nacuir7C1MGypvWmUBA78jJcHAVqXu9zOirtdOp1gO538dcxtVqDW2gWu3x
         3ylFr/FjZDgrlRMS0PG82ZNbTCZZpCX9yvvdSZ7Og3qaSLGY2A8zgyZ/eeryGWNy0XzK
         CzKkJa32bR6skCNDyR2OnpfRRKnzeT/B9cSQcACJTEbTSnRY9eTCTXk/PPOne81OjGaB
         qE+g==
X-Gm-Message-State: APjAAAWv9YJ/M/sVxn/P7GakEgN58e1JCWDQleUVr9J/2Q+Mjhh5rd57
        pQiwof6iFbRzz9/e5TZ/WkNumnqlLlM=
X-Google-Smtp-Source: APXvYqyK6KAb1DcRrnLw2wleDUcaH0w1XPCoN8plCnD+BDUrC6/X+ZvZfh5PgG/jhbB4fb/0xdifjw==
X-Received: by 2002:a17:90a:3acf:: with SMTP id b73mr15077799pjc.88.1567870884998;
        Sat, 07 Sep 2019 08:41:24 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s5sm9176498pfe.52.2019.09.07.08.41.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 08:41:24 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII mode
 type
To:     Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, robh+dt@kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Trent Piepho <tpiepho@impinj.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <20190906192919.GA2339@lunn.ch>
 <23dc47ea-209f-9f51-d4a5-161e62e2a69e@cloudbear.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8055f8ce-5a8e-fa53-311d-3f27a72f58bd@gmail.com>
Date:   Sat, 7 Sep 2019 08:41:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <23dc47ea-209f-9f51-d4a5-161e62e2a69e@cloudbear.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2019 1:45 PM, Vitaly Gaiduk wrote:
> Hi, Andrew.
> 
> I'm not familiar with generic PHY HW archs but suppose that it is
> proprietary to TI.
> 
> I'v never seen such feature so moved it in TI dts field.

My search engine results seem to indicate that this is indeed TI
specific only and this is not something that exists with other vendors
apparently. The "ti," prefix is therefore appropriate.
-- 
Florian
