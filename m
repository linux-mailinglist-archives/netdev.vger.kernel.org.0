Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038A52B55FD
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbgKQBJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgKQBJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:09:55 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF32C0613CF;
        Mon, 16 Nov 2020 17:09:55 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 10so15868050pfp.5;
        Mon, 16 Nov 2020 17:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oVVsJ4ZcPDpOyiQ8ZJmU7y3GOevoZVV/7qfIzZhlNec=;
        b=cZQhG663NVXtfswxBZmD6bsFWhlEnFkFp6roHU7TltyxEsSukSfZ+OaAUsxs7j8qw3
         y9dVk4/aJBi8Yyw9AGGa3jLuGCtKi6aKolF7lNcct7EpMSIh3yp6ujxXH49snqsGyvEa
         KzXITfujXYFCKFDm7DQ+mRTnkmcGEPa8u7wpFCZr5pI+5mGWyMGKELqWZqMPXFzW0tyw
         D/ymLaP4VJ1/McXmIZM+I2tOPDfU4BSMVpyLTo90oLtIxU5gMqtMLGUZerTg/4DLDAyt
         zan89AB87YLNSk8M9cekh6BKR+obCdVHt2qm5ol1YSbw47WRJPvoJEQh4nVrdvNGJJ9R
         WgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oVVsJ4ZcPDpOyiQ8ZJmU7y3GOevoZVV/7qfIzZhlNec=;
        b=exAO++EMyK1KbuX+1Wm/yEG0aEmtpysHfBunAOGPwpg+E1e3DvWcbeGFXPNwjVykqP
         M4uaiZm5hcousliFlf76F5QuRt2RtJyDSDc5/E+TEEBuELwC3uvCZdTZdg97j8tMR+Zb
         D+G1p8IygWZA7g61mPcMhqstW4DAs5XYMMBJmVWBcmBhB+ULe9PNnp7XuquOFVc9TKQC
         +TxZkhV0pdQwImXkdIU+IR3EK2x2Gokvo8ZLgE5rO3LiR6z/MLlh3jnxXdARrWhMuFch
         rW7thtIBF+9yaonk3Nt+wQuF+oAASm38JVwvjaiXfr38b4O7In+bnLiFdNeyOzyXL9Ww
         PTDA==
X-Gm-Message-State: AOAM53251kcSPJFgPkOvz2PTfu7fst8FSKSMAnn/1GR4AdAqjqdaWDf8
        WJyfIv10AGxeeeigwH+aIkQ=
X-Google-Smtp-Source: ABdhPJzneLrbjZvjhpVdFZvkb40oDtTKDeGBP0v5WNLfeFQ/ltLwx12cUz3nTH8fKh7sGHHNE8OdjQ==
X-Received: by 2002:a17:90a:ab89:: with SMTP id n9mr1811610pjq.104.1605575394601;
        Mon, 16 Nov 2020 17:09:54 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id m23sm7362091pfo.136.2020.11.16.17.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 17:09:53 -0800 (PST)
From:   rentao.bupt@gmail.com
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH 0/2] hwmon: (max127) Add Maxim MAX127 hardware monitoring
Date:   Mon, 16 Nov 2020 17:09:42 -0800
Message-Id: <20201117010944.28457-1-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

The patch series adds hardware monitoring driver for the Maxim MAX127
chip.

Patch #1 adds the max127 hardware monitoring driver, and patch #2 adds
documentation for the driver.

Tao Ren (2):
  hwmon: (max127) Add Maxim MAX127 hardware monitoring driver
  docs: hwmon: Document max127 driver

 Documentation/hwmon/index.rst  |   1 +
 Documentation/hwmon/max127.rst |  43 +++++
 drivers/hwmon/Kconfig          |   9 ++
 drivers/hwmon/Makefile         |   1 +
 drivers/hwmon/max127.c         | 286 +++++++++++++++++++++++++++++++++
 5 files changed, 340 insertions(+)
 create mode 100644 Documentation/hwmon/max127.rst
 create mode 100644 drivers/hwmon/max127.c

-- 
2.17.1

