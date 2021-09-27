Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CB5419427
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhI0MZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhI0MZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:25:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17E31611C2;
        Mon, 27 Sep 2021 12:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632745404;
        bh=e7FROqavQ7dnOGNFcI5puSlAzy7Plgqu6j3qd280Lm0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Q35H/tneArvICPVjugljhefvBAGZvyMvPRiMaaKUv38wZ1oq+NI3YvMSWjEk3Cv8
         AM2p2jd4oD49hm6cPeW33jpyxQayzpJOJ+4OcnVi1or/nU+s5cHnyZRElJGZTRE3bd
         PrJpXmZSCwJhYw44VLpq8Sc8MljC+KCgnpgr1rd8=
Date:   Mon, 27 Sep 2021 14:23:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Qiumiao Zhang <zhangqiumiao1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        netdev@vger.kernel.org, yanan@huawei.com, rose.chen@huawei.com
Subject: Re: [PATCH stable 4.19 0/4] tcp: fix the timeout value calculated by
 tcp_model_timeout() is not accurate
Message-ID: <YVG3undFg5IjzTGV@kroah.com>
References: <20210926071842.1429-1-zhangqiumiao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926071842.1429-1-zhangqiumiao1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 26, 2021 at 03:18:38PM +0800, Qiumiao Zhang wrote:
> This patch series is present in v5.15 and fixes the problem that the
> timeout value calculated by tcp_model_timeout() is not accurate.

5.15 is not yet released :)

These are all in 5.1 and 5.4 and newer...

Anyway, I've queued them all up now, thanks.

greg k-h
