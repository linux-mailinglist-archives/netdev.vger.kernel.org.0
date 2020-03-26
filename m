Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3458C1937FB
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgCZFmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:42:06 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:44785 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgCZFmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:42:06 -0400
Received: by mail-pf1-f174.google.com with SMTP id b72so2221399pfb.11
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 22:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QQM7DSJnjHZf4CMiJhUAhGzDJ0zvjdD0E3QxycNBJNs=;
        b=VRbhYx3wn1q4GGFQogVkUwG4QnAC0MybJ2vCo4QhLTY0RNDmCqTYLDB84jt+Nl3Vp/
         HGmu+TY/Wha5H9OLdR+9c9B6rXl3vHM99CWvFpbY4afVFknD8F8NV1JWIIbOMTDwur2i
         xWns3IVB3PkSCEYbXEv/to+XkiGcA3C+LZBDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QQM7DSJnjHZf4CMiJhUAhGzDJ0zvjdD0E3QxycNBJNs=;
        b=Y410RNEJYwbWSCAKi7LRzjlsciZoe/o+t2DynVwDzyOdxSITm4FGeD/DkKUd6hIUZG
         YG0kQ+fdgblg52YQIob0HZQuKjFVAC0tgltQaZKFE6Oufg6pV11jIwSo+5nHpfFel/+e
         1UDP92KInRIk+HL3NbRP8fsqc4LhhGDRS0dyETlljw0UC1fvskaVDJllYnFDTu2Cdmnn
         yrhvOarr4HXcNjJ+6OqPVFNX0Zd/RBl4wofFaCFMuijPQFGH4TDRd/eWIfd/+FSscmp6
         66CQHhnn7DoFTPbE+LLAAYQI0vTajfFb6n5tarHyRtWBr0u2b06j7bxwHwQfOy+mq+WJ
         XDjQ==
X-Gm-Message-State: ANhLgQ0LPxHx17P0du3ip9Suizk78a1ir6x+SRUDMNrn3fKlpkkGmUVk
        LRTy9aY78ZVokxI6SOJqipOZGA==
X-Google-Smtp-Source: ADFU+vs/AaE6aqlQY1TAZZCQG2Z+KY0trXhgyyzVOdBbs+3c2BgHS7P5zclsKKY9+PHHw4Fb+FfirA==
X-Received: by 2002:a62:7950:: with SMTP id u77mr7533442pfc.34.1585201325384;
        Wed, 25 Mar 2020 22:42:05 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id b3sm710855pgs.69.2020.03.25.22.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 22:42:04 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/1] Bluetooth: Add actions to set wakeable in add device
Date:   Wed, 25 Mar 2020 22:39:16 -0700
Message-Id: <20200326053917.65024-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marcel,

As suggested, I've updated add device to accept action 0x3 and 0x4 to
set and remove the wakeable property.

Thanks
Abhishek



Abhishek Pandit-Subedi (1):
  Bluetooth: Update add_device with wakeable actions

 net/bluetooth/mgmt.c | 56 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 10 deletions(-)

-- 
2.25.1.696.g5e7596f4ac-goog

