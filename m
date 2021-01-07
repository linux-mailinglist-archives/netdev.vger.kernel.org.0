Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BF62ECECA
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbhAGLgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:36:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:34756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbhAGLgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 06:36:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610019332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=cfza3Y5VvIC251DqnKn0nKtmkxAhil9L34Yw8+ozHnI=;
        b=Niu3P6HoPh4R3wz1zlit3wWJYZo80TZPSmDolowb1SEuOSc5aBA6hORX9DNvXvds2c7elw
        eoz2jeGjc435Rcc7EWKvIGUipH5cU8d+XJw2mD3fTPw4ec2bxyrQ3bk353b3dQY4k0wweT
        mUKDkCnFm0H92Kv0OceWdhboRxH+tz0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DF0C3AD12;
        Thu,  7 Jan 2021 11:35:31 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, roland@kernel.org
Subject: support for USB network devices without MDIO to report speed
Date:   Thu,  7 Jan 2021 12:35:15 +0100
Message-Id: <20210107113518.21322-1-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assumption that a USB network devices would contain an MDIO
accessible to the host is true only for a subset of genuine
ethernet devices. It is not true for class devices like NCM.
Hence an implementation purely internal to usbnet is needed.


