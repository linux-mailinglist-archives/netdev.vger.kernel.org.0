Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931E2C4642
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 05:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbfJBDnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 23:43:52 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44254 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfJBDnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 23:43:52 -0400
Received: by mail-pl1-f195.google.com with SMTP id q15so6526694pll.11
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 20:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:user-agent:date:from:to:cc:cc:subject;
        bh=HDmIGzHQOeB61Wvg7JDFuEXoHbs+chb44oQ8Gv6ExDQ=;
        b=c7Gfc/UhloeTlyITG+/9TyIfkK0DKVYURmod2Gh0r6HaUmfcrLUPQU8RIw+w6ieYum
         nINJ0mCxfLqwsSo471XsPWoDay3YytFtNuhK3s6eoOjsyOX8Ekozr3kipJLhZRIGBgKG
         EyI21YGrbuwuhB2cSkgjZ7vDVcXRS0CL0VUphzSvBe3khdmwmvZJRExDQBqXYvZHKJ8w
         n+wS9VbzZd2diSHEuBVq6cEg4jHQGkFPP9jji60epn8n/CP1VnRleSE95F2pSp5HGZBE
         qhnxR2CddV/xyX1BqDK37/tQsPYW130kbNloMR+NhchevnXuScn2uZHprv7VEB+hjPFQ
         8Sfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:user-agent:date:from:to:cc:cc:subject;
        bh=HDmIGzHQOeB61Wvg7JDFuEXoHbs+chb44oQ8Gv6ExDQ=;
        b=pTWcpfzaWvFdPatDwbdZcseCSqc8H5uTzW56gvNBxjc1xQ/1u+H9fZNONKmF2goaCC
         cclMX6ln2HPKHZ58yl1SLwduZdgibLtTfJXDffpNKDZEE37jizQNrmYHQjEkQdsdmlaf
         5GSJEhaUslw6o+oEuIrV1D7C46HbBB7KBK3vbE9bmjkGhA7pF6Sd7zcl4dVTocAmT/Am
         JJjW39kdzjlz+QZYLl4U8ity5eirOoPBirp5uTko86+szT3SDRtsPrr7ZoPQdKlcbUhb
         AI4sv4vGevNYlLh3TP7rmfHSc3q7PUfw9M0LNmpjFEY0Dv7qNRy4OVfrsPmSAD0b7ROX
         lybQ==
X-Gm-Message-State: APjAAAXaucRT/HzuCS+lDpIGqrab8bzMbq2cYLagi61mm1YpOZ/qml1l
        XYRARBRjwSliHKv4sVM6uHyhdA4P
X-Google-Smtp-Source: APXvYqzsh+uPdhxaSOUVQV6v+PyzZpgbdCNYQgqE9kT12odHC+wWKnUFpTBDifpflLmlRbd8nlLObA==
X-Received: by 2002:a17:902:968f:: with SMTP id n15mr1318241plp.113.1569987831240;
        Tue, 01 Oct 2019 20:43:51 -0700 (PDT)
Received: from localhost ([2601:1c0:6280:3f0::9a1f])
        by smtp.gmail.com with ESMTPSA id u11sm26334817pgb.75.2019.10.01.20.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 20:43:50 -0700 (PDT)
Message-Id: <20190920230358.973169240@gmail.com>
User-Agent: quilt/0.65
Date:   Tue, 01 Oct 2019 16:03:58 -0700
From:   rd.dunlab@gmail.com
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
Cc:     rdunlap@infradead.org
Subject: [PATCH 0/3] CAIF Kconfig fixes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This series of patches cleans up the CAIF Kconfig menus in
net/caif/Kconfig and drivers/net/caif/Kconfig and also puts the
CAIF Transport drivers into their own sub-menu.


 drivers/net/caif/Kconfig |   16 ++++++++++++----
 net/caif/Kconfig         |   10 +++++-----
 2 files changed, 17 insertions(+), 9 deletions(-)


