Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F2C2B01C1
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 10:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgKLJJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 04:09:11 -0500
Received: from mxout03.lancloud.ru ([89.108.73.187]:50230 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgKLJJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 04:09:10 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2020 04:09:09 EST
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 87EA520A0AAF
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH 1/2] bluetooth: hci_event: consolidate error paths in
 hci_phy_link_complete_evt()
To:     Marcel Holtmann <marcel@holtmann.org>
CC:     Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <bbdd9cbe-b65e-b309-1188-71a3a4ca6fdc@omprussia.ru>
 <b508265e-f08f-ea24-2815-bc2a5ec10d8d@omprussia.ru>
 <EA8EC09F-6AB5-45DD-9889-C05D1FC9AAE6@holtmann.org>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform
Message-ID: <c7579df5-a69b-d9e7-ccb6-6a7b2fc23d4a@omprussia.ru>
Date:   Thu, 12 Nov 2020 12:02:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <EA8EC09F-6AB5-45DD-9889-C05D1FC9AAE6@holtmann.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.87.163.193]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 11.11.2020 14:12, Marcel Holtmann wrote:

>> hci_phy_link_complete_evt() has several duplicate error paths -- consolidate
>> them, using the *goto* statements.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>
>> ---
>> net/bluetooth/hci_event.c |   16 ++++++----------
>> 1 file changed, 6 insertions(+), 10 deletions(-)
> 
> patch has been applied to bluetooth-next tree.

    What about the 2nd patch?

> Regards
> 
> Marcel

MBR, Sergey
