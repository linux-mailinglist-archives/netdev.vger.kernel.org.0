Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEFF1A656F
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 12:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgDMK6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 06:58:14 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:40301 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbgDMK6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 06:58:14 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.13]) by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee35e9445b3399-3962c; Mon, 13 Apr 2020 18:57:56 +0800 (CST)
X-RM-TRANSID: 2ee35e9445b3399-3962c
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [172.20.21.224] (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee75e9445b24ab-2bbe4;
        Mon, 13 Apr 2020 18:57:55 +0800 (CST)
X-RM-TRANSID: 2ee75e9445b24ab-2bbe4
Subject: Re: [PATCH] net: ethernet: ixp4xx: Add error handling
 inixp4xx_eth_probe()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     khalasa@piap.pl, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200412092728.8396-1-tangbin@cmss.chinamobile.com>
 <20200412113538.517669d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <e9c6ab77-973c-31f1-8a16-d5b476bbc30c@cmss.chinamobile.com>
Date:   Mon, 13 Apr 2020 18:59:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200412113538.517669d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi:

On 2020/4/13 2:35, Jakub Kicinski wrote:
> Please provide an appropriate Fixes: tag.

Should be:

Fixes: f458ac47 ("ARM/net: ixp4xx: Pass ethernet physical base as 
resource").


Thanks,

Tang Bin




