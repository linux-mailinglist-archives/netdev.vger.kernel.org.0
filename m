Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0D82712A3
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 08:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgITGWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 02:22:15 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:33980 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgITGWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 02:22:15 -0400
Received: from marcel-macbook.fritz.box (p4fefc7f4.dip0.t-ipconnect.de [79.239.199.244])
        by mail.holtmann.org (Postfix) with ESMTPSA id BC368CECC3;
        Sun, 20 Sep 2020 08:21:49 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v3 1/6] Bluetooth: Update Adv monitor count upon removal
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Date:   Sun, 20 Sep 2020 08:14:52 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <AEC53846-5041-4292-8958-4AC1CAAEBE23@holtmann.org>
References: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This fixes the count of Adv monitor upon monitor removal.
> 
> The following test was performed.
> - Start two btmgmt consoles, issue a btmgmt advmon-remove command on one
> console and observe a MGMT_EV_ADV_MONITOR_REMOVED event on the other.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
> 
> Changes in v3:
> - Remove 'Bluez' prefix
> 
> Changes in v2:
> - delete 'case 0x001c' in mgmt_config.c
> 
> net/bluetooth/hci_core.c | 2 ++
> 1 file changed, 2 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

