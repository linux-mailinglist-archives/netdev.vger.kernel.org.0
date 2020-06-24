Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081FC2079C2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405318AbgFXQ7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404796AbgFXQ7G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 12:59:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E35520738;
        Wed, 24 Jun 2020 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593017945;
        bh=+QLzWa9R9qN9FxhHozL3Pq3dhOGQ4gOItfeEArrS5+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M7EO0Oa2tAuWUQQ4HrLCHt1tVRMpWu9sENgmQJkgSRpaR1MNvt8hmBJyXdLGu/v/q
         Q+TzpCdAF29Jxrl23coDDJ5vKHRN4tq3DgTaU39b/WLtbYXq7U73e1eRAVoy9kMTpr
         vI14CzqT1kRyQw7M9DJXAdVGSSUMxZmFVONa93fQ=
Date:   Wed, 24 Jun 2020 09:59:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Christian Benvenuti (benve)" <benve@cisco.com>
Cc:     Kaige Li <likaige@loongson.cn>, David Miller <davem@davemloft.net>,
        "_govind@gmx.com" <_govind@gmx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lixuefeng@loongson.cn" <lixuefeng@loongson.cn>,
        "yangtiezhu@loongson.cn" <yangtiezhu@loongson.cn>
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
Message-ID: <20200624095903.71a01271@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BYAPR11MB37994715A3DD8259DF16A34DBA950@BYAPR11MB3799.namprd11.prod.outlook.com>
References: <20200623.143311.995885759487352025.davem@davemloft.net>
        <20200623.152626.2206118203643133195.davem@davemloft.net>
        <7533075e-0e8e-2fde-c8fa-72e2ea222176@loongson.cn>
        <20200623.202324.442008830004872069.davem@davemloft.net>
        <70519029-1cfa-5fce-52f3-cfb13bf00f7d@loongson.cn>
        <BYAPR11MB37994715A3DD8259DF16A34DBA950@BYAPR11MB3799.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 06:32:36 +0000 Christian Benvenuti (benve) wrote:
> We/Cisco will also look into it, hopefully a small code reorg will be sufficient.

Make sure you enable CONFIG_DEBUG_ATOMIC_SLEEP when you test.
