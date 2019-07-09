Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC3862E72
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfGIDAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:00:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43212 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfGIDAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:00:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so8655961pgv.10
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 20:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=iGQzN4QlOJ4XybB0pOrQ53+JHEG1ubc+xzSVcjFhOBM=;
        b=I6pdTDGF04iSq7lDmQVjHhEL/Xksy8QSOE0paU9lWRaeVL6hBS283JC5Xkt23jbOqR
         L81L8D8niCQM9lbo/i/jAG9xKlF/JXsAUoMZKurass3KgvzbdVnhHhGWTTWEHoJX3zuQ
         E5hEqFu+bg5lMkv40LyluG1m1nj/15thwkMsAuZyXuN6TkxFkxc6cylgF11Al2+kisyW
         ZG7muZq5A7qr8OamS3dZEx/njysZCmdHt+XJ716/ENTqk74lyHKhg7m6LqQvavbnMzsq
         wGnXY+kUlH4ghMbnEdKhw7XxwLrnTzRnBUnYbhQ08Gx9TdFq14jEnFw5j0GT48aOQjF5
         UXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iGQzN4QlOJ4XybB0pOrQ53+JHEG1ubc+xzSVcjFhOBM=;
        b=r/YcWfb84PTvx6anlUOM7+PT9b3hekM1XF8jGmkFm3/x6GsoyE0YlVtLap5fRoKtAX
         iXLng+CH02JlNfYnAkpQTd9n9Id/ZQlNZEAiffMjg3D0fQU08AWcxtRYFCwFG1BhzIrr
         xwAOiXbR2csRCu3Mf+R1mHi+jo/z1yN4QnTrD/u57V5YC5rS9CRkh6qEK02qognnFYb7
         OMoBOHWTTV0E1ydFNfcfu/XDsaDYHLipseGWPzPLa2xReAHOQqs01ax9ZTwd4EgIO7H2
         jXgxqiIaw7PqpWroRvXy7jIevMRGIq+n/Qr59OJMe6tam9ZADkVH1rsILR4HcHUEREjD
         5plw==
X-Gm-Message-State: APjAAAXOviM9zJqa3L7JCUANG9FHKUhD+Z5lOrF/GkC9d9EYZF/4n+r+
        j+YvMZpZV7/4t7IVvUPaCD64WE/0K50=
X-Google-Smtp-Source: APXvYqyKD7JGqzKl/KyPa808ImFndwhXvoge4Qdn8ohyUqjG3HVNmUUGmvEfJpEYpqshNCrP+PJDSg==
X-Received: by 2002:a63:5d45:: with SMTP id o5mr28101354pgm.40.1562641233714;
        Mon, 08 Jul 2019 20:00:33 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id c9sm18764698pfn.3.2019.07.08.20.00.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 20:00:33 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 00/19] Add ionic driver
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708.195806.758232640547515457.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e448a023-73a0-33f5-a8ad-2793f79801d1@pensando.io>
Date:   Mon, 8 Jul 2019 20:01:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190708.195806.758232640547515457.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/19 7:58 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon,  8 Jul 2019 12:25:13 -0700
>
>> This is a patch series that adds the ionic driver, supporting the Pensando
>> ethernet device.
> ...
>
> I think with the review comments and feedback still coming in you will
> have to wait until the next merge window, sorry.
Yep, that's what I was expecting - I'll have another patchset version 
ready by then.

Cheers,
sln

