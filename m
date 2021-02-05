Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11A43107F3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 10:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhBEJeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 04:34:24 -0500
Received: from verein.lst.de ([213.95.11.211]:59597 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhBEJbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 04:31:55 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id CC72968AFE; Fri,  5 Feb 2021 10:31:12 +0100 (CET)
Date:   Fri, 5 Feb 2021 10:31:12 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu
 archs w/o dma cache snooping
Message-ID: <20210205093112.GC870@lst.de>
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-2-TheSven73@gmail.com> <20210204060210.2362-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204060210.2362-1-hdanton@sina.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a pattern we've seen in a few other net driver, so we should
be ok.  It just is rather hairy and needs a good justification, which
seems to be given here.
