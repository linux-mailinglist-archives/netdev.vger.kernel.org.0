Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9CC1B1DA5
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 06:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgDUEpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 00:45:04 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2389 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgDUEpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 00:45:04 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea5e9e7a3dbe7-e3ee9; Tue, 21 Apr 2020 12:44:47 +0800 (CST)
X-RM-TRANSID: 2eea5e9e7a3dbe7-e3ee9
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [172.20.146.166] (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95e9e7a33b85-2393b;
        Tue, 21 Apr 2020 12:44:46 +0800 (CST)
X-RM-TRANSID: 2ee95e9e7a33b85-2393b
Subject: Re: [PATCH] net: ethernet: ixp4xx: Add error handling
 inixp4xx_eth_probe()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     khalasa@piap.pl, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>
References: <20200412092728.8396-1-tangbin@cmss.chinamobile.com>
 <20200412113538.517669d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <71697844-cc03-9206-1594-b8af02f38018@cmss.chinamobile.com>
Date:   Tue, 21 Apr 2020 12:46:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200412113538.517669d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub:

On 2020/4/13 2:35, Jakub Kicinski wrote:
> On Sun, 12 Apr 2020 17:27:28 +0800 Tang Bin wrote:
>> The function ixp4xx_eth_probe() does not perform sufficient error
>> checking after executing devm_ioremap_resource(),which can result
>> in crashes if a critical error path is encountered.
>>
> Please provide an appropriate Fixes: tag.

Thanks for your reply.

I don't know whether the commit message affect this patch's result. If so,

I think the commit message in v2 needs more clarification. As follows:

     The function ixp4xx_eth_probe() does not perform sufficient error 
checking

after executing devm_ioremap_resource(), which can result in crashes if 
a critical

error path is encountered.

     Fixes: f458ac479777 ("ARM/net: ixp4xx: Pass ethernet physical base 
as resource").


I'm waiting for you reply actively.

Thanks,

Tang Bin



