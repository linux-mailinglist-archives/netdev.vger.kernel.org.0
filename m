Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDD832746A
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 21:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhB1UdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 15:33:17 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:54558 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhB1UdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 15:33:16 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru B777620B5E07
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: [PATCH net 0/3] Fix TRSCER masks in the Ether driver
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
Organization: Open Mobile Platform, LLC
Message-ID: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru>
Date:   Sun, 28 Feb 2021 23:24:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
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

Here are 3 patches against DaveM's 'net' repo. I'm fixing the TRSCER masks in
the driver to match the manuals...

[1/3] sh_eth: fix TRSCER mask for SH771x
[2/3] sh_eth: fix TRSCER mask for R7S72100
[3/3] sh_eth: fix TRSCER mask for R7S9210
