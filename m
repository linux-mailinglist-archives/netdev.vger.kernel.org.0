Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3000D282337
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJCJje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:39:34 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039F5C0613D0;
        Sat,  3 Oct 2020 02:39:33 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4C3MJd1CMlzQlFN;
        Sat,  3 Oct 2020 11:39:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-disposition:content-type:content-type:mime-version
        :message-id:subject:subject:from:from:date:date:received; s=
        mail20150812; t=1601717965; bh=4fcoQeiZ/a6mgH+eeIB1O2D61IqCy2iRw
        mC04Sy46Bs=; b=DfQhuS7IHtVN4WvJdj8F48DdKf3NMCTEytxW4l/FnxHyG86Nc
        D7nfEO7RuRB5Ow9eizzxgks3w47Krfn2Oln2p4oPoeuwB6WyjKbahJhmoE1dFM9r
        tlpZqy/6mEcobVu0AdDuEn9tn6w5hCsmAITv9U3jzWDYwR3zhqIPqUA+AvA4czL9
        HPIfh8tD1Mk/VxrA4pPNBGfYa/r0v5ljRsakwjIUn5uOIQqMxsb9J8N3CDAlIg8v
        YVJH/IX8ff5ELegwH7i2AAj1QNgNWzDUgVw7AhHlbxHHjORh6uGaD/lsJSHCwclF
        P4WuZPgVwHc+hVUVlMUEq0hDQLzRQ3GSUi9Kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601717967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=GtRh4FFOPlIBcjMgFAPgoxb1b68xqrb8/RdNypF3jCc=;
        b=aAk76KPVxKoWZAzBSYyOmwmlJiKDBhw3VUV8yeJREf61bnzQsfC3FIESaDsKHynCYYXUcH
        u1cJ6HfzISyWtbobCfwrH0d88Z8gch6zdC+WQJxjAffYymVayL58ogUfYJL1UA15dhHjo8
        RdKK1ZvtOpjLjJ5QnixmwFyPgp6RtmCWnkGeQ9acyLHkFd8p2yHEZCbGKJVchP+w51Hgew
        G78fNDG7lhJ8Cq1dyLE14HS/qKmgKssDr8X/KekamRHbivbVuZ6BZTM2yMF+WWcHLLn6UX
        WEUHkLT/FGJ3wJzv8peMhdgxjSHjsf8GQSFc52zPB/AgkiARsufhDzYHvyXkzg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id c3G8ooaTD6zn; Sat,  3 Oct 2020 11:39:25 +0200 (CEST)
Date:   Sat, 3 Oct 2020 11:39:22 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 0/2] add Cellient MPL200 card
Message-ID: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.09 / 15.00 / 15.00
X-Rspamd-Queue-Id: E657617DA
X-Rspamd-UID: 1bde09
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Cellient MPL200 card to usb/qmi_wwan and serial/option.

Wilken Gottwalt (2):
  usb: serial: qmi_wwan: add Cellient MPL200 card
  usb: serial: option: add Cellient MPL200 card

 drivers/net/usb/qmi_wwan.c  | 1 +
 drivers/usb/serial/option.c | 3 +++
 2 files changed, 4 insertions(+)

-- 
2.28.0

