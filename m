Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29991339891
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhCLUmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:42:36 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:35092 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbhCLUmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 15:42:19 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru C32D520D27A8
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: [PATCH net-next 0/4] Improve the register/bit definitions in the
 Ether driver
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
Organization: Open Mobile Platform, LLC
Message-ID: <41a26045-c70e-32d7-b13e-8a8bd0834fcc@omprussia.ru>
Date:   Fri, 12 Mar 2021 23:42:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are 4 patches against DaveM's 'net-next' repo. Mainly I'm renaming the register *enum*
tags/entries to match the SoC manuals,and also moving the RX-TX descriptor *enum*s closer to
the corresponding *struct*s...

[1/4] sh_eth: rename TRSCER bits
[2/4] sh_eth: rename PSR bits
[3/4] sh_eth: rename *enum*s still not matching register names
[4/4] sh_eth: place RX/TX descriptor *enum*s after their *struct*s
