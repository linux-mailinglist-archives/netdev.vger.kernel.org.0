Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A45D50F8
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 18:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfJLQ2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 12:28:03 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37415 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbfJLQ2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 12:28:03 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so12849017wmc.2
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 09:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rlZOIIESlLS8BpJ/iojZyOmAUr5i7cXBiUWfQR0RRRU=;
        b=TI/ws21K9UnQB3c+1OJTUoxlFqS2NGUFGLjicYudUae8CeznkUXaaSqQxTDuxL6UzK
         R6YJSK+2Xl/jgjT7EfpZk3u6VTzZpBRUCFMvZaEy+6kmpXUHL5ftoEEQENnaPSYD8D/t
         F7Kf0ClYZ4yXu60Ybnm15X0z775ekWJEewsmQlt+dX+FKAxNSfjPaomF0WNWDCLvT07B
         zW+rVQsq1TkZU6tGeXd59VmpwpKYrjzfRSSYNr6UaCQti49kcY40fRL8xpul1CKpyIaG
         Yv1CK5pT/3onFA/G+rFKqf5w1DwTwy3Zk8Cg7kPgC8fnh8L2VcbJMXdErzA9ZS4x/xXp
         j5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rlZOIIESlLS8BpJ/iojZyOmAUr5i7cXBiUWfQR0RRRU=;
        b=pt0NEevXMNx7SnK34KqQXp5DLDYasyapjYqA//mtsFi0EzooX/uS8wdQlSVURJA/SD
         bIbUJttk8z85uGSpl9lhF55a73L6Dt4QK1OcReX4CgxAL6h2KwC8K2DAdVoo86eLXDKB
         Li22gR1wUHnJIDhr64lA+veuDC+lk2yuyCGUh509+yUn4nwSKfTH5WLf6Z6MkSaKTpo8
         9ajP1B5L6L/cmY9PPd3GWW8bzzKI8okWL2pOSNdr1BS7l755WAdOVW2AF1YlFJg/oHyx
         yb5bd9YQ2gFJcF4ye1rUSUCYhzzaBxfVIulww4PUhs4Lv4ULeNofttjefjklL2FpET2j
         SM8A==
X-Gm-Message-State: APjAAAUUjR7Cwg9zxzau3HNo6NsYwMrog73x9PA6QSVo477EBwIEbcI3
        3xnjyUFHwaie6Z8uicdW/pH5H4U0UXw=
X-Google-Smtp-Source: APXvYqwInYnN77+DPezBIakDhTry1zFsdQL3FUqbF0U1VUn0Vko0bwh7AwkypK0Rpispu3+IAal2/g==
X-Received: by 2002:a7b:cf28:: with SMTP id m8mr8056104wmg.63.1570897679698;
        Sat, 12 Oct 2019 09:27:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o19sm16161220wmh.27.2019.10.12.09.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 09:27:58 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v2 0/2] mlxsw: Add support for 400Gbps (50Gbps per lane) link modes
Date:   Sat, 12 Oct 2019 18:27:56 +0200
Message-Id: <20191012162758.32473-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add 400Gbps bits to ethtool and introduce support in mlxsw. These modes
are supported by the Spectrum-2 switch ASIC.

Jiri Pirko (2):
  ethtool: Add support for 400Gbps (50Gbps per lane) link modes
  mlxsw: spectrum: Add support for 400Gbps (50Gbps per lane) link modes

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 52 +++++++++++++++----
 drivers/net/phy/phy-core.c                    | 10 +++-
 include/uapi/linux/ethtool.h                  |  6 +++
 4 files changed, 58 insertions(+), 11 deletions(-)

-- 
2.21.0

