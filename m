Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501092AEE27
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgKKJww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:52:52 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:39338 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgKKJwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 04:52:51 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.201.106])
        by mail.holtmann.org (Postfix) with ESMTPSA id E8D0ACECFA;
        Wed, 11 Nov 2020 10:59:57 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2] Bluetooth: Enforce key size of 16 bytes on FIPS level
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201111142947.v2.1.Id3160295d33d44a59fa3f2a444d74f40d132ea5c@changeid>
Date:   Wed, 11 Nov 2020 10:52:48 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4150D57E-480B-4A41-9F18-3E76A23BEB78@holtmann.org>
References: <20201111142947.v2.1.Id3160295d33d44a59fa3f2a444d74f40d132ea5c@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> According to the spec Ver 5.2, Vol 3, Part C, Sec 5.2.2.8:
> Device in security mode 4 level 4 shall enforce:
> 128-bit equivalent strength for link and encryption keys required
> using FIPS approved algorithms (E0 not allowed, SAFER+ not allowed,
> and P-192 not allowed; encryption key not shortened)
> 
> This patch rejects connection with key size below 16 for FIPS
> level services.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> 
> ---
> 
> Sorry for the long delay. This patch fell out of my radar.
> 
> Changes in v2:
> * Add comment on enforcing 16 bytes key size
> 
> net/bluetooth/l2cap_core.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

