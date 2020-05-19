Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80BA1D9176
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgESHxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:53:44 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:40164 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726943AbgESHxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:53:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589874823; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=Jn5kEp5C6wqJZJXYscr+MdqvrxFZlynEmyXeR1RAOiw=; b=ghliDE4EoKoRKPa4XayPua98MrA8puOVq+ILYKC8wvnct29QLtImYsi32MrdPnOgsP6tUwEk
 91Bt1X+piohDEcgOKuXp9TH9WokzxlF1O8jsUAM4GaCHCol93LO7Rti02hyMWa1kmwm/7Fa2
 tYv2OD5C22XmtbiMqcAsNl8VgoI=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ec3907b.7fb2ee573928-smtp-out-n04;
 Tue, 19 May 2020 07:53:31 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0652AC432C2; Tue, 19 May 2020 07:53:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0D2E3C433F2;
        Tue, 19 May 2020 07:53:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0D2E3C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-05-19
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20200519075331.0652AC432C2@smtp.codeaurora.org>
Date:   Tue, 19 May 2020 07:53:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 0e698dfa282211e414076f9dc7e83c1c288314fd:

  Linux 5.7-rc4 (2020-05-03 14:56:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-05-19

for you to fetch changes up to f92f26f2ed2c9f92c9270c705bca96310c3cdf5a:

  iwlwifi: pcie: handle QuZ configs with killer NICs as well (2020-05-08 13:09:17 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.7

Third and most likely the last set of fixes for v5.7. Only one
iwlwifi fix this time.

iwlwifi

* another fix for QuZ device configuration

----------------------------------------------------------------
Luca Coelho (1):
      iwlwifi: pcie: handle QuZ configs with killer NICs as well

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 4 ++++
 1 file changed, 4 insertions(+)
