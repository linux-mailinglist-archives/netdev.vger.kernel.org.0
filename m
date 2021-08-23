Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFD93F488C
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbhHWKV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:21:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51094 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbhHWKV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 06:21:57 -0400
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4B2B44D0C1073;
        Mon, 23 Aug 2021 03:21:12 -0700 (PDT)
Date:   Mon, 23 Aug 2021 11:20:49 +0100 (BST)
Message-Id: <20210823.112049.2183912961708089551.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     sfr@canb.auug.org.au, netdev@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fbac0963-385d-b593-e087-e1e75f62fcbf@gmail.com>
References: <20210823120929.7c6f7a4f@canb.auug.org.au>
        <fbac0963-385d-b593-e087-e1e75f62fcbf@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 23 Aug 2021 03:21:13 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 23 Aug 2021 08:34:53 +0200

> On 23.08.2021 04:09, Stephen Rothwell wrote:
>> Hi all,
>> 
>> After merging the net-next tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>> 
>> drivers/net/ethernet/broadcom/bnx2.c: In function 'bnx2_read_vpd_fw_ver':
>> drivers/net/ethernet/broadcom/bnx2.c:8055:6: error: implicit declaration of function 'pci_vpd_find_ro_info_keyword'; did you mean 'pci_vpd_find_info_keyword'? [-Werror=implicit-function-declaration]
>>  8055 |  j = pci_vpd_find_ro_info_keyword(data, BNX2_VPD_LEN,
>>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>       |      pci_vpd_find_info_keyword
>> 
>> Caused by commit
>> 
>>   ddc122aac91f ("bnx2: Search VPD with pci_vpd_find_ro_info_keyword()")
>> 
>> I have used the net-next tree from next-20210820 for today.
>> 
> This series was supposed to go through the PCI tree. It builds on recent patches
> that are in the PCI tree, but not in linux-next yet.
> I mentioned this dependency in the cover letter for the last series, but forgot
> it this time. Sorry.

I reverted it all, please don't forget the cover letter like this.

Thanks.
