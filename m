Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9204EC56
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfFUPlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:41:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44733 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUPlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:41:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so3782782pfe.11;
        Fri, 21 Jun 2019 08:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJDiq31OV+XOzMvfVzXl+2UwahEbMZev2ZHrV8WxK5E=;
        b=CBeHdfsAjH/vhHFVhKYolBfVhpk7AU5PIFQxMEcrUxqMTagGV1z3K8iN5P+BDWMAiH
         4YOSwc/2XYkLD5UudTQzEAWJ3H2/m6/wAK59VqASaWdrqmEA8cOYKjVLWERY97s23i6j
         3uiVQ6e9SA0egeqbjRZK5yOSTQGsGq27ULHdW4RZvDGUEz3B0E7gwoRpwp8WH/6Bt+S/
         VvRpPJICbg31ocSKcu5fXhN32BVPubS7QWV7q4e0dwg/kPrML5PY6wHyCfvuV71lw+cf
         LT6qVxggJCaZ+/7hOxLH9eZyOGmb028d7oqILfgWAGpaJbkfbzGD35RBDwWDzPDElyoJ
         qXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJDiq31OV+XOzMvfVzXl+2UwahEbMZev2ZHrV8WxK5E=;
        b=ug/glARO3tcMNSs+hpM4MK4VbhY3bTxSOnvpA9RvD9+w2PdZRAE/rrFXcWTbCUUi/G
         Zn7BbFjCUlF5xBKMnIsiLUd5IB/ngjhCyFvQH16V2YaGehUxcpztcOHlrYF4HWJ+4g6Q
         /2FCI3sn4azmCCj9RBoYxA6bZBRjos/YJcwmg8ZCF11m6jcgM2tNL2Dk9AxDbJ12fh8n
         MhpXV4fENvak0qI9it1E3U/trE91wuJNfjFCUvcEJrVkYpZLuu+Qg+lRGTi2xPXVDM+z
         O6ar6KAWuIPj7OvPUlRIb+3/c1Ujzz9YZ6TBt9QavlhWQoCmrZ7VjsFdpQgBZD3mWRvz
         Lt9A==
X-Gm-Message-State: APjAAAWFce/urcqEX6iHx2lZwryoiPBFkBvKRrsKTj4iLUh2CbxVtVPJ
        NvmBlm/A4EsY/hGofBrn95evu7SAC4YB6w==
X-Google-Smtp-Source: APXvYqwkpj2NQ/IdVQNi2ZOIXe+vJ+m5C2x0CHDk6mvsjFr0zVBFRoEF0zomjold+7YGGDZJZC2C6A==
X-Received: by 2002:a63:6ec1:: with SMTP id j184mr19205606pgc.225.1561131660887;
        Fri, 21 Jun 2019 08:41:00 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id m8sm2556940pjs.22.2019.06.21.08.40.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 08:41:00 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v5 0/3] net: fddi: skfp: Use PCI generic definitions instead of private duplicates
Date:   Fri, 21 Jun 2019 21:10:34 +0530
Message-Id: <20190621154037.25245-1-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series removes the private duplicates of PCI definitions in
favour of generic definitions defined in pci_regs.h.

This driver only uses some of the generic PCI definitons,
which are included from pci_regs.h and thier private versions
are removed from skfbi.h with all other private defines.

The skfbi.h defines PCI_REV_ID and other private defines with different
names, these are renamed to Generic PCI names to make them
compatible with defines in pci_regs.h.

All unused defines are removed from skfbi.h.

Changes in v5:
Removed unused PCI definitions which were left in v4

Changes in v4:
Removed unused PCI definitions which were left in v3

Changes in v3:
Renamed all local PCI definitions to Generic names.
Corrected coding style mistakes.

Changes in v2:
Converted individual patches to a series.
Made sure that individual patches build correctly

Puranjay Mohan (3):
  net: fddi: skfp: Rename local PCI defines to match generic PCI defines
  net: fddi: skfp: Include generic PCI definitions
  net: fddi: skfp: Remove unused private PCI definitions

 drivers/net/fddi/skfp/drvfbi.c  |   3 +-
 drivers/net/fddi/skfp/h/skfbi.h | 231 +-------------------------------
 2 files changed, 6 insertions(+), 228 deletions(-)

-- 
2.21.0

