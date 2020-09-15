Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7404D269CD7
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 06:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgIOEI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 00:08:27 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60196 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOEI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 00:08:26 -0400
Received: from [192.168.0.114] (unknown [49.207.201.19])
        by linux.microsoft.com (Postfix) with ESMTPSA id CC99A2079101;
        Mon, 14 Sep 2020 21:08:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CC99A2079101
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1600142906;
        bh=/Mv5O1UvntEWYO8o10jBuHAlAU79rMAqzjgJe/3Oa7A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aeijkIQXAIyRP2tcHlaMQ99msmsBL61eYnzE1d3QWbN0OJxg+kF9QGg7d3y1kRNlC
         s3+2oYzYUoLK73yukMAN9RwlpqXYqryv8NBN9oYgwLEXilXK5q7Dtd/WoAPoN6Cjkk
         ECPUCzowsifuZ0/pqTO4UbJp6udPFoPtjpbeNv3w=
Subject: Re: [RESEND net-next v2 00/12]drivers: net: convert tasklets to use
 new tasklet_setup() API
To:     David Miller <davem@davemloft.net>, allen.lkml@gmail.com
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org
References: <20200914073131.803374-1-allen.lkml@gmail.com>
 <20200914.132438.1323071673363556958.davem@davemloft.net>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <a43cb15f-a543-3099-ee8a-63de4bd15e66@linux.microsoft.com>
Date:   Tue, 15 Sep 2020 09:38:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200914.132438.1323071673363556958.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
>> From: Allen Pais <apais@linux.microsoft.com>
>>
>> ommit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
>> introduced a new tasklet initialization API. This series converts
>> all the net/* drivers to use the new tasklet_setup() API
>>
>> This series is based on v5.9-rc5
> 
> I don't understand how this works, you're not passing the existing
> parameter any more so won't that crash until the final parts of the
> conversion?
> 
> This is like a half-transformation that will break bisection.

  I understand, I will re-work on it and send it out.


> 
> I'm not applying this series, sorry.
> 

