Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AF319380C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgCZFpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:45:23 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46570 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgCZFpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:45:23 -0400
Received: by mail-pf1-f175.google.com with SMTP id q3so2214383pff.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 22:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bP9A1YZQDo91LDYo/6KoY0c2wBmpDuHg+6Vks+B9y90=;
        b=XC6J2i/F0WRhw9aQeuGQ/abxXmpETM+76JaP3zU0LH2dA8EVb4SkfS5+OE7Y9X3UhO
         13DhHAikYxzxifdgGQE/6pidn+E3YVBHiYs4iWfF/HzeULzHQvAEGIqcd+sAVIm20Ymb
         0X/YTYTrhpFgddL0Serq3mb7y/GuPQYa7f0M0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bP9A1YZQDo91LDYo/6KoY0c2wBmpDuHg+6Vks+B9y90=;
        b=af+5QMXJQwyrao87rhVplov6tB3QH8GBt5MLYQNzmS8IkDxA0geWEZwx2nGE6BVtN6
         X28ajRxVQ1O/qkTTD2y9ETViePzCxWyJIsBLH0/qZ5l/lwPdhTfn5xQlkKZ4qyvJSKmy
         WDq0wsoZ82djNermb+/xyeWXaDzeQeWCKVmzhkuaxwj/8yDLGDGdDoJWevQ5x7KPPsjk
         HhQNrCphIQUNseuKZRSGxiyVuzvLp/Yk5oPxARO5MMUfbV62i2ceEOUpJcgeGwCBnCy4
         12Ufi+JmLGYynxGnZoNPC9Gj3FvKVbvex3tg8IRCQMJOIxCvkqPq+OtBxuTLlL/FtSM5
         RzEw==
X-Gm-Message-State: ANhLgQ2vSIl1TG7GGdR425uLqJ3RSRqyBapJ57Bena3gJA0dZCbAmyfr
        LX3xB2cjCR9FDQA3O2AcTlyEYw==
X-Google-Smtp-Source: ADFU+vv4lcfr85S/TT7MJ8OdAlRUFTZHdQtIftkjB93CEHoO5lWO6VZjKfVhvupSb7NpHwtm6iwGmg==
X-Received: by 2002:a63:cc43:: with SMTP id q3mr6947155pgi.63.1585201521752;
        Wed, 25 Mar 2020 22:45:21 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id d1sm727302pfc.3.2020.03.25.22.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 22:45:21 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 0/1] Bluetooth: Add actions to set wakeable in add device
Date:   Wed, 25 Mar 2020 22:45:16 -0700
Message-Id: <20200326054517.71462-1-abhishekpandit@chromium.org>
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


Changes in v2:
* Added missing goto unlock

Abhishek Pandit-Subedi (1):
  Bluetooth: Update add_device with wakeable actions

 net/bluetooth/mgmt.c | 57 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 10 deletions(-)

-- 
2.25.1.696.g5e7596f4ac-goog

