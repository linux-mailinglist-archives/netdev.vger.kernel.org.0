Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC211BB9FB
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgD1JiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:38:12 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:46509 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbgD1JiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:38:11 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 3E7ABCECEA;
        Tue, 28 Apr 2020 11:47:49 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Terminate the link if pairing is cancelled
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200414115512.1.I9dd050ead919f2cc3ef83d4e866de537c7799cf3@changeid>
Date:   Tue, 28 Apr 2020 11:38:09 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <DF70A2DA-9E5F-4524-8F20-2EC7CF70597F@holtmann.org>
References: <20200414115512.1.I9dd050ead919f2cc3ef83d4e866de537c7799cf3@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> If user decides to cancel ongoing pairing process (e.g. by clicking
> the cancel button on the pairing/passkey window), abort any ongoing
> pairing and then terminate the link.
> 
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> Hello Linux-Bluetooth,
> 
>  This patch aborts any ongoing pairing and then terminates the link
>  by calling hci_abort_conn() in cancel_pair_device() function.
> 
>  However, I'm not very sure if hci_abort_conn() should be called here
>  in cancel_pair_device() or in smp for example to terminate the link
>  after it had sent the pairing failed PDU.
> 
>  Please share your thoughts on this.

I am look into this. Just bare with me for a bit to verify the call chain.

Regards

Marcel

