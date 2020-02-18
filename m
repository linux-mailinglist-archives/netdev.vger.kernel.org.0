Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1579E162EAE
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgBRSg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:36:58 -0500
Received: from mail-lj1-f182.google.com ([209.85.208.182]:39309 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgBRSg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:36:57 -0500
Received: by mail-lj1-f182.google.com with SMTP id o15so24169399ljg.6
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 10:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mlvm7tdaTRbHKv/BOXIKrOi3ISxRhZUPQ07gSkSTjEs=;
        b=JYFRB2NjOcqfkCvq5a+7W1wvZpHTwY1PImVMdviMqjJsuAQiYomthQEggbcUprq76c
         8mp7jai+eZdEdXqaHG7ojmc1E+sEVhkfRmQFiDrEqFJlTN3gDodPINm5od3fRnP08KiB
         EgdnDM2q5yCc4Wpdm9RV9oFgDHbqOFqmiHG3gIBrWTMZFog9MuNylRF/YBQfK0Hv8pgm
         DZ6d+zGSxPUfXRF3T+Q9aeFR5MKzilg22vLRQSYfpAJLlyFUvCDLyBY9wyfX+c9CHcE7
         k/tLuO6vNoSxfDZpc3DgpqrQExKbCEhIr9SFFM+kyqbNmD0jnqoTGz/PObcs6+wN1/Fa
         30Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mlvm7tdaTRbHKv/BOXIKrOi3ISxRhZUPQ07gSkSTjEs=;
        b=ps1BnzSIrS6ERWDNXJY4wOLFZ+oUzk0NjBjMj+qzzRXqMrpf0QkesTbANm/xi4CSBL
         whwwbPQ9t6l8+wbEhl06Vfrq5hTyBR+LHxDwlVzY7rMTMt7sHeKYvx2IuPni0JwiOk75
         py5ad3J4DYNrYyml5enYRersQfoQWt1/yQWnqfd3ktHgG/eCwWBt5qsV2/y0pQ2XMUtX
         vpio5rAANQzvrLKpe4dj97B3GbxMR3LH/oXBgeYos8aZ2OWd4ss22L3DwxyQL1ohhRhB
         /iebi3xCxdYznbtJalYZY8cUvFMLhhmpbNy7a4sfqZRtvKwkHV/Ti7yVRjpm+gtTlDDD
         6xIQ==
X-Gm-Message-State: APjAAAXEf3hn0lZ81n+CXlicSEfeRvjkN2B063IRM+YDK1JO3yv+D2ZH
        FiJvic5toGK+qxYow5YHk+Rjs9jB
X-Google-Smtp-Source: APXvYqzzE9Zt9u54kAVK33ndu3jC29rUmIa4Kdlp5n7q9ZktqUxx54F+dxNaRlQ+7WAnERaMU0P8YA==
X-Received: by 2002:a2e:9a51:: with SMTP id k17mr12870772ljj.206.1582051015416;
        Tue, 18 Feb 2020 10:36:55 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id u19sm2671148lfu.68.2020.02.18.10.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:36:54 -0800 (PST)
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
From:   Vincas Dargis <vindrg@gmail.com>
Message-ID: <d4fd5d28-aa5d-613b-cba3-48dbd98ed6bd@gmail.com>
Date:   Tue, 18 Feb 2020 20:36:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e0c43868-8201-fe46-9e8b-5e38c2611340@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-17 21:59, Heiner Kallweit rašė:
> Great, thanks a lot for testing! Then the bisecting shouldn't be needed. Since 5.4 these features are enabled by default,
> up to 5.3 they are available but have to be enabled explicitly. This should explain the observed behavior.
> So it looks like this chip version has a hw issue with tx checksumming. I contacted Realtek to see whether
> they are aware of any such hw issue. Depending on their feedback we may have to add a quirk for this chip version
> to not enable these features by default.

Look great! Please let me know if any more testing is needed.
