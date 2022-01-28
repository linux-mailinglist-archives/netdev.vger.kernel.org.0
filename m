Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2598E49F14A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345542AbiA1CvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241793AbiA1CvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:51:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245A2C061714;
        Thu, 27 Jan 2022 18:51:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7BF9B80D6F;
        Fri, 28 Jan 2022 02:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD43C340E4;
        Fri, 28 Jan 2022 02:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643338267;
        bh=KkNpUcBWJJjaj2uzVWVcPFVFIuFoQ6nIBf/nuJpOQLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ag9qHk+Y4/1X4Zc5u0KcpruCnA80utDujTLQ+jM3TehwqHGzL6tcpohUnRNRscJmN
         JqH7fuTsaXNw/9SARW+kGaVIHKi76rIiXof74ksWD6kmonTP0qgRD9p6vVJZAQAndY
         F3NY4UXzNl/ju3B1etwj+pb7kcDh4yxe1Ko3AgU5yC2MQZ3vZMyi/QEsFQPPX0rfjK
         cn5zeNb+wAo4W8NnAswSCh19hAK2L3nr0iSxxhizTvkvwKCgYxHBgkSpHMkUBO+q2k
         YuCAWcuSyxeIkc6xmwO3WCg7eh+i+X84Tw0zMvMUxB+p0TtWepjWkWGWu7t8Fl/Hxx
         y6jVLdRbQ2xdg==
Date:   Thu, 27 Jan 2022 18:51:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jay.vosburgh@canonical.com,
        nikolay@nvidia.com, huyd12@chinatelecom.cn
Subject: Re: [PATCH v10] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
Message-ID: <20220127185105.5e039b11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128023916.100071-1-sunshouxin@chinatelecom.cn>
References: <20220128023916.100071-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 21:39:16 -0500 Sun Shouxin wrote:
> Since ipv6 neighbor solicitation and advertisement messages
> isn't handled gracefully in bond6 driver, we can see packet
> drop due to inconsistency between mac address in the option
> message and source MAC .
> 
> Another examples is ipv6 neighbor solicitation and advertisement
> messages from VM via tap attached to host bridge, the src mac
> might be changed through balance-alb mode, but it is not synced
> with Link-layer address in the option message.
> 
> The patch implements bond6's tx handle for ipv6 neighbor
> solicitation and advertisement messages.
> 
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>

Did you just resend v10? I commented on this patch a few minutes ago...
and it was also a v10. You can see the status of your patch in
patchwork: https://patchwork.kernel.org/project/netdevbpf/list/
There is no need to repost if the patch is in "active" state like "New"
or "Under Review".
