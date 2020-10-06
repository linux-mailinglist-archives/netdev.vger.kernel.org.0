Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E3028453D
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 07:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgJFFNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 01:13:04 -0400
Received: from verein.lst.de ([213.95.11.211]:33011 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJFFNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 01:13:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 992ED6736F; Tue,  6 Oct 2020 07:13:01 +0200 (CEST)
Date:   Tue, 6 Oct 2020 07:13:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20201006051301.GA5917@lst.de>
References: <20201006145847.14093e47@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006145847.14093e47@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 02:58:47PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

It actually doesn't need that or the two other internal headers.
Bjoern has a fixed, and it was supposed to be queued up according to
patchwork.
