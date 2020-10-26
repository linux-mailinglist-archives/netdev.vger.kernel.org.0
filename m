Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98D6298E4E
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780424AbgJZNnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:43:19 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39772 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442892AbgJZNnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:43:19 -0400
Received: by mail-pj1-f68.google.com with SMTP id m3so3124586pjf.4;
        Mon, 26 Oct 2020 06:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6tyo6/Rz9v1TVvQDDCsgVJqXw8PO3L48+d1JoVzKHlc=;
        b=jRRiwl2oMxCN+44Rho1b8WdvpInvjlfPHuzjKE6Znjj9NxFRYX5x42eK29aAwGHtJw
         r9WPBCsb3Z8vDp4lfw4wmtPX7H0KXkIpmvg2fje9wc485E+lReNZGcTdHE/ZxbtCZqLN
         YFXvsm2kwuUxO6QyPTy2ICDIlyfyvWf6wUkZGHftshWyZLnRC4U6ZNwvfFcThCQLo6+w
         eHzteYzwSTi+HXy/5fpZidu9yM7zSBdAT+XrTS/3a6193zxelQbeKwgj4skMyDtXf4UY
         8wbksvHh9FUHFkoRQdfr5VjJxf6bxI+KTTUml8iMrjU5gty6fCuMvDOgIGqKwimzZYzz
         +l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6tyo6/Rz9v1TVvQDDCsgVJqXw8PO3L48+d1JoVzKHlc=;
        b=GSkSG8w/H2y+eaiTYxH2lWqzu7w+N1TBZtqpKL1bsbG2iY+u2L+1t/gNBZNW6QrxYd
         dYXA56LbDtZhmjzLf8RSBkKJVEjkrDwMKIL0ruvQkcd1Gsr3gX0nPj091JXB0haUFYtp
         ew9Ei7UHgGRowl8GuDs4mRvHMOF0h+amSUf0uJ1wlv0tpONB+R/KGpS3Frugomz9tik1
         QabZSg+8BGBZG9z3h4RnGS5rllq5+icFDBcCMG++JoHR20xcTjU23aCVFh1SsXBYi2j3
         dM3ZONfrqZGllR/4oczMkS8LKjyrN2LHdTIufpdtykYuB7GYyiTMDx1T7TAEN5zNCi6d
         l1Fw==
X-Gm-Message-State: AOAM531hZxiyo2mwZz5NnN7nCAlRu8OsuguJpBaTiLx47hNK2eGK0YBF
        WAqjx706FM9+6/5IIsRj+Z8=
X-Google-Smtp-Source: ABdhPJxG/YytS4NPFMynmf0hfmKobq2ZV6tqkLVUeQWPpmi9pN1+KcBF8TUkKuTQJscd9AmAZ7edAw==
X-Received: by 2002:a17:902:d686:b029:d6:5192:345b with SMTP id v6-20020a170902d686b02900d65192345bmr2194533ply.66.1603719798548;
        Mon, 26 Oct 2020 06:43:18 -0700 (PDT)
Received: from [10.230.28.230] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ck21sm12483034pjb.56.2020.10.26.06.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 06:43:17 -0700 (PDT)
Subject: Re: [PATCH v4 0/3] Add support for mv88e6393x family of Marvell.
To:     Pavana Sharma <pavana.sharma@digi.com>, andrew@lunn.ch
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
References: <20201017193044.GO456889@lunn.ch>
 <cover.1603690201.git.pavana.sharma@digi.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3746c90e-a3da-5484-2a85-a1bb6fa926a3@gmail.com>
Date:   Mon, 26 Oct 2020 06:43:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <cover.1603690201.git.pavana.sharma@digi.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/2020 10:52 PM, Pavana Sharma wrote:
> Hi,
> 
> Thanks for the review.
> Following is the updated patchset.
> 
> The 6393X family has MV88E6191X, MV88E6193X and MV88E6393X products listed in
> Gigabit Ethernet and Gigabit 10G+ Ethernet categories. There are no 6393 devices
> (without X) but there is 6191 device (without X)from a different family.
> The product id is listed with the 'X' in the name so I prefer to retain the
> product name 6393X in the driver whereas we can define the family name as
> 'MV88E6XXX_FAMILY_6393' without 'X'.
> 
> The patchset adds support for modes 5GBASE-R, 10GBASE-R and USXGMII on
> ports 0, 9 and 10.
> 
> Tested on MV88E6193X device.

Please subject your patches appropriately using "net: dsa: mv88e6xxx: " 
for DSA changes to the driver and "net: phy: " for PHY subsystem changes.
-- 
Florian
