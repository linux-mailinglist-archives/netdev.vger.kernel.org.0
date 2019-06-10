Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74AAA3B853
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 17:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbfFJP37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 11:29:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35059 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389786AbfFJP37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 11:29:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so3810815plo.2
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 08:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mnfSmz7sVCjARhj7G33rZXcH2Yiiwr13XgMkUxkiQQE=;
        b=f8uRx2trIsbf1PW1t7gMG88BXu7suWu7ntrkvb7TZGd7hNi1Vkw1KKqFzJTJ5lI4lu
         bElezWT2pv5+MAwyLnFh0DlzqTJm/1WIV7bdunKwj+3h9ir6g7a1geioSOWKs1wa98NF
         akZ1gSXErC7KbLLKbl+12ujPb0+ohGGHbaySST0ug6ggjxJZN3cc2oE4fxsemCbGmJot
         14q/+Kp5HIF+7zx7ikUB2crXe4BKHDVx8ZxCq80d3SJXkNJiSnWBg1Igm3hfaeRYb4JN
         GoAeMOqyETkONVNrJ79pWFKwo22vbw2knuZARKhkfX8mdV/YWFVh0nRf7LSIASxeAATd
         uvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mnfSmz7sVCjARhj7G33rZXcH2Yiiwr13XgMkUxkiQQE=;
        b=gVGEkMZoLrvHrnevcXDK2WPz1mpMYpgY6q3vHSSCqr8LVpCAnLHF7dCTDyg9aKhutK
         ckiRFfp52zGarrOkXnm8Uv1m1tEl9KufhSZeLYtkC+kfmKWBGVtEqWfNKJPt0+mSyWVK
         yxpCrbgsYuo/U3LddaQyVqKvppajY9Q8LUDFD6KjPtip9vK8qsPKlCQaDE1+Gm79o+jO
         0qH5iXUs2g8QQmAVstw4XmAJzKLJ0Z5d3ZkbZ4tSV2VY4lpRPZzSHmA/VU8DWtzk7Dbh
         GvNLvL0gstKpHWeMNpxDyk5XJydrhyJMkZXqH+3yAA7O9Qo1Mlb8OqRmwJg4pxVZfTdA
         AEIQ==
X-Gm-Message-State: APjAAAUHAhgZs9ZaQU5sZorpHTibZ0D89qEVblpgL/DDhZu2DI8gueFz
        Hk1LJaYczeFESj3LngQm6STcTYlX
X-Google-Smtp-Source: APXvYqwDd+X4oyPfUUck7I7K0Fng1rE7Os9wj3S6FziugBjXwzLDYLyo0TlHPUYSQrYERtGIbeC8Vw==
X-Received: by 2002:a17:902:bb8f:: with SMTP id m15mr5721624pls.84.1560180598590;
        Mon, 10 Jun 2019 08:29:58 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 144sm17322291pfy.54.2019.06.10.08.29.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 08:29:57 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] selftests: mlxsw: Add ethtool_lib.sh
To:     Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-2-idosch@idosch.org> <20190610133538.GF8247@lunn.ch>
 <20190610135651.GA19495@splinter>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <bfd47cd0-2998-d2b9-7478-fb8cc6fee87c@gmail.com>
Date:   Mon, 10 Jun 2019 08:29:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190610135651.GA19495@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/2019 6:56 AM, Ido Schimmel wrote:
> On Mon, Jun 10, 2019 at 03:35:38PM +0200, Andrew Lunn wrote:
>> On Mon, Jun 10, 2019 at 11:40:43AM +0300, Ido Schimmel wrote:
>>> From: Amit Cohen <amitc@mellanox.com>
>>> +declare -A speed_values
>>> +
>>> +speed_values=(	[10baseT/Half]=0x001
>>> +		[10baseT/Full]=0x002
>>> +		[100baseT/Half]=0x004
>>> +		[100baseT/Full]=0x008
>>> +		[1000baseT/Half]=0x010
>>> +		[1000baseT/Full]=0x020
>>
>> Hi Ido, Amit
>>
>> 100BaseT1 and 1000BaseT1 were added recently.
> 
> Hi Andrew,
> 
> Didn't see them in the man page, so didn't include them. I now see your
> patches are in the queue. Will add these speeds in v2.

Could we extract the values from include/uapi/linux/ethtool.h, that way
we would not have to have to update the selftest speed_values() array here?
-- 
Florian
