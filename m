Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7E838B36E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhETPpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:45:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:37916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231556AbhETPpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:45:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0587CAB7C;
        Thu, 20 May 2021 15:44:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1B28660458; Thu, 20 May 2021 17:44:18 +0200 (CEST)
Date:   Thu, 20 May 2021 17:44:18 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, idosch@idosch.org
Subject: Re: [PACTH ethtool-next v3 0/7] ethtool: support FEC and standard
 stats
Message-ID: <20210520154418.l3bwpdmizgab7fgm@lion.mk-sys.cz>
References: <20210503160830.555241-1-kuba@kernel.org>
 <20210518154214.22060227@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518154214.22060227@kicinski-fedora-PC1C0HJN>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 03:42:14PM -0700, Jakub Kicinski wrote:
> On Mon,  3 May 2021 09:08:23 -0700 Jakub Kicinski wrote:
> > This series adds support for FEC requests via netlink
> > and new "standard" stats.
> 
> Anything I can do to help with those? They disappeared from 
> patchwork due to auto archiving being set to 2 weeks.

Sorry for the delay, the series is applied now (with one additional
commit masking spurious "make check" failure).

Michal
