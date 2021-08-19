Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69633F1CC5
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbhHSP3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:29:54 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42186 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhHSP3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:29:53 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id A4850CED17;
        Thu, 19 Aug 2021 17:29:15 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v4] Bluetooth: Fix return value in hci_dev_do_close()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210819152718.2713-1-l4stpr0gr4m@gmail.com>
Date:   Thu, 19 Aug 2021 17:29:15 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <31F9AB85-09D2-4EC0-B054-FD4EEF8CEEE4@holtmann.org>
References: <20210819152718.2713-1-l4stpr0gr4m@gmail.com>
To:     Kangmin Park <l4stpr0gr4m@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kangmin,

> hci_error_reset() return without calling hci_dev_do_open() when
> hci_dev_do_close() return error value which is not 0.
> 
> Also, hci_dev_close() return hci_dev_do_close() function's return
> value.
> 
> But, hci_dev_do_close() return always 0 even if hdev->shutdown
> return error value. So, fix hci_dev_do_close() to save and return
> the return value of the hdev->shutdown when it is called.
> 
> Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> ---
> Changes in v4:
> - rename variable to err.
> 
> net/bluetooth/hci_core.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

