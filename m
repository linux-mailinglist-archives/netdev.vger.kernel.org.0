Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA061FFB8C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgFRTJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:09:51 -0400
Received: from nautica.notk.org ([91.121.71.147]:34209 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbgFRTJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 15:09:51 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 8B12CC01F; Thu, 18 Jun 2020 21:09:49 +0200 (CEST)
Date:   Thu, 18 Jun 2020 21:09:34 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Alexander Kapshuk <alexander.kapshuk@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: Fix sparse endian warning in trans_fd.c
Message-ID: <20200618190934.GB20699@nautica>
References: <20200618183417.5423-1-alexander.kapshuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200618183417.5423-1-alexander.kapshuk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Kapshuk wrote on Thu, Jun 18, 2020:
> Address sparse endian warning:
> net/9p/trans_fd.c:932:28: warning: incorrect type in assignment (different base types)
> net/9p/trans_fd.c:932:28:    expected restricted __be32 [addressable] [assigned] [usertype] s_addr
> net/9p/trans_fd.c:932:28:    got unsigned long
> 
> Signed-off-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>

INADDR_ANY is 0 so this really is noop but sure, less warnings is always
good. I'll take this one for 5.9.
Thanks!
-- 
Dominique
