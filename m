Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50812F4191
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbhAMCOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAMCOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 21:14:54 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1F9C061575;
        Tue, 12 Jan 2021 18:14:13 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b8so197107plh.12;
        Tue, 12 Jan 2021 18:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7Dv8VHj4cl0IJ/IRCVmjmoN/r+eoJrPoNdwnGzWzRiw=;
        b=QbZwutD7LYBwuWxSqDFDBG95vVX2yEgKQtIoYgZXZUJFz/3yXUFz5WydoNnlxPW3OY
         nz4pjS67lABP5RLCs0Jd8TyRHVL4oQ9Ub4oXDOGFNHOJXHC3oG6Rlf7WVbONZnQv879U
         Pdp2S7mH8FgK2Gq38QDgHgvGjoqOuyUflGuOcBS8EQnOZZMgp9cYC3nxXR5lA182JSFx
         dh5Q7Avdxf6j/hcyC39vyRIVTn75JGJ+cpd6tXl6sbhiQAZstI4bBm9wEPByHwTjPrEu
         jN7eRRXLd0gFZkw9Xm9MiNo2Tg5ljr/G8m5VJEPJ4Ek3rLkFEie/Zo4QSYTCyX8nG3jk
         r8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Dv8VHj4cl0IJ/IRCVmjmoN/r+eoJrPoNdwnGzWzRiw=;
        b=fGXvGfd4n53rs5Q26lIeCjT26z+T80sEy1b96KcujDSNCdZL/i0qjuu84yP0DHL+dL
         jaXFhtUtwbNbsWPJZkpb5qHvnarTUS90+k3WqilO1Q1dpPm7mNwTNNDqyz3CDKWdnRCs
         HKrQiKwJ192xY89RQOMrYqvD7YwefOeW+pQOya8GmMtZ5LFbV5JVk6BP6KxG8Dz8OjbN
         OfYNmTIgPfPIc0DZmgdZTKEZM8eQeRmGAPUKYzKAuw3idUo/F1FdvnV1yQWxaJu9dzeB
         01NIwImN16Cb+CyfPRQogBCQ8A/VaP55ubYyDVHlGck5uT8Chh5erhK5Y2fhClArXZu5
         G4Hw==
X-Gm-Message-State: AOAM531SO5MEbGkhk6A34Bd5n/YTYc3KHdTpMFgBhy06lAhNeAkiJRiP
        +YxseV1b70IShyuZkRe03g==
X-Google-Smtp-Source: ABdhPJwVn9WKvC/F6doKBN5282/Rl8v/DlfFNvECRUWV77cTopq+5XwjdZstjo0yJBHoRgDmcFvLSw==
X-Received: by 2002:a17:902:8643:b029:da:d5f9:28f6 with SMTP id y3-20020a1709028643b02900dad5f928f6mr2422691plt.8.1610504053172;
        Tue, 12 Jan 2021 18:14:13 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id i7sm449664pfc.50.2021.01.12.18.14.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 18:14:12 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH v0 net-next 1/1] Allow user to set metric on default route learned via Router Advertisement.
Date:   Tue, 12 Jan 2021 18:14:07 -0800
Message-Id: <20210113021407.17872-1-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210112154326.00f45bf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210112154326.00f45bf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the hint, Yeah I missed the call to rt6_add_dflt_router while 
applying patch to master branch.

I am developer of SONiC OS (https://azure.github.io/SONiC/) in LinkedIn. 
We are planning to move to IPv6 only network and I realise that IPv6 needs
capability to let administrator configure metric on default route 
learned via Router Advertisement in Linux. We support a fixed value 
1024 today in Linux.

Note for IPv4, administrator can configure metric on default route learned via
DHCPv4. 

Kindly Review the fix, this feature is useful for IPv6 and Thanks Again.
