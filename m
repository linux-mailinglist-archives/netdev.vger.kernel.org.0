Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AF93E7BCF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242678AbhHJPMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237554AbhHJPMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 11:12:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F69606A5;
        Tue, 10 Aug 2021 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628608337;
        bh=RI9zEwDwVfZBbMJzkE6YhhEmRfIpMxbUxQphymANJOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mbWk8+ZMWBIN+VI1Rk6fhQP+i+d9PvWT361buwJPsBdjniusSxs3yzPXJbe49PsY1
         KppXXCQlS2HQrFTVuSIPo40psC1hpzU0Wqb/u7jw5w77m9muaq93SZZoGgqbRTIZCi
         aPxRf3fQKPe7exUP61xrNnanBKJu2KNSJKjSdW6HAPgL6hqjosyvkjXECpoOQDlDJv
         yAIly9lus8FJ7/ZoSYT/+g+9yZyl8Vi7hNhsp8l0ipY4gifQM/D7rZpvyBXMxFr+pm
         RPAkABG0G1TuisCg0xJEPxMNBGCpTviDandEZ3XciaISyjoAF09q8ecyPgRCEaeBq1
         AQQnj8Z1OfiRQ==
Date:   Tue, 10 Aug 2021 08:12:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bui Quang Minh <minhquangbui99@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        willemb@google.com, pabeni@redhat.com, avagin@gmail.com,
        alexander@mihalicyn.com, lesedorucalin01@gmail.com
Subject: Re: [PATCH 0/2] UDP socket repair
Message-ID: <20210810081215.2f6ce865@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810144357.40367-1-minhquangbui99@gmail.com>
References: <20210810144357.40367-1-minhquangbui99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 21:43:57 +0700 Bui Quang Minh wrote:
> This series implement UDP_REPAIR sockoption for dumping the corked packet
> in UDP socket's send queue. A new path is added to recvmsg() for dumping
> packet's data and msg_name related information of the packet.

The second patch does not apply to net-next, please rebase.
