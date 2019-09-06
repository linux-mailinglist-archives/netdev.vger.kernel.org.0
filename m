Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D061AB729
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388874AbfIFLb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732984AbfIFLb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 07:31:26 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B45BF2070C;
        Fri,  6 Sep 2019 11:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567769485;
        bh=iogpGBQG7jXWKjVA6uZiFSlDPTuY7gAzoeRO+2zCtHs=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=yd935ui4dpymxpEuwbJ9LbamdQt/qCxtr11s6AswOEey2QNt0zao+eKe1PGz31BI9
         qaxLcPg2RwxbttqksqxBVWxamHtR6qlHLzyA6E84hTviaChQOWijY1jvQWb62xfDQE
         RXUaBanQkhqp0kgzGLXNcniuXFSNNufTqL3iRwQM=
Date:   Fri, 6 Sep 2019 13:31:06 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Dan Elkouby <streetwalkermc@gmail.com>
cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brian Norris <computersforpeace@gmail.com>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: hidp: Fix assumptions on the return value of
 hidp_send_message
In-Reply-To: <20190906110645.27601-1-streetwalkermc@gmail.com>
Message-ID: <nycvar.YFH.7.76.1909061330390.31470@cbobk.fhfr.pm>
References: <20190906101306.GA12017@kadam> <20190906110645.27601-1-streetwalkermc@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Sep 2019, Dan Elkouby wrote:

> hidp_send_message was changed to return non-zero values on success,
> which some other bits did not expect. This caused spurious errors to be
> propagated through the stack, breaking some drivers, such as hid-sony
> for the Dualshock 4 in Bluetooth mode.
> 
> As pointed out by Dan Carpenter, hid-microsoft directly relied on that
> assumption as well.
> 
> Fixes: 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return number of queued bytes")
> 
> Signed-off-by: Dan Elkouby <streetwalkermc@gmail.com>

Reviewed-by: Jiri Kosina <jkosina@suse.cz>

Marcel, are you taking this through your tree?

Thanks,

-- 
Jiri Kosina
SUSE Labs

