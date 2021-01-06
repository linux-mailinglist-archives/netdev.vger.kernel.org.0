Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337652EC53C
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbhAFUkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:40:49 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:50486 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbhAFUkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 15:40:49 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 8813220CCC3B
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: [PATCH net-next 0/2] Update register/bit definitions in the EtherAVB
 driver
Organization: Open Mobile Platform, LLC
Message-ID: <6aef8856-4bf5-1512-2ad4-62af05f00cc6@omprussia.ru>
Date:   Wed, 6 Jan 2021 23:30:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are 2 patches against DaveM's 'net-next' repo. I'm updating the driver to match
the recent R-Car gen2/3 manuals...

[1/2] ravb: remove APSR_DM
[2/2] ravb: update "undocumented" annotations
