Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C825D2FEAE6
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbhAUM7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:59:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:59704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731510AbhAUM63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:58:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611233861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=1Od529HWIMsqhULGV/TQT6oCylsfsSs1ynCwBlqmtzg=;
        b=Zkk8e/cKQOEd4EnNXzQYC/AnjKKTiy27QQL8GowdNqDTgEe/eRWvcaIpGoVUPkK+clTy52
        buOujdutTI5h74vdSyPe/jQ8PgHfoZexUK6dFoZE6WB449a8DeNwyck0Y3y4dckDKmIA8b
        nym77541eJpFlDJQS2dAYQbBcvEY6OU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 685F3AC85;
        Thu, 21 Jan 2021 12:57:41 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     hayeswang@realtek.com, grundler@chromium.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCHv2 0/3] usbnet: speed reporting for devices without MDIO
Date:   Thu, 21 Jan 2021 13:57:28 +0100
Message-Id: <20210121125731.19425-1-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces support for USB network devices that report
speed as a part of their protocol, not emulating an MII to be accessed
over MDIO.

v2: adjusted to recent changes


