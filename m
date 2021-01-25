Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F27302181
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 05:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbhAYE5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 23:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbhAYE5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 23:57:19 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC296C061573;
        Sun, 24 Jan 2021 20:56:38 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g24so13618267edw.9;
        Sun, 24 Jan 2021 20:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uVq8X2uMjWj/IFV/3YkhVG4ffhgn5+OMHMsd58hhAus=;
        b=qQZ4efYYaZKDFcgej5srlv7kTJxUxE90eG6qjOv7HxZX1jhxvuvuNP9cJ3b9m1QoLv
         wFQ50/S5LU2QSX2dGhlWLk/6rFZOz0PNrjaQ0+/96yDr1ViW3+5z3NjQssNoGSGQgGDI
         yL/98zz3q//aeoLemZFsUMC396O9PIFAQZg3odrVG74I7H+A1gZfBiCSgkZV9TXdS3hW
         CCjSh0GwdD/7yUA+tQqnG1Mrz5SICmv/XDaJr0bKFTigjC/E//+Ntp+++hX5rTtSA4Nz
         5VAV6HsyU+gKzsRJzb/DNgEn0F/K5oOVJYwU9wZ+e+iUVxZzJgzk6Wt6SR4iUnBULiZt
         M55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uVq8X2uMjWj/IFV/3YkhVG4ffhgn5+OMHMsd58hhAus=;
        b=MLpHMW+ILLJAi4CSDtY7ts7OES6EReLIwM/3R5cpqCdSOdtXaw9rrsF5fzdq4S5HRT
         z4yhdF9Dijw5Dky/3eI5DsQsD2TOoQxKFXeIdOTVeNGW3D9YpBD/9tyPq8QiUsus5paV
         zozhSXqUpQH+qtTpBRi9CwPwgWmFOo5THeeQjcrtdKXYKoLlwKlg2fYKCf1OOQxwkWu9
         y3DLxIEAu90gVNm1nx265w11UnWT5ft+d32jSpTRwDbX7OIRaYNtmHxwXQaaJUqgPSbL
         8UEis6j+lNgAW15JW2rvNfG3lEy5ZyNEBcyrnWrxU7eJlCgSkMeunNbA1xe0i4a2db6O
         j1Ow==
X-Gm-Message-State: AOAM530AecKG2iBvx0WLJHOUHweHhSeUhChCN5RG4MocHZ2l3d5mapeN
        hLYYdpZPLT8OPSRQCv72ZRs=
X-Google-Smtp-Source: ABdhPJyWWV/FhJV+NuoB9EniRSp2Ocr2QjIZwK0n0ZIKuMx8Dedl2X3pzFB3lPANY6DAWwOQNPHwvg==
X-Received: by 2002:a05:6402:310d:: with SMTP id dc13mr188515edb.291.1611550597531;
        Sun, 24 Jan 2021 20:56:37 -0800 (PST)
Received: from lorenzo-HP-650-Notebook-PC.mshome.net (host-82-61-142-146.retail.telecomitalia.it. [82.61.142.146])
        by smtp.gmail.com with ESMTPSA id k22sm7765828eji.101.2021.01.24.20.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 20:56:37 -0800 (PST)
From:   Lorenzo Carletti <lorenzo.carletti98@gmail.com>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Subject: [PATCH 0/1] net: dsa: rtl8366rb: change type of jam tables
Date:   Mon, 25 Jan 2021 05:56:30 +0100
Message-Id: <20210125045631.2345-1-lorenzo.carletti98@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was trying to see if there were some Intel 8051 instructions in the
jam tables with Linus Walleij, when I noticed some oddities.
This patch's aim is to make the code more consistent and more similar
to the vendor's original source.
Link to the Realtek code the actual patch is based on:
https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl8366rb_api.c

Lorenzo Carletti (1):
  net: dsa: rtl8366rb: standardize init jam tables

 drivers/net/dsa/rtl8366rb.c | 264 ++++++++++++++++++------------------
 1 file changed, 131 insertions(+), 133 deletions(-)

-- 
2.17.1

