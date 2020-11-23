Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41FD2C011D
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgKWIGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 03:06:38 -0500
Received: from verein.lst.de ([213.95.11.211]:48920 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbgKWIGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 03:06:38 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 76A5E68AFE; Mon, 23 Nov 2020 09:06:35 +0100 (CET)
Date:   Mon, 23 Nov 2020 09:06:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, hch@lst.de,
        arnd@arndb.de
Subject: Re: [PATCH net-next v2] compat: always include linux/compat.h from
 net/compat.h
Message-ID: <20201123080635.GA7046@lst.de>
References: <20201121214844.1488283-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121214844.1488283-1-kuba@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
