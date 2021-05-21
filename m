Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6AF38C7F2
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbhEUN1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhEUN1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:27:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3679AC06138D
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:25:52 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w12so15573248edx.1
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z5IxABIv8GAtD1wBz8ZNjRYf+DQqu5ULHEWb32fuE0g=;
        b=Tj8xyo6P2xmEZJCWOMoHG+/nyqlvkecEOwd972Lzf0JHHxC6A320mNTpHcpDBaRQ4A
         xm9xlo8NJzPXbzmcUPYEwKy5u4EFYZt0EyFSuprOWJo3I553VxZr7HCmrsJqnBiZogIy
         PKMuc5msGwDMEOtUNv7LVP0q3ugQpNshDYjkbbyUGqtD2wAs+6kofyrnWdIf4VvHhPJz
         RbkcabOhwum8MKb7Y+c/IB25xCA7NG6EBWGIdDqUb9EuqUGk8fYu0KNpnuW3mn0hrOON
         7mBmOlJNlXpcvMbQw6BiIAeUPAEOLbmdAJTK9w6HHDRIHrJH+thmf7CRgLWUipJ5Jcxu
         tZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z5IxABIv8GAtD1wBz8ZNjRYf+DQqu5ULHEWb32fuE0g=;
        b=O1zcsc/j4X9s6aEsuMqQ6GXoCzGYlzIFjRNeuRDL17FW7Lv3VEl9L7zRkF2wCM8DPT
         mwA8+HRPYWdgmt0ezGBnZ/c8d99ErFNc53DqHXRJIT+D0aSR+CxULO8JeppkA7FBA2Z8
         g+p6QEPDlpql8yNxsApusycPViwEDo0h4v6yOjUhwUZ2k1mmsHhyYp31MqiTwWIXqZnv
         or9utKbAOnKJic8W3jdt4ol3iMYbCSmlwIq1TnYkEOb9jDiYheHkEp8nFTLwdSioAqwW
         aSBSV/FEZlTshfikobdgR6SOnZzAKKjODtLsk8sQdmciThoYAdBNr8glJC8zxMFwMD+B
         TzSA==
X-Gm-Message-State: AOAM5322TfOwhjfHKiI2+7uwnTrAIEhRZm/QARTwHDNC6/Ag2awSwadF
        YJeVkNqfuZsuYnvnvGAFu3Nm7LzdBj8=
X-Google-Smtp-Source: ABdhPJwiEQiitcz5VR17aOhU4jgwjdMso49bclCAc8n8zCDkBobYF67nv+Esq1DL6iV7w5GpliYwzQ==
X-Received: by 2002:aa7:db44:: with SMTP id n4mr11130177edt.374.1621603550763;
        Fri, 21 May 2021 06:25:50 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id s21sm3950439edy.23.2021.05.21.06.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 06:25:50 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/2] dpaa2-eth: setup the of_node
Date:   Fri, 21 May 2021 16:25:28 +0300
Message-Id: <20210521132530.2784829-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set allows DSA to work with a DPAA2 master device by setting
up the of_node to point to the corresponding MAC DTS node, so that
of_find_net_device_by_node() can find it.
As an added benefit, udev rules can now be used to create a naming
scheme based on the physical MAC.

The second patch renames the debugfs directory to use the DPNI name
instead of the netdev name, since the latter can be changed after probe
time.

Ioana Ciornei (2):
  dpaa2-eth: setup the of_node field of the device
  dpaa2-eth: name the debugfs directory after the DPNI object

 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |  6 ++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 25 ++++++++++---------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  1 +
 3 files changed, 19 insertions(+), 13 deletions(-)

-- 
2.31.1

