Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B1425F558
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgIGIeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:34:13 -0400
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:43704
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726978AbgIGIeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599467646;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=qjbQge4U6UB4BPyAJXyzWFTtAsRQDF/u2IRI9i22/84=;
        b=dvWLPHdhLThXhx1jUbMJqvl+ACzbG5yTnwAwzSuqsQwtaFk7H0PBHYslw3UNwpd3
        mIiuadK+4y/bY5s5+2rjmCTFuWgY5BEPfKSMDjnipCJl4NIkylBCw1TwGkBFp8BM3wb
        ytt529JeCJ73/iLHIy6vvxVFO1PpzEoruoT9ONz0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599467646;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=qjbQge4U6UB4BPyAJXyzWFTtAsRQDF/u2IRI9i22/84=;
        b=nRho5tliqnZnyenfR4hEjLtAhU/c9r7C2fD/r1sWivepQRUAwGjQPKz0ymmYTxUd
        kJk5cSGhC9Xko+9Vo41ti+3nOQGKIllcfzD3DX9cq/tVp8Jc3i/dMK9OT5rfq3C8CSs
        lGf1xlPKsIWA9ShvhiX17RIMY+7tDvCgUluiGV3s=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C862BC3275F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mwifiex: pcie: Fix -Wunused-const-variable warnings
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200902140933.25852-1-yuehaibing@huawei.com>
References: <20200902140933.25852-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <amitkarwar@gmail.com>, <ganapathi.bhat@nxp.com>,
        <huxinming820@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <christophe.jaillet@wanadoo.fr>, <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017467b36bf5-f6201c38-cfe6-43d7-ac35-6d6dc2f33667-000000@us-west-2.amazonses.com>
Date:   Mon, 7 Sep 2020 08:34:05 +0000
X-SES-Outgoing: 2020.09.07-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> These variables only used in pcie.c, move them to .c file
> can silence these warnings:
> 
> In file included from drivers/net/wireless/marvell/mwifiex/main.h:57:0,
>                  from drivers/net/wireless/marvell/mwifiex/init.c:24:
> drivers/net/wireless/marvell/mwifiex/pcie.h:310:41: warning: mwifiex_pcie8997 defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
>                                          ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.h:300:41: warning: mwifiex_pcie8897 defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
>                                          ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.h:292:41: warning: mwifiex_pcie8766 defined but not used [-Wunused-const-variable=]
>  static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
>                                          ^~~~~~~~~~~~~~~~
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Failed to build:

drivers/net/wireless/marvell/mwifiex/pcie.c:191:43: error: redefinition of 'mwifiex_reg_8766'
  191 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
      |                                           ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:36:43: note: previous definition of 'mwifiex_reg_8766' was here
   36 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
      |                                           ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:223:43: error: redefinition of 'mwifiex_reg_8897'
  223 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
      |                                           ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:68:43: note: previous definition of 'mwifiex_reg_8897' was here
   68 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
      |                                           ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:260:43: error: redefinition of 'mwifiex_reg_8997'
  260 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
      |                                           ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:105:43: note: previous definition of 'mwifiex_reg_8997' was here
  105 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
      |                                           ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:297:35: error: redefinition of 'mem_type_mapping_tbl_w8897'
  297 | static struct memory_type_mapping mem_type_mapping_tbl_w8897[] = {
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:142:35: note: previous definition of 'mem_type_mapping_tbl_w8897' was here
  142 | static struct memory_type_mapping mem_type_mapping_tbl_w8897[] = {
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:308:35: error: redefinition of 'mem_type_mapping_tbl_w8997'
  308 | static struct memory_type_mapping mem_type_mapping_tbl_w8997[] = {
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:153:35: note: previous definition of 'mem_type_mapping_tbl_w8997' was here
  153 | static struct memory_type_mapping mem_type_mapping_tbl_w8997[] = {
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:312:41: error: redefinition of 'mwifiex_pcie8766'
  312 | static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
      |                                         ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:157:41: note: previous definition of 'mwifiex_pcie8766' was here
  157 | static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
      |                                         ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:320:41: error: redefinition of 'mwifiex_pcie8897'
  320 | static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
      |                                         ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:165:41: note: previous definition of 'mwifiex_pcie8897' was here
  165 | static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
      |                                         ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:330:41: error: redefinition of 'mwifiex_pcie8997'
  330 | static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
      |                                         ^~~~~~~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c:175:41: note: previous definition of 'mwifiex_pcie8997' was here
  175 | static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
      |                                         ^~~~~~~~~~~~~~~~
make[5]: *** [drivers/net/wireless/marvell/mwifiex/pcie.o] Error 1
make[4]: *** [drivers/net/wireless/marvell/mwifiex] Error 2
make[3]: *** [drivers/net/wireless/marvell] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11750661/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

