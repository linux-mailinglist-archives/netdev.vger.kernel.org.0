Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D693ADAC1
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhFSPza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 11:55:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15982 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234665AbhFSPz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Jun 2021 11:55:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624117998; h=Date: Message-Id: Cc: To: Subject: From:
 Content-Transfer-Encoding: MIME-Version: Content-Type: Sender;
 bh=ed6e2KMRxnZvSNW68Wr+dv8wBm1YAzNNe2MwzSu/rh4=; b=goIIaO+rjA8cXZws/iK+tbFiqQcGcoY2GU5d+BAcATedNnLZtCvnvb5xTAIAaF9V96GNT0KD
 rU+03sN2S101d/FY67oHmHhyYNF1yuLvFkuxLnni9W87ixs4po9lnI6lZkupYZ2Fab7+j5wA
 LkY9GImqSyCByO8zxkRKT0g0a6c=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60ce12e5abfd22a3dcf19b89 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Jun 2021 15:53:09
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 68798C433D3; Sat, 19 Jun 2021 15:53:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6EC86C433F1;
        Sat, 19 Jun 2021 15:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6EC86C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2021-06-19
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20210619155308.68798C433D3@smtp.codeaurora.org>
Date:   Sat, 19 Jun 2021 15:53:08 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit d4826d17b3931cf0d8351d8f614332dd4b71efc4:

  mt76: mt7921: remove leftover 80+80 HE capability (2021-05-30 22:11:24 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-06-19

for you to fetch changes up to 1f9482aa8d412b4ba06ce6ab8e333fb8ca29a06e:

  mwifiex: bring down link before deleting interface (2021-06-11 13:02:27 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.13

Only one important fix for an mwifiex regression.

mwifiex

* fix deadlock during rmmod or firmware reset, regression from
  cfg80211 RTNL changes in v5.12-rc1

----------------------------------------------------------------
Brian Norris (1):
      mwifiex: bring down link before deleting interface

 drivers/net/wireless/marvell/mwifiex/main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)
