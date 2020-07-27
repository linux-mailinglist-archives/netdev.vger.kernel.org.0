Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283C122E6A4
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 09:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgG0Hem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 03:34:42 -0400
Received: from verein.lst.de ([213.95.11.211]:42344 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgG0Hem (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 03:34:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C06C368C4E; Mon, 27 Jul 2020 09:34:39 +0200 (CEST)
Date:   Mon, 27 Jul 2020 09:34:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        hch@lst.de, mlxsw@mellanox.com
Subject: Re: [PATCH net-next] ipmr: Copy option to correct variable
Message-ID: <20200727073439.GA3917@lst.de>
References: <20200727071834.1651232-1-idosch@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727071834.1651232-1-idosch@mellanox.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good, thanks for catching it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
