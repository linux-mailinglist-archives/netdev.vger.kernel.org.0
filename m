Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5FC151A01
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 12:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgBDLjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 06:39:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgBDLjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 06:39:42 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D331133E904C;
        Tue,  4 Feb 2020 03:39:41 -0800 (PST)
Date:   Tue, 04 Feb 2020 12:39:40 +0100 (CET)
Message-Id: <20200204.123940.1811238158618411613.davem@davemloft.net>
To:     ridge.kennedy@alliedtelesis.co.nz
Cc:     netdev@vger.kernel.org, gnault@redhat.com, tparkin@katalix.com,
        jchapman@katalix.com
Subject: Re: [PATCH v2 net] l2tp: Allow duplicate session creation with UDP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200203232400.28981-1-ridge.kennedy@alliedtelesis.co.nz>
References: <20200203232400.28981-1-ridge.kennedy@alliedtelesis.co.nz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 03:39:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
Date: Tue,  4 Feb 2020 12:24:00 +1300

> In the past it was possible to create multiple L2TPv3 sessions with the
> same session id as long as the sessions belonged to different tunnels.
> The resulting sessions had issues when used with IP encapsulated tunnels,
> but worked fine with UDP encapsulated ones. Some applications began to
> rely on this behaviour to avoid having to negotiate unique session ids.
> 
> Some time ago a change was made to require session ids to be unique across
> all tunnels, breaking the applications making use of this "feature".
> 
> This change relaxes the duplicate session id check to allow duplicates
> if both of the colliding sessions belong to UDP encapsulated tunnels.
> 
> Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
> Signed-off-by: Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>

Applied and queued up for -stable, thank you.
