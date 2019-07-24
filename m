Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90EC74128
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfGXWA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfGXWA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 18:00:58 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A82B2189F;
        Wed, 24 Jul 2019 22:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564005658;
        bh=VrgtHEbhdHEJiTQ3wsmJsht6To4CZv7AOCPzqrobSJQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IaSmv2JEhaGlFY1dGd2ZLFha5AkO6xFxZeLEiidoGL4Nn/+N6CENBFBVtQ5FR2h9D
         9aESGr/d0LvsEmgshfCQlM8+9c+Lf1gvS0js5XkRYPRMNLbnRWiTemFxxrh1Me32KQ
         37mrUrpE3TVQLdgW+Zlugzo4eLnvBKkfHUgG3j8Q=
Subject: Re: [PATCH net-next] selftests: mlxsw: Fix typo in qos_mc_aware.sh
To:     David Miller <davem@davemloft.net>, standby24x7@gmail.com
Cc:     linux-kernel@vger.kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, linux-kselftest@vger.kernel.org,
        rdunlap@infradead.org, netdev@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20190724152951.4618-1-standby24x7@gmail.com>
 <20190724.145123.912916059374852633.davem@davemloft.net>
From:   shuah <shuah@kernel.org>
Message-ID: <7e69dda0-bca2-4b78-19cb-b66d097503c0@kernel.org>
Date:   Wed, 24 Jul 2019 16:00:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724.145123.912916059374852633.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/19 3:51 PM, David Miller wrote:
> From: Masanari Iida <standby24x7@gmail.com>
> Date: Thu, 25 Jul 2019 00:29:51 +0900
> 
>> This patch fix some spelling typo in qos_mc_aware.sh
>>
>> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
>> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Applied.
> 

I applied to this my fixes branch this morning on auto-pilot
without realizing that it is in your domain :)

Would you like like me to drop it from mine?

thanks,
-- Shuah
