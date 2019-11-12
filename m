Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15852F9937
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfKLS7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:59:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47826 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfKLS7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:59:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1B98154CC658;
        Tue, 12 Nov 2019 10:58:59 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:58:59 -0800 (PST)
Message-Id: <20191112.105859.2271759135957958056.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     po.liu@nxp.com, claudiu.manoil@nxp.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com
Subject: Re: [net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112094128.mbfil74gfdnkxigh@netronome.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
        <20191112094128.mbfil74gfdnkxigh@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 10:59:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Oops, I didn't see this feedback because v2 had been posted.

I'll revert that now.

Please address Simon's feedback on these two patches, and then post a v3,
thank you.
