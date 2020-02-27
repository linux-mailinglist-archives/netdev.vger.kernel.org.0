Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD85172782
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 19:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbgB0SZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 13:25:23 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:43888 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730059AbgB0SZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 13:25:22 -0500
Received: by mail-lj1-f176.google.com with SMTP id e3so279368lja.10
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 10:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pRIiq1cvh49cOUV6Pe140O4Fm6Ouu404qd69Az033bg=;
        b=JRs5/N8ttaHtoSHKlGf9zSLDdLWef7tJiOpNl8Lm3aYcH0ida7fo8DbVwg7U/LACWi
         xeR1lWod+qBHMntZ/LgfFr9k+vuCkFKEvzKhGAfJhufm050ujb4FrDqLgMG/U/imzLgE
         XrJVn6p+5GNHUbdhulgu+wy7IfMygIGSQGC5dhw+yasyyjhQxA+EGskP8WXLrDn0pWhZ
         rEzpN3XEjd+Hi34zwSy9eFDn9i/5T3K35R8O2j0cQafWCA2hyXAFAEl4qUIUEV1pGn5t
         jp4+wUXXg0jbOkooooStquYYkx1lhybmg4o7AX1uZsnya3LITD0t0PSj8oedbEF9JBlC
         IhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pRIiq1cvh49cOUV6Pe140O4Fm6Ouu404qd69Az033bg=;
        b=EkpANdM/ep/Ofo1niZkcl9tgs4j5/Kp0Ndd+e7jkCiyOMebg7mSAiz7bDganIckaK9
         1C/e5klMTLAvYFcAO7V/BcchxgRoZYhau6ecjdVVUiryoC85uvBac/Owbgj/qKEaP8kC
         OdBG1SbUzQBq8dRIzMjJ9yuyFjvvDBqUz+6jBnGfPfkr+0U8n+iT6N5DL6VS7qv/ikR7
         b+PerIBeIV/iJg0brju0etQMv7twI81vC6m39e7hPaFF2GPo3isgtX4pnAy7pCtAh7mc
         BhTdvNMLjWzkyAG7zKjDPpvBk7zngKIprf+paPJtiI+l1wfHttKKKDe/b7E0Eu3c133+
         Noqw==
X-Gm-Message-State: ANhLgQ0u6sGvLYMcqBUVwAvD8OD/cBGKCdAYY92+hsq6PUa8MwrghfJg
        ZZETA5KjC8uAOdi31LCiY0tSGQ5q
X-Google-Smtp-Source: ADFU+vtccQ0cXUoVWIHyaZD48nFWl+cW4pCbF/Bu6RVziweuSAsXfwRFjtnSEc4aaHiIYyc9NuX/gQ==
X-Received: by 2002:a2e:8145:: with SMTP id t5mr239958ljg.144.1582827919764;
        Thu, 27 Feb 2020 10:25:19 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id z1sm3141824lfh.35.2020.02.27.10.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 10:25:18 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
 <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
 <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
 <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
 <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
 <badbb4f9-9fd2-3f7b-b7eb-92bd960769d9@gmail.com>
 <d2b5d904-61e1-6c14-f137-d4d5a803dcf6@gmail.com>
 <356588e8-b46a-e0bb-e05b-89af81824dfa@gmail.com>
 <86a87b0e-0a5b-46c7-50f5-5395a0de4a52@gmail.com>
 <90776f02-5c98-235b-663f-962ad68e1c93@gmail.com>
From:   Vincas Dargis <vindrg@gmail.com>
Message-ID: <cb8114b1-0cd7-3a56-a567-5745aad43793@gmail.com>
Date:   Thu, 27 Feb 2020 20:25:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <90776f02-5c98-235b-663f-962ad68e1c93@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-24 21:49, Heiner Kallweit rašė:
> Realtek responded that they can't reproduce the issue. They suggested to not enable tx offloading
> per default as a workaround. So for now you have to disable tx offloading via ethtool.

Thanks for your time Heiner! I'll just keep it like this.

Maybe I reproduce it via some sort of strange setup - multiple different P2P applications, maybe Shorewall firewall confugration set some interesting networking options too..? Anyway, if this hang up 
is not universal, I guess it's not worth to disable it by default from kernel side?

