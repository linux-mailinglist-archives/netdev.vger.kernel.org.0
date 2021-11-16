Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236EF453324
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbhKPNtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhKPNtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 08:49:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C11BB61B48;
        Tue, 16 Nov 2021 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637070399;
        bh=EgQplENZaeOvhDzRFGaIFPHsohxrN9W/R5malDha0bI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EpAedvKvM/MRQIel4JHZjIXYJ19mx55lI4myurnteF9NPrinVp/h9kIs4QhWz7lIC
         IwvYpirxBdMyFDArF7z2nTNSzUPgk43cD/4csTqaUdQiCxIH0Tk+oojhrsNGRn6t/w
         gs1EvOaGWzR/0vilSOe5oI7iI5l0P34+Cfb8znUsSgOplFWy5wR5UgkiVeop27nSDQ
         Ch/g4ilNXlXaOScKOiG4QH7VTUFpsToCMCES5vKgT3K2FK8Pae4EbZh++2VGY6L5nz
         WBfnsRjALMTmV4xZd8miftocnXQB72ikAKlvbG8vR1HzNBcAX8SLspFkVwnAO4+8kL
         mY7VRWqujmkDw==
Date:   Tue, 16 Nov 2021 05:46:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [PATCH V6 net-next 0/6] ethtool: add support to set/get tx
 copybreak buf size and rx buf len
Message-ID: <20211116054637.22ba87c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2fdf21c4-57f9-0a51-a598-c5494aeae6a6@huawei.com>
References: <20211102134613.30367-1-huangguangbin2@huawei.com>
        <2fdf21c4-57f9-0a51-a598-c5494aeae6a6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 10:29:05 +0800 huangguangbin (A) wrote:
> Gentle ping.
> Are there any suggestions for this series?

You posted it during the merge window when net-next was closed:

https://www.kernel.org/doc/html/v5.12/networking/netdev-FAQ.html#how-often-do-changes-from-these-trees-make-it-to-the-mainline-linus-tree

Please repost.
