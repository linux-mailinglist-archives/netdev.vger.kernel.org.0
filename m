Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D1010A732
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKZXnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:43:24 -0500
Received: from outbound.smtp.vt.edu ([198.82.183.121]:39040 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726380AbfKZXnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:43:24 -0500
Received: from mr2.cc.vt.edu (mr2.cc.ipv6.vt.edu [IPv6:2607:b400:92:8400:0:90:e077:bf22])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id xAQNhMLK015090
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 18:43:22 -0500
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        by mr2.cc.vt.edu (8.14.7/8.14.7) with ESMTP id xAQNhHw7013833
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 18:43:22 -0500
Received: by mail-qt1-f197.google.com with SMTP id t5so13044821qtp.5
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:43:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9tDePJO0shESaTPA586GqEiZUV55S8L7cvNqPvi0DEc=;
        b=PPNWqcArY1gyh7dg40A44rioSTmgwP0xU+cMPzEMF37O4goq455NuH+iqNtDQ14seP
         ngjJxZ01KDQbBYEbI3echGo7xpiK1acjlSeINTO87IsSxRl7hCYjFP/6pJrM5DSkpCrn
         T4uHE7Nd7tOAu3wxRFrxb2WIa4n3gVxLgoRt9tY8Sdo1V9TDhvlmLH138fpndeZ/yHP0
         s1xCopFoXLfASdtYsj02EfYEbpBGPLXVqS6DYUCCawVk/Jw0athhLfrxlggmM+j73iEF
         tMctQkl9UtYiRSyos7H3BnrEHkj7BCpdkpkTDPybrhkXrqk2DthVY4GZEGty29Dt6JL2
         8oDw==
X-Gm-Message-State: APjAAAW+OIcZTvJWzBBamxpVBE2IqCcgQlNkENS77Fguec88e0QTuUur
        QRXrMg/Fv9ssj7zXT3OwWES3+GDSvfkDQ2zhCVfln9fboNcF8xwEslCvQY30dnx0ovVq0iSrdYC
        ACkiKrqHzeqcPsMqIF7b9KRDWXQOMZJQX442b4jduIYIC6Raa9w+op7AXiUDYqhb/CSUeEAT/OA
        ==
X-Received: by 2002:a0c:e947:: with SMTP id n7mr1639143qvo.103.1574811797141;
        Tue, 26 Nov 2019 15:43:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqxmbKSTu6ahQBhewumEdGddHVdiiM9c0INdgRz0OjE8qhffnvNh9rC1DH96Z8SUuoK86ZPQWw==
X-Received: by 2002:a0c:e947:: with SMTP id n7mr1639101qvo.103.1574811796748;
        Tue, 26 Nov 2019 15:43:16 -0800 (PST)
Received: from [192.168.1.33] (c-69-143-242-9.hsd1.va.comcast.net. [69.143.242.9])
        by smtp.gmail.com with ESMTPSA id z3sm6641922qtu.83.2019.11.26.15.43.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 15:43:15 -0800 (PST)
To:     netdev@vger.kernel.org
From:   Thomas Corley <tjcorley@vt.edu>
Subject: net-next: atm: atm socket families namespace support
Message-ID: <2c53e365-63de-d165-75dd-d7cd21b2855f@vt.edu>
Date:   Tue, 26 Nov 2019 18:43:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, 

I was wondering if adding network namespace support to the atm socket families would be something that could be upstreamed? If so I can get working on it and submit a patch when I am finished.

Thanks,

Thomas Corley
