Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826521D06D7
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgEMGEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:04:01 -0400
Received: from verein.lst.de ([213.95.11.211]:44347 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbgEMGEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 02:04:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 79DD868CEC; Wed, 13 May 2020 08:03:58 +0200 (CEST)
Date:   Wed, 13 May 2020 08:03:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: add a CMSG_USER_DATA macro
Message-ID: <20200513060357.GA23760@lst.de>
References: <20200511115913.1420836-1-hch@lst.de> <20200511115913.1420836-2-hch@lst.de> <f754c4ac-db7d-6688-5582-2a5f476b0f08@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f754c4ac-db7d-6688-5582-2a5f476b0f08@cogentembedded.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 11:28:08AM +0300, Sergei Shtylyov wrote:
>    Perhaps it's time to add missing spaces consistently, not just one that 
> you added?

That is all fixed up in the next patch.
