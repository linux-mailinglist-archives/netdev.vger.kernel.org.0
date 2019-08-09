Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0B786F2C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405283AbfHIBNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:13:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405145AbfHIBNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:13:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7494514284358;
        Thu,  8 Aug 2019 18:13:50 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:13:50 -0700 (PDT)
Message-Id: <20190808.181350.1331633709956960086.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     netdev@vger.kernel.org, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, kys@microsoft.com,
        mikelley@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, vkuznets@redhat.com,
        marcelo.cerri@canonical.com
Subject: Re: [PATCH net] hv_netvsc: Fix a warning of suspicious RCU usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <PU1P153MB0169AECABF6094A3E7BEE381BFD50@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169AECABF6094A3E7BEE381BFD50@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:13:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Tue, 6 Aug 2019 05:17:44 +0000

> 
> This fixes a warning of "suspicious rcu_dereference_check() usage"
> when nload runs.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Please resend with appropriate fixes tag.
