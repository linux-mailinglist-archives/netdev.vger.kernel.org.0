Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B316065CBCB
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 03:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbjADCMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 21:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbjADCMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 21:12:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151FAFD20
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 18:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9lJ5HFtpzwDcjidMHjiSMXs7IaZBmsElVnmTs6oQarQ=; b=E1OIwnjNlfhxYnltU9FPNzl4zc
        Uew9UIWwmQcz629j/CMqFPINDZlMtJQkIfh2LT6yh++KHjbGyCA7sDS5O5rg9/hn6okh0FpEJPoey
        avP3m1mbilIJYvD7JCgHcYsJ21GnxHyZlk7HW0KDsDEpEShnvtlf9AeYk5qbet8+xp4k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCtGo-00161l-4O; Wed, 04 Jan 2023 03:12:46 +0100
Date:   Wed, 4 Jan 2023 03:12:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hao Lan <lanhao@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, shenjian15@huawei.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: hns3: support debugfs for wake on lan
Message-ID: <Y7TgnhuQkRlFHNDu@lunn.ch>
References: <20230104013405.65433-1-lanhao@huawei.com>
 <20230104013405.65433-3-lanhao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104013405.65433-3-lanhao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 09:34:05AM +0800, Hao Lan wrote:
> Implement debugfs for wake on lan to hns3. The debugfs
> support verify the firmware wake on lan configuration.

Is this actually needed, now you have verified the firmware? I can see
it being a useful development tool, but now the feature is finished,
the firmware is bug free, it is of no real use. Everybody will just
use ethtool.

    Andrew
