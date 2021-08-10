Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1BF3E7E02
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhHJRJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhHJRJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 13:09:17 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A40C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 10:08:54 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id c6so11712814qtv.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 10:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=M0nMc32VdYeoROakqfdUuqdNeVnekYQ4hd5V8oDaN7M=;
        b=pgVJN2i7UW0gnI9xKl+qd1+UJbk1gvKBllUJjNMc9eYv01CFtXlOZsejG/mBg46Ka3
         dwcU/JR6gTtc2oO744Ojs2krSWB+9aCLGX7V9pCMRZUiM7nY94G383Ld3gWk3/ohKNPL
         LgJ68mkfhYBUVKQKLqvUoyp/t6SQNRmFbK6v2iBiVy20ZoaYz9LchiaSJWCEa6+wdn/i
         A+oWfBv7lw74wxLsb8Enfw0AGpgVlLcFzSB7j3YnN4KsTF/99dfKNfZM+pvbj16zNZij
         +WX0Qv/KN398U+DH/170VpHbZb2kdkzc8IDwI9xTGVLjdvS/g+RcmFo42B2NyLMRKOse
         esqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=M0nMc32VdYeoROakqfdUuqdNeVnekYQ4hd5V8oDaN7M=;
        b=r4DKE5IRqvqZsTbdD1KTiHj3jejoMHyMcQ8Sdfa4o4kDNwx2d95jE/Pc/yJOD9z/47
         nNxcGprE4ECFAdAgRAT+gFUmr1TCJHzXyDg5V3Faq28HLvny3iG992yRFkn7lCMHYGvb
         UI7Py6BzxbRolj/pWObeb1lYUIzMZpPoKoGwkcBD/IGzJKY+a9btXlhNZUqs8dYA3joa
         XL2793iB6fyUf4+/E+e5WDfbeUc8ubipnAP+in1QauJOEcHroY3W3ddEVyIS1kTgt88q
         0Ayn8gZvhMVNf417EaEFHonsxj72PlsdDnrSJifKelj6/tizd3IeavM9vv09HR59RkTo
         QOAg==
X-Gm-Message-State: AOAM531KWzqdosc8K1MPQ8TthTy7Y7jBeaxEpHFzsrRzLBrpfHgFzU0y
        2D908umb1RC37mOvvE7CQgX6iOUIG0tgjg==
X-Google-Smtp-Source: ABdhPJxKPrfTZqcK0gHuLOcyLYaxjm3Jy4sYYs8ctATrBZ7Mwl/gg2kJDtdAgx2mpAz7DsuayNYgEA==
X-Received: by 2002:ac8:73c9:: with SMTP id v9mr13551051qtp.12.1628615333996;
        Tue, 10 Aug 2021 10:08:53 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id c69sm2442113qkg.1.2021.08.10.10.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:08:53 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     people <people@netdevconf.org>
Cc:     lwn@lwn.net, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lartc@vger.kernel.org
Subject: Netdevconf 0x15 slides and papers up
Message-ID: <64ae0651-61b7-7a40-2eb4-8f1cb6dda87e@mojatatu.com>
Date:   Tue, 10 Aug 2021 13:08:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

The slides and papers are now up. The videos will come after.

Check the session pages for the links to the slides and papers
https://netdevconf.info/0x15/accepted-sessions.html

cheers,
jamal
