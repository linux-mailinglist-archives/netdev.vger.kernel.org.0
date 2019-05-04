Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD10136F3
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 03:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfEDB6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 21:58:18 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35797 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDB6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 21:58:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id t87so3206839pfa.2
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 18:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MSyfRO9WNGP7Tny7UaKtQ/+Ug+1U/JbO+NvaM4dtqTQ=;
        b=lGNHoz6B8PcWicybGpSo0FU7PwEn3/6TX8ZxgJjaCDPR4CUysNNywXQfzmX0ZwL7yQ
         Bm18fupklI3fnTfeV1zcDoHiItxm3WJtcmuN+vA7haGF460ahBrWHnBe6ejHCtwlrrqj
         uxEGvtWpS+QTnmFq0sDaYEXEZXhZho7heafHLKgQmz2fUbiDRJe4I6nvRgB9zpDwemIC
         D2qL4tYmcz6g0Qf4816bR7OIzvT1FpeO7RtLZPDA1JsOilYbRL+QqtwUtM4/BDhawVZl
         b6oWoqNMp4rf6W0obMeEONXH+2MJILsJXV+s34nndzayLQOLTiZBn3vsdmfjSumSJl49
         S+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MSyfRO9WNGP7Tny7UaKtQ/+Ug+1U/JbO+NvaM4dtqTQ=;
        b=kQO0Zb5bxMgYFQ4CaqzfHIlpESbpmf2mZA0Axg+3tWNX1szvK6fKkDLEnLuKsxv64A
         Yic87lV/WDApS/c+I4ObmiHnIYyU88iBoudlgq39Jbpj6/jtDaBQI8vxwH6XJ1A+mlK3
         trh4Cdc3iJQQpkk1jUac3hjZNyQruCKC3DFXg/pCanaTVgZLlGoIJpwcEOYBRIztMapL
         uem90TIvYeh4+OYxEqf1bZ13ytJnZ3Xehgv4AvJTQdRrJnFbMdhlBkwl/JhxN8kRErjF
         kupf9yVz/c7KB4dzExd1t1O+0XgJPz1kLQSbSSKaVRLlxOjUFqepXPkxU3BNd6I/hXdm
         YdUg==
X-Gm-Message-State: APjAAAXxvxkdORejyVSHaCBC9qHTbiCJMueGGS3nH4ro9gmS6fp/DloN
        KhrJnmzsUr90z7tI1JIy1nw=
X-Google-Smtp-Source: APXvYqwDleeq2gDuck9E4CqwQdoo+LQKpTuA1FD6rFVM3XUnXchWbfS3JoR7VczfEtv9vNKE/7s1/A==
X-Received: by 2002:a63:8242:: with SMTP id w63mr14877129pgd.169.1556935096424;
        Fri, 03 May 2019 18:58:16 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id k191sm6657481pfc.151.2019.05.03.18.58.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 18:58:15 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: refine SMI support
To:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
References: <20190503232822.23986-1-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f49798be-13e7-e5e1-d6dc-1570f4c0cfed@gmail.com>
Date:   Fri, 3 May 2019 18:58:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503232822.23986-1-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2019 4:28 PM, Vivien Didelot wrote:
> The Marvell SOHO switches have several ways to access the internal
> registers. One of them being the System Management Interface (SMI),
> using the MDC and MDIO pins, with direct and indirect variants.
> 
> In preparation for adding support for other register accesses, move
> the SMI code into its own files. At the same time, refine the code
> to make it clear that the indirect variant is implemented using the
> direct variant accessing only two registers for command and data.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
