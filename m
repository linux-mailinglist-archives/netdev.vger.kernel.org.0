Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A897F271495
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 15:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgITNgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 09:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgITNgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 09:36:01 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ECEC0613CE
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 06:36:01 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id r8so9898981qtp.13
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 06:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=AlcJoneKXNfJvO8U/304wgnJFZRKZ49gwNcmCkuy6kI=;
        b=tHTcgXDNp5QrYl8zImaCTIIBq7jn625bpXdEk8AnTT37aMC+arTYuR0O8MOyHEzbUo
         joEk6PPh/iPRH5L8Yr8Zjq9KcETr6IEAwFVoYYpGBdnk39TajehNtYwUz8M+BmQFii9a
         16B86+hDuuuXO6sQ3vmhWS1DZG7BRW8iLHK7LWUhI+ZyYYF9m34kKLsw1ZdJcrL+qXTO
         r7NWWEtoN0cIcfmdyCqo3mRpYV72dOK0vz3ngTaQgw0guhNEqUlGcDvkwqEOJk+k7r8h
         siHgCr93AfSDMVLXyuNxjfb4sQo3lSJjpJcrNc3gbplQYMtynkUvqYc23H1ONx+LScMy
         YYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=AlcJoneKXNfJvO8U/304wgnJFZRKZ49gwNcmCkuy6kI=;
        b=QUSQINWPxSQGHaR/jM5EP1IE1tugECJs3bizWqYvS2779z3ta/Wk6ySfxflZyVg2MO
         gZcBDJHOE84OBq7XIag9mk18u9d93rIoEzrYiKS6q1hzNQDPG05PmT4tuv5Jr1ACwr0y
         x1Hdo96a6JUyy68SzbbqRSOHDwO/bMZmFCmXRufj3ddCCGJ+wKfCFk3BceniNjlnHN6I
         3bu5v2HOjqg/b/Llyi4sPU2L/K5JxF2bGAeVA0aUPJf5Kf/UYNXKgWDl0h9CWAgqg8Yh
         tUePf2AaM4d6vfhuypyI8pbHWodvrmRoyq6D9MgEhrNUszTm46zTys7YHbQwQ2OADLG1
         tEZA==
X-Gm-Message-State: AOAM532EJpo8H6L1HNjHFR4yq9qH4v8rdH3tE8pAzJye90VLjOlV6Bmr
        twF2GJ7ISmt0PU1zAKzdQn5hRYdObgRMWA==
X-Google-Smtp-Source: ABdhPJwD2ou54XRXZOzqX1B5Na/2NQVUqBGtTBGB9AvVWlo94bq11Pv0Fifo2tzLeJ4CgeCKwwlKwQ==
X-Received: by 2002:ac8:7b2b:: with SMTP id l11mr40177140qtu.126.1600608958971;
        Sun, 20 Sep 2020 06:35:58 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 205sm6490316qki.118.2020.09.20.06.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 06:35:58 -0700 (PDT)
To:     people <people@netdevconf.info>
Cc:     speakers-0x14@netdevconf.info, prog-committee-0x14@netdevconf.info,
        attendees-0x14@netdevconf.info,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lwn@lwn.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: 0x14: slides and papers posted
Message-ID: <0257b321-cf56-ef33-5c4a-1cce0fc4c877@mojatatu.com>
Date:   Sun, 20 Sep 2020 09:35:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


To everyone (PC, organizing committee, speakers, workshop chairs,
Tutors, sponsors, and attendees) - thank you for making the
conference the success it was!

The slides and papers are now up. The videos will come after.

The sessions page is at:
https://netdevconf.info/0x14/accepted-sessions.html

cheers,
jamal

PS: apologies if you receive this multiple times...
