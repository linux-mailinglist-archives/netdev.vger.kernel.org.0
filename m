Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFA02846CB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 09:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgJFHHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 03:07:52 -0400
Received: from verein.lst.de ([213.95.11.211]:33260 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgJFHHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 03:07:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4B4C667373; Tue,  6 Oct 2020 09:07:49 +0200 (CEST)
Date:   Tue, 6 Oct 2020 09:07:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, viro@zeniv.linux.org.uk, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] fs: remove ->sendpage
Message-ID: <20201006070749.GA7713@lst.de>
References: <20200926070049.11513-1-hch@lst.de> <20200928.151734.25122613961401605.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928.151734.25122613961401605.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 03:17:34PM -0700, David Miller wrote:
> From: Christoph Hellwig <hch@lst.de>
> Date: Sat, 26 Sep 2020 09:00:49 +0200
> 
> > ->sendpage is only called from generic_splice_sendpage.  The only user of
> > generic_splice_sendpage is socket_file_ops, which is also the only
> > instance that actually implements ->sendpage.  Remove the ->sendpage file
> > operation and just open code the logic in the socket code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Al, can you pick this up?  Or give your ACK so that Dave can pick it up?
