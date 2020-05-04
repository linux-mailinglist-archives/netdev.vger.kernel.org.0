Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694E51C49C3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 00:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgEDWpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 18:45:05 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:41980 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgEDWpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 18:45:05 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 May 2020 18:45:04 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 49GHlY1ZpFz9vY6h
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 22:36:41 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gf40TafUjGYt for <netdev@vger.kernel.org>;
        Mon,  4 May 2020 17:36:41 -0500 (CDT)
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 49GHlY0TvHz9vY6Z
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 17:36:41 -0500 (CDT)
Received: by mail-oi1-f199.google.com with SMTP id j84so319423oib.21
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 15:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=64urMlieBPhteKCakD46TmqveQT9kT5oO4nkAodHJ9Y=;
        b=C0VsSiJfDQGikGjlrABXcdLHwAIpGiBKuCYmcslbNcRcnJHD+4qMjhDaCjHVyEzaI9
         3Cxg/SnMMZUXX7fC069f7tQFyvC/+O2z128JM/bbYAGq0+L40ZcdtcMgorsv3/NEUVkA
         HqSTKkc4T2Xj4iDxf7m1CpJumBDKkn8b1c88czpBREMcs5KDvEIJxytJX+V6r11qEL11
         JQqPCPTLORUjkeQoXSRiHYGKTQ2vX9A0ck5DQ9WpCRehnzRfO9vnAT38H6oa6qqoOr4S
         4BBU+ZSoyV79+MLSxu+g7OMkvi9okgAtxn8jWuq0JgVTOV29oTn5X/q8v/LE15AgyCno
         7Oyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=64urMlieBPhteKCakD46TmqveQT9kT5oO4nkAodHJ9Y=;
        b=PM0W/rZ1iAntZ1DkB7metxvaw02gDpq+2C6DXUM5oQND8w+swbzlE1L2xfoMVRmefH
         yFecZBwEoCtAxwZZb2MIxQ3p4dhSpMzcFrATvg68todbQCKtKptzE7vbtu/KTXgBvI47
         Ztq70J7Gzsg/Qz9fXUDM6G9MVc1zLFWgsgy7ofAisK/fzOVipzsLixES0xgvc0VJiPM2
         +OKsZNoVEX9f79ZyY4RUahdqgSzqggLI++8xxrMI290rvpaIIhooDDueWMxj9lp29Dqt
         4WYEba97t3B5BZluT6ock9cYQJC3lCs4lw2tXYg80JY6OppYUGRKdtVYTXxeAKofOvXn
         z19Q==
X-Gm-Message-State: AGi0PuYzXbgUHfD4XIaFDn2Lh3KV5/MmdacF5C08iZlDM91a3mP7Np8Z
        WynRa6kgeUlKLlpwYXgk7a5miMLhedNPRuCvhco//XWco37QTWQgsYkCScSn7v3C24himIFe8pE
        wTRFf2eGdDPmb2fkA78QJ1Mkcs5s4n9mymGsR
X-Received: by 2002:a54:4115:: with SMTP id l21mr462896oic.15.1588631800517;
        Mon, 04 May 2020 15:36:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypLhs2soxclb524UwzekmnX0fUXn6jRkl1yJQEuxf2en1z1zVxNicRVUvSslUbXitlUpnydFzs6wwWDi6ZC8Wy4=
X-Received: by 2002:a54:4115:: with SMTP id l21mr462862oic.15.1588631800122;
 Mon, 04 May 2020 15:36:40 -0700 (PDT)
MIME-Version: 1.0
From:   Navid Emamdoost <emamd001@umn.edu>
Date:   Mon, 4 May 2020 17:36:29 -0500
Message-ID: <CAJ7L_GoCA0e0npN5amfAjK4KJKxg0fTXo94VqzMMB65y4LRMMA@mail.gmail.com>
Subject: Potential Race Condition in tls_hw_hash() and alike
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Stephen McCamant <mccamant@cs.umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was wondering if a race condition in net/tls/tls_main.c may lead to
a UAF or not?

The scenario can be like this:
1) device is initialized and registered via chtls_register_dev()
2) while tls_hw_hash() is executed in one thread, the device gets
detached (CPU2), and another thread tries to acquire the pointer
(CPU3):

        CPU1:  tls_hw_hash()
        CPU2: chtls_uld_state_change()
                  CPU3: can be tls_hw_hash() or tls_hw_unhash()
        //<assume kref == 1>
        spin_lock_bh(&device_spinlock);
        list_for_each_entry(dev, &device_list, dev_list) {
                if (dev->hash) {
                        kref_get(&dev->kref);  //kref == 2
                        spin_unlock_bh(&device_spinlock);
 kref_put(&cdev->tlsdev.kref, cdev->tlsdev.release); //kref == 1
                        err |= dev->hash(dev, sk);


spin_lock_bh(&device_spinlock);
                        kref_put(&dev->kref, dev->release);   //kref
== 0, release
                         kref_get(&dev->kref);  //BUG: kref 0 to 1!




Basically, the problem comes from the fact that kref_put is not lock protected.
Do you agree that such a race condition may happen? If yes, then is
moving kref_put inside the lock a practical solution?

Thank you,
--
Navid.
