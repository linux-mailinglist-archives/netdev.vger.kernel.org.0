Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8D224FD99
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 14:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHXMRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 08:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgHXMRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 08:17:39 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F69CC061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 05:17:39 -0700 (PDT)
Received: from [2605:a601:a627:ca00:664d:4b4b:674f:5257] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1kABPW-00008j-2S; Mon, 24 Aug 2020 08:17:15 -0400
Date:   Mon, 24 Aug 2020 08:17:08 -0400
From:   Neil Horman <nhorman@localhost.localdomain>
To:     David Miller <davem@davemloft.net>
Cc:     herbert@gondor.apana.org.au, kuba@kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCH] net: Get rid of consume_skb when tracing is off
Message-ID: <20200824121708.GA370971@localhost.localdomain>
References: <20200821222329.GA2633@gondor.apana.org.au>
 <20200822175419.GA293438@localhost.localdomain>
 <20200822.124902.1531691234014991272.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822.124902.1531691234014991272.davem@davemloft.net>
X-Spam-Score: -1.8 (-)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 12:49:02PM -0700, David Miller wrote:
> 
> From: Neil Horman <nhorman@localhost.localdomain>
> 
> Neil, you might want to fix this so people can reply to you :-)
Crap, thanks, new computer.

Neil

> 
