Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868CE2862DA
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgJGP6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:58:52 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:38716 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgJGP6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 11:58:51 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2020 11:58:49 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 37C98206E809
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: [PATCH 0/2] bluetooth: hci_event: make coding style more consistent
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Organization: Open Mobile Platform, LLC
Message-ID: <bbdd9cbe-b65e-b309-1188-71a3a4ca6fdc@omprussia.ru>
Date:   Wed, 7 Oct 2020 18:52:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.87.153.155]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

   Here are 2 patches against the 'bluetooth-next,git' repo. Mainly, I'm reducing
the indentation levels in the HCI driver, mostly by using *goto* in the error paths
in the functions where this hasn't been done -- this makes the coding style more
consistent across the HCI driver...

[1/2] bluetooth: hci_event: consolidate error paths in hci_phy_link_complete_evt()
[2/2] bluetooth: hci_event: reduce indentation levels
