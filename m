Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C04495E33
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 12:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380099AbiAULJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 06:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380113AbiAULJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 06:09:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0198EC06173F;
        Fri, 21 Jan 2022 03:09:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51804CE21AB;
        Fri, 21 Jan 2022 11:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CFAC340E1;
        Fri, 21 Jan 2022 11:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642763373;
        bh=38atemaJ6sB1gy9DysKxkvzhs+mMmeHYgaWObDWQFnA=;
        h=From:Subject:To:Cc:Date:From;
        b=Ecb0N4sLp+60U+Amt776+OzGb2oJA3RhHWpq72zA+izyHcxHwZDar7w/4t0sbdjVZ
         Z5nG8lxW4VKD0Om6CuCfybHUl8FlGBgWlZOrmlXJ3GH/bQKrp2wf44v/RE3dkOL24w
         pcJlQCudYFsqRGCQvOiaREAjlVBGrLd6MVjkfUziL8obOMcahG9IHZYPGdPOWy2Aax
         NpDxOwVXt4QNDlJealAqG5YiwfoBJabWHsI5yAXETbk64dU3hojR4qtgzmSipUQrXN
         fPzAEZLXmNl+v7ck7I8BsuwFFQ7erA5j73+DQLEwDBYwptgUAF4CKut9Tn9HoZyeeO
         OJ5BHGFplZdwA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-2022-01-21
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20220121110933.15CFAC340E1@smtp.kernel.org>
Date:   Fri, 21 Jan 2022 11:09:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit fb80445c438c78b40b547d12b8d56596ce4ccfeb:

  net_sched: restore "mpu xxx" handling (2022-01-13 11:06:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-01-21

for you to fetch changes up to a1222ca0681f1db3696d703aa8df61c8b41a61ac:

  MAINTAINERS: remove extra wireless section (2022-01-19 10:05:07 +0200)

----------------------------------------------------------------
wireless fixes for v5.17

First set of fixes for v5.17. This is the first pull request from the
new wireless tree and only changes to MAINTAINERS file.

----------------------------------------------------------------
Kalle Valo (2):
      MAINTAINERS: add common wireless and wireless-next trees
      MAINTAINERS: remove extra wireless section

 MAINTAINERS | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)
