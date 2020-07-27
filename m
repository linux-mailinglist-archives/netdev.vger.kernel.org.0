Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D123A22E536
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 07:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgG0FW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 01:22:28 -0400
Received: from verein.lst.de ([213.95.11.211]:41960 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgG0FW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 01:22:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E3CCF68B05; Mon, 27 Jul 2020 07:22:24 +0200 (CEST)
Date:   Mon, 27 Jul 2020 07:22:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: build failure after merge of the bluetooth tree
Message-ID: <20200727052224.GA933@lst.de>
References: <20200727134433.1c4ea34e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727134433.1c4ea34e@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fixup looks good to me, thanks.
