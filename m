Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95534B131
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 07:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfFSFNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 01:13:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43984 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfFSFNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 01:13:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so1778462wru.10;
        Tue, 18 Jun 2019 22:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9guZEDssE8I+Ozz4TU41/U7IQZOO1+3LKJDr7vi/5Ig=;
        b=OW2v0Mufw9VUMtEQX0EIYMhdF6CFGIbVcMLAKreHYZkGp2OyuSAfASx/K+buOjywda
         Dk6qy5lfj9BrOmNUZl8p3cKJhYMkjPokGwuXVK6EsSXD9p4uhxX/orHbR2WjAjNgEbcS
         VMUmfHMO6pK1C8PqH53BeGopVDQr4MsKWW4ZhvihkaJIxYd1aLloqGLIN9IflPdrF+Al
         K7KRXKaG/oGSStyrstgrltAQBz7LhiLZFOy4fXG2+pTjQkXdffJItdA2mcrSEdkjfUWp
         GSvHKJBu3v29Bi2p2ENmLZHSdjCxcuk7eJEpq2HcGfO7+y0z2RuNhWxr0WmxVi5kIqzm
         zpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9guZEDssE8I+Ozz4TU41/U7IQZOO1+3LKJDr7vi/5Ig=;
        b=KE/SSLVmsq8xWqo+dGrFnFkWLIXAPhhfRCDl84ajtcCqpOwp+Y4dbeeT1qxYFssc7j
         qs/KYupTeX3waCRUFiDh/JEnHW4SgJY2mr3TSYiuOhGSG3onotAa8qex8LCbSZS3SNqT
         tkUme/yMr7lGBo/n1me3QYMCEL/DU7LG9iDrYphh8QH2G2OLj07nDGeJnDblf3imEvdn
         h3alWSCrYrhSLJeKzZB8ksJUDQg5+y6mBda2NNh/Ubhfx3FazrHXqR8IK/CIlyzRVqnI
         Ob88xGYsX3agFVhNGBP5xy+Prjm6OAhZcBq+757krrPaSuVBCUb670mFVqUQsWwku4P2
         C0ug==
X-Gm-Message-State: APjAAAWTcu1QT5lHGo9hOLeCAHxL/hg46U4XjL4gWL1WKozJHFWv+Baz
        rlAw2r+Ypu442qmqynyFWg0fC2iI
X-Google-Smtp-Source: APXvYqxGBww6ssn1q6Cc/uBn6zveGVb+IPhy76VqGDZJSXuEch6xRNKIOwbG51zvq8ngpGJrw8nuoA==
X-Received: by 2002:adf:f442:: with SMTP id f2mr17524212wrp.275.1560921196964;
        Tue, 18 Jun 2019 22:13:16 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E000CE01247662D4005.dip0.t-ipconnect.de. [2003:f1:33c2:e00:ce0:1247:662d:4005])
        by smtp.googlemail.com with ESMTPSA id f204sm301596wme.18.2019.06.18.22.13.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 22:13:16 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     colin.king@canonical.com
Cc:     alexandre.torgue@st.com, davem@davemloft.net, joabreu@synopsys.com,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: RE: [PATCH] net: stmmac: add sanity check to device_property_read_u32_array call
Date:   Wed, 19 Jun 2019 07:13:08 +0200
Message-Id: <20190619051308.23582-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617165836.4673-1-colin.king@canonical.com>
References: <20190617165836.4673-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

> Currently the call to device_property_read_u32_array is not error checked
> leading to potential garbage values in the delays array that are then used
> in msleep delays.  Add a sanity check to the property fetching.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
I have also sent a patch [0] to fix initialize the array.
can you please look at my patch so we can work out which one to use?

my concern is that the "snps,reset-delays-us" property is optional,
the current dt-bindings documentation states that it's a required
property. in reality it isn't, there are boards (two examples are
mentioned in my patch: [0]) without it.

so I believe that the resulting behavior has to be:
1. don't delay if this property is missing (instead of delaying for
   <garbage value> ms)
2. don't error out if this property is missing

your patch covers #1, can you please check whether #2 is also covered?
I tested case #2 when submitting my patch and it worked fine (even
though I could not reproduce the garbage values which are being read
on some boards)


Thank you!
Martin


[0] https://lkml.org/lkml/2019/4/19/638
