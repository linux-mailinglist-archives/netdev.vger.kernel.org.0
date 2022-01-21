Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2D496247
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 16:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381651AbiAUPqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 10:46:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56974 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbiAUPqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 10:46:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36026B82057;
        Fri, 21 Jan 2022 15:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8A4C340E1;
        Fri, 21 Jan 2022 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642779961;
        bh=AZyzRl3enQq/hMjoqNXM2BKam7UG9uwakJtr82lyyIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ChD+AgVQXvDZ+TKmbEUxUMiXblV0bwOwek5Vr6NndB/icI41FQJeXU/agFQykm0Cc
         erVAK2t3AAB+i5T2fHW1CLxmIZxJ/7Hx8WqxFG+x5f97snt4BMpqLvfgh4THozvpQp
         lJf/IEHX7+0kpTuN+kXx8Scz8UXS3MnlT3w8gBo8Jhuz8BbpZMIy03j6FfI+AZ76Xm
         oCqyoB8fYsb/w4GFVgPqYSR10Qv4zROJ/GnXcBfVkq8KbZovwqT+vt6aZRVWkBN8YS
         Noz5bcowLqHNNqtwzM9BB4xFUEXLTBznhCe4hYsRUcW6gB2f7SKhWzJ2UDTqJd//dt
         esJLoptvw1kbQ==
Date:   Fri, 21 Jan 2022 07:46:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v6] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
Message-ID: <20220121074600.174deb15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <661de9e7-216d-dfd1-afdc-3c58a88739c3@chinatelecom.cn>
References: <20220118073317.82968-1-sunshouxin@chinatelecom.cn>
        <29469.1642746326@famine>
        <661de9e7-216d-dfd1-afdc-3c58a88739c3@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jan 2022 14:38:03 +0800 =E5=AD=99=E5=AE=88=E9=91=AB wrote:
> Thanks your comment, I'll adjust it and send out V7 soon.

Next week, please, net-next is closed until 5.17-rc1 is released.
