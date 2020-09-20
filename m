Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4782712A1
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 08:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgITGWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 02:22:15 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54657 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgITGWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 02:22:15 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2020 02:22:14 EDT
Received: from marcel-macbook.fritz.box (p4fefc7f4.dip0.t-ipconnect.de [79.239.199.244])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9727CCECC4;
        Sun, 20 Sep 2020 08:21:57 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v3 2/6] Bluetooth: Set scan parameters for ADV Monitor
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200918111110.v3.2.I8aafface41460f81241717da0498419a533bd165@changeid>
Date:   Sun, 20 Sep 2020 08:14:59 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>, alainm@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A78820F2-CA17-452A-88E4-0BF670BE1BB4@holtmann.org>
References: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
 <20200918111110.v3.2.I8aafface41460f81241717da0498419a533bd165@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> Set scan parameters when there is at least one Advertisement monitor.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> (no changes since v1)
> 
> net/bluetooth/hci_request.c | 3 +++
> 1 file changed, 3 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

