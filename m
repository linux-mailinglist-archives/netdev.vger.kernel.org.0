Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145DB1DD21F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgEUPj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:39:58 -0400
Received: from verein.lst.de ([213.95.11.211]:55220 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729789AbgEUPj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 11:39:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6EB8168BEB; Thu, 21 May 2020 17:39:55 +0200 (CEST)
Date:   Thu, 21 May 2020 17:39:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Message-ID: <20200521153955.GA19160@lst.de>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com> <20200521153729.GB74252@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521153729.GB74252@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 12:37:29PM -0300, 'Marcelo Ricardo Leitner' wrote:
> On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
> 
> I wish we could split this patch into multiple ones. Like, one for
> each sockopt, but it doesn't seem possible. It's tough to traverse
> trough 5k lines long patch. :-(

I have a series locally that started this, I an try to resurrect and
finish it.
