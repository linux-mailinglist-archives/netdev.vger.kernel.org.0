Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357BB46C40F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 20:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbhLGUBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 15:01:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhLGUBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 15:01:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D5B8B81858;
        Tue,  7 Dec 2021 19:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE3EC341C1;
        Tue,  7 Dec 2021 19:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638907056;
        bh=sdcQe7SwlYa/WQI8IteJ54XCiFefZJvcMYEC1Iitqfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vK0jiqvcErIgWEOtfVOWgs7KNubso5YXBlhRSybNc/I4nAn8SD9lTnFWovCT50y4x
         rcW+O6cX03ujcu3MjfBIXZt7BL7xkABxsCeW3dULImOHuTcaLccxXTWgXR4Vx3MXm4
         YdaeeKZpgSrq/9Fsba/0DpwiDJjvzc/AvkhirqhYAIBf8D7wObyzhC91FI9LX5/r8i
         7O6RdWzw9i3oi+1067eZCJf3iIqeidnY07/hXb3I9cS85KFTcTeXf8sc30FqpJjNtL
         EN6wpKf0fVuGF6AP/q3gUVxK5yTYKjw3p69bmB7MmfK13FJ00DtwZavhUY+tF1fn8U
         pHC8k5KrX1lhA==
Date:   Tue, 7 Dec 2021 11:57:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, wells.lu@sunplus.com,
        vincent.shih@sunplus.com
Subject: Re: [PATCH net-next v4 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <20211207115735.4d665759@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1638864419-17501-3-git-send-email-wellslutw@gmail.com>
References: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
        <1638864419-17501-3-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 16:06:59 +0800 Wells Lu wrote:
> Add driver for Sunplus SP7021 SoC.
> 
> Signed-off-by: Wells Lu <wellslutw@gmail.com>

clang points out:

drivers/net/ethernet/sunplus/spl2sw_driver.c:223:65: warning: result of comparison of constant 188 with expression of type 'char' is always true [-Wtautological-constant-out-of-range-compare]
            (mac_addr[0] != 0xFC || mac_addr[1] != 0x4B || mac_addr[2] != 0xBC)) {
                                                           ~~~~~~~~~~~ ^  ~~~~
drivers/net/ethernet/sunplus/spl2sw_driver.c:223:19: warning: result of comparison of constant 252 with expression of type 'char' is always true [-Wtautological-constant-out-of-range-compare]
            (mac_addr[0] != 0xFC || mac_addr[1] != 0x4B || mac_addr[2] != 0xBC)) {
             ~~~~~~~~~~~ ^  ~~~~
drivers/net/ethernet/sunplus/spl2sw_driver.c:222:64: warning: result of comparison of constant 188 with expression of type 'char' is always false [-Wtautological-constant-out-of-range-compare]
        if (mac_addr[5] == 0xFC && mac_addr[4] == 0x4B && mac_addr[3] == 0xBC &&
                                                          ~~~~~~~~~~~ ^  ~~~~
drivers/net/ethernet/sunplus/spl2sw_driver.c:222:18: warning: result of comparison of constant 252 with expression of type 'char' is always false [-Wtautological-constant-out-of-range-compare]
        if (mac_addr[5] == 0xFC && mac_addr[4] == 0x4B && mac_addr[3] == 0xBC &&
            ~~~~~~~~~~~ ^  ~~~~
