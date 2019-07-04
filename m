Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECAE65F41F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfGDHu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:50:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfGDHu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 03:50:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1650430832C3;
        Thu,  4 Jul 2019 07:50:56 +0000 (UTC)
Received: from localhost (ovpn-204-226.brq.redhat.com [10.40.204.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21D8D86BB0;
        Thu,  4 Jul 2019 07:50:52 +0000 (UTC)
Date:   Thu, 4 Jul 2019 09:50:52 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: no need to check return value of
 debugfs_create functions
Message-ID: <20190704075051.GB25102@redhat.com>
References: <20190703065631.GA28822@kroah.com>
 <20190703113956.GA26652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703113956.GA26652@kroah.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 04 Jul 2019 07:50:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 01:39:56PM +0200, Greg Kroah-Hartman wrote:
> 
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Because we don't need to save the individual debugfs files and
> directories, remove the local storage of them and just remove the entire
> debugfs directory in a single call, making things a lot simpler.
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
