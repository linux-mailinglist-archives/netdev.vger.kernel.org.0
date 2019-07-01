Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978F65BA56
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfGALHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:07:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbfGALHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 07:07:52 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 872BD2F8BDF;
        Mon,  1 Jul 2019 11:07:52 +0000 (UTC)
Received: from localhost (ovpn-204-140.brq.redhat.com [10.40.204.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B93078540;
        Mon,  1 Jul 2019 11:07:52 +0000 (UTC)
Date:   Mon, 1 Jul 2019 13:07:51 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Soeren Moch <smoch@web.de>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] rt2x00usb: remove unnecessary rx flag checks
Message-ID: <20190701110750.GB13992@redhat.com>
References: <20190701105314.9707-1-smoch@web.de>
 <20190701105314.9707-2-smoch@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701105314.9707-2-smoch@web.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 01 Jul 2019 11:07:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 12:53:14PM +0200, Soeren Moch wrote:
> In contrast to the TX path, there is no need to separately read the transfer
> status from the device after receiving RX data. Consequently, there is no
> real STATUS_PENDING RX processing queue entry state.
> Remove the unnecessary ENTRY_DATA_STATUS_PENDING flag checks from the RX path.
> Also remove the misleading comment about reading RX status from device.
> 
> Suggested-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Soeren Moch <smoch@web.de>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
