Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB7A286F32
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgJHHVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJHHVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 03:21:11 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B153FC061755;
        Thu,  8 Oct 2020 00:21:10 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4C6N0h0VSRzQjbW;
        Thu,  8 Oct 2020 09:21:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-disposition:content-type:content-type:mime-version
        :message-id:subject:subject:from:from:date:date:received; s=
        mail20150812; t=1602141664; bh=PKoZnQyBTs7N4cjS78lIcx/SklABDL2O2
        xTMl/vXlJs=; b=qPwwPW1KWYlyJqCUU97CxFCQeel+P3mzup2zXntKL0+sBXTaE
        hC+lyl8mitezmudsxeMEcjjzX+VMLkrMsyVQlX04bJvJmY91q6m7B8X4DA6OXY5l
        JVbsdbDRDW24zZ8i4EHssyMrK8loLT6XAKRkC5yVZdiqWpNhuqaoVPIsISotE/zw
        hKJ47NpXq67aMRRbejlHXhUOkJlIti6SPR+VFIyKwRv1cAe29xKpQn7hjvXK1TmE
        t7fr8GbAoeg1AJE81odysnq3jMvTgX7tFi3UJ4K40hBKXy5H8+/Ps0fg4DSu3ItV
        /mx+SHET/P3AWFNhTJp3mf62GONle6JI/WUBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1602141666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9Knu4Ep4Kfr7cANVhKoFkLeEDR8oemZsbxSM7NSRHcM=;
        b=AmyE3xFZRrJKUR1axtwJxm8GIgZBqMbyaOPwcvazdM0/Ea7ErRrOpXjR/stn7i05G3kX3o
        dCp1TtbXaEpiFC1W5qvmasiW1X2b9TAUtIjCIu0PEMk0I2aWz8n2wf/kcMoHPLbehC2bl9
        qPkC2Rp5JuCebNPK9QPAIWTzJRJwXHT+t/blX8o93H2eH1m00U1+q4FnesF9avGzbz/9ZV
        VkcPXjeDoheSOah9D2trg17RpWvD9S5w/8KVVXl5c0RXM6RVyaBs1PL7wI8gY7Zvy78Upp
        8o0YB/fvByBoqxIvTsA7p+v0Curae7wg4bcumIt2HnSpZu5ElrU2vh8diiFTEA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id 66DS9MrA3ZW8; Thu,  8 Oct 2020 09:21:04 +0200 (CEST)
Date:   Thu, 8 Oct 2020 09:21:02 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     linux-kernel@vger.kernel.org
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH v2 0/2] add Cellient MPL200 card
Message-ID: <cover.1602140720.git.wilken.gottwalt@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.69 / 15.00 / 15.00
X-Rspamd-Queue-Id: DF053EF7
X-Rspamd-UID: e74cae
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Cellient MPL200 card to usb/qmi_wwan and serial/option. The
serial/option patch got already applied.

Changes v2:
Picked proper subject for qmi_wwan patch, moved the MPL200 device to
the section of the combined devices and changed the comment about the
device to be more precise.

Wilken Gottwalt (2):
  net: usb: qmi_wwan: add Cellient MPL200 card
  usb: serial: option: add Cellient MPL200 card

 drivers/net/usb/qmi_wwan.c  | 1 +
 drivers/usb/serial/option.c | 3 +++
 2 files changed, 4 insertions(+)

-- 
2.28.0

