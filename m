Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E8E1F7E3
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 17:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbfEOPmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 11:42:09 -0400
Received: from nautica.notk.org ([91.121.71.147]:46851 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbfEOPmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 11:42:08 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 5AFDDC009; Wed, 15 May 2019 17:42:07 +0200 (CEST)
Date:   Wed, 15 May 2019 17:41:52 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, ericvh@gmail.com, lucho@ionkov.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH -next] 9p/xen: Add cleanup path in p9_trans_xen_init
Message-ID: <20190515154152.GA29826@nautica>
References: <20190430143933.19368-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190430143933.19368-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing wrote on Tue, Apr 30, 2019:
> If xenbus_register_frontend() fails in p9_trans_xen_init,
> we should call v9fs_unregister_trans() to do cleanup.
> 
> Fixes: 868eb122739a ("xen/9pfs: introduce Xen 9pfs transport driver")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks, queued both in my repo - sorry for the delay.

-- 
Dominique
