Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10EC31E8EF
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 12:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhBRLDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 06:03:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:51994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232298AbhBRKVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 05:21:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613643659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=C33ulrHamiNe3wX1vgIaEimKROQBIOK4/0l4XA3Wxqw=;
        b=nsYvFB0EPozGT9asp85BuSZ4dYyHlWkQHVs7Uobdn2ZLYWUIYH8eUqcpA7NDyMrECJ3UfE
        wavrjKdAkH4Yn7MNVcJed5luTh1Y9Q8JPbtfGus4l3e+9K8fvePV1sIfMlu3dAxWglKztK
        100Zhtqe1gTB4ryzdTx8AAEc2EjkCN8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6903FADE3;
        Thu, 18 Feb 2021 10:20:59 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, grundler@chromium.org, andrew@lunn.ch,
        davem@devemloft.org, hayeswang@realtek.com, kuba@kernel.org
Subject: [PATCHv3 0/3]usbnet: speed reporting for devices without MDIO 
Date:   Thu, 18 Feb 2021 11:20:35 +0100
Message-Id: <20210218102038.2996-1-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces support for USB network devices that report
speed as a part of their protocol, not emulating an MII to be accessed
over MDIO.

v2: rebased on recent upstream changes
v3: incorporated hints on naming and comments


