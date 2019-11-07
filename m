Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04844F27E2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 08:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKGHIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 02:08:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbfKGHIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 02:08:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE31121D6C;
        Thu,  7 Nov 2019 07:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573110498;
        bh=/22K0nyrckt0PgaKJJNo3D0pTj0Q3WAWzXBI8tW+1bo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zZpwGuBIzmqL0tTcci8YBd4yqs4EvMfPhg23YFPmYSoahc6OdYNqa9+/JDpxO1QST
         wjzsdZlNhcSj7IAKNk/SCeTs0mzyDVp/GSqVEzXNnx1FBiqLlb+dlPzM/xEzVt93r+
         AsfB4hWw4YDR1wsJsCO/gFXp9kp3pctdevJqDCIg=
Date:   Thu, 7 Nov 2019 08:08:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Jonathan Berger <jonathann1@walla.com>,
        Amit Klein <aksecurity@gmail.com>,
        Benny Pinkas <benny@pinkas.net>,
        Tom Herbert <tom@herbertland.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4.9-stable] net/flow_dissector: switch to siphash
Message-ID: <20191107070807.GA1116383@kroah.com>
References: <20191107040930.31289-1-maheshb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107040930.31289-1-maheshb@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 08:09:30PM -0800, Mahesh Bandewar wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 55667441c84fa5e0911a0aac44fb059c15ba6da2 ]

Thanks for this, and the other backports, I've queued them all up now.

greg k-h
