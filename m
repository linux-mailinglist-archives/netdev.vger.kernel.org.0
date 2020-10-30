Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56572A11C0
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 00:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgJ3Xqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 19:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJ3Xqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 19:46:42 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71AB9208B6;
        Fri, 30 Oct 2020 23:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604101602;
        bh=voJHJOf9dPBy4fxAMBhVgDxcGEaN2P+DHs0ps8ovIr8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FJdKogOYBw22C9CQ4xTuDRutEHcr9iI1uO1Xg2FQcBhiXnj8qPvB1zNgu2ubo0lP9
         uApQW7c0V58yT78WSf1xtyLLjRXXMgBVYy9FDGQOheiaRghFG1ULAZXCF1iGuk98K5
         iO6RVL9il2esFPCrtTuW1FBfwhTCrOOnWy/5kFcU=
Date:   Fri, 30 Oct 2020 16:46:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv5 net-next 00/16] sctp: Implement RFC6951: UDP
 Encapsulation of SCTP
Message-ID: <20201030164640.4e89902f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 15:04:54 +0800 Xin Long wrote:
>    This patchset is using the udp4/6 tunnel APIs to implement the UDP
>    Encapsulation of SCTP with not much change in SCTP protocol stack
>    and with all current SCTP features keeped in Linux Kernel.
> 
>    1 - 4: Fix some UDP issues that may be triggered by SCTP over UDP.
>    5 - 7: Process incoming UDP encapsulated packets and ICMP packets.
>    8 -10: Remote encap port's update by sysctl, sockopt and packets.
>    11-14: Process outgoing pakects with UDP encapsulated and its GSO.
>    15-16: Add the part from draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.
>       17: Enable this feature.

Applied, thanks!
