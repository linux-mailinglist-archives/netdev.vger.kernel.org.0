Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E868339A03
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhCLXar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:30:47 -0500
Received: from z11.mailgun.us ([104.130.96.11]:27215 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235843AbhCLXaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:30:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615591821; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=RMD+sdR7UNbpBfYXm9TwgVxtwXiYml+L0JRH4oUtlj4=;
 b=bz4zM9eRMGE5LnXyC1qKPHtdLEjUDMLEo1MjzlYYGpn7ZJvXpgGxNtZZLgdXGwj87cG0q45w
 Xwkkqt3t03wGi/GeTPUEKTVErXyYx6z6twBWUssatLO2RU8R1hkdmopfZYcjZoF5F4FZXvK7
 df/6ioK0WuQRlw4CFCqwl+vpJaQ=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 604bf97be2200c0a0d2e9e34 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Mar 2021 23:30:03
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6CC46C43464; Fri, 12 Mar 2021 23:30:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C51CFC433CA;
        Fri, 12 Mar 2021 23:30:01 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Mar 2021 16:30:01 -0700
From:   subashab@codeaurora.org
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipv6: addrconf: Add accept_ra_prefix_route.
In-Reply-To: <53896877-38b9-ec01-1c00-28dcc381aec7@gmail.com>
References: <1615402193-12122-1-git-send-email-subashab@codeaurora.org>
 <d7bb2c1d-1e9a-5191-96bd-c3d567df2da1@gmail.com>
 <cbcfa6d3c4fa057051bbee6851e9d4e7@codeaurora.org>
 <b15ef2166740ad67c7685aaed27b5534@codeaurora.org>
 <53896877-38b9-ec01-1c00-28dcc381aec7@gmail.com>
Message-ID: <8f5336e9ac457cd1fd6c16aa74654520@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> sysctl's are not free and in this case you want to add a second one to
> pick and choose which data in the message you want the kernel to act 
> on.
> 
> Why can't the userspace daemon remove the route and add the one it
> prefers? Or add another route with a metric that makes it the preferred
> route making the kernel one effectively moot?

As I recall, kernel was adding back the prefix based route when it is
deleted by userspace. I'll check this again to confirm the behavior
and also try installing the routes with lower metric.
