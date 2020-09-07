Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0E7260115
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbgIGQ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731111AbgIGQ6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:58:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07539208C7;
        Mon,  7 Sep 2020 16:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599497895;
        bh=MYO0ocqL177pD9T2SM/Y0z8hvwkCV1gZTN5xWCsrgpM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KUgueSDhiiRntTd0ENg/m78fE/CDHQ0y7fRWTCnrQmXUvZ1nkbr5JfzCVWEy7BB+x
         yemfpM02jtR5eU9DLmtk0x4VW8fQ4ADucaA8kX5QJXbLyx7Ue21QDJlmApiKfEaoao
         TKOCnZPlZWLm80w6hlgZ0FM8r5aZsJkaRMbpRNkQ=
Date:   Mon, 7 Sep 2020 09:58:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH for-next] net: provide __sys_shutdown_sock() that takes
 a socket
Message-ID: <20200907095813.4cdacb5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <378cfa5a-eb06-d04c-bbbc-07b377f60c11@kernel.dk>
References: <d3973f5b-2d86-665d-a5f3-95d017f9c79f@kernel.dk>
        <20200907054836.GA8956@infradead.org>
        <378cfa5a-eb06-d04c-bbbc-07b377f60c11@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 10:45:00 -0600 Jens Axboe wrote:
> On 9/6/20 11:48 PM, Christoph Hellwig wrote:
> > On Sat, Sep 05, 2020 at 04:05:48PM -0600, Jens Axboe wrote:  
> >> There's a trivial io_uring patch that depends on this one. If this one
> >> is acceptable to you, I'd like to queue it up in the io_uring branch for
> >> 5.10.  
> > 
> > Can you give it a better name?  These __ names re just horrible.
> > sock_shutdown_sock?  
> 
> Sure, I don't really care, just following what is mostly done already. And
> it is meant to be internal in the sense that it's not exported to modules.
> 
> I'll let the net guys pass the final judgement on that, I'm obviously fine
> with anything in terms of naming :-)

So am I :) But if Christoph prefers sock_shutdown_sock() let's use that.
