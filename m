Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A67882672
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730578AbfHEUzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:55:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33212 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730099AbfHEUzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:55:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so40244226pfq.0
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 13:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4KXV+V0Y4LXWPPHdZtOjtg8LvuBqOTRdhrp/IuPJ9+8=;
        b=NBj933g0GatNDFidx4WAKhFj8peffES4JKvJsr+lXLGAyHIsY9RuhlOJ0HQC/4kuKW
         NSyoT9aJSCWoxm39upas3iKU6o2KwLlaxxhtkqwwheEzBpWhotX3vfvOOBOwQzLvqQVY
         mEDz3lZ0HnukgmBFsZA0LnYGeKZK6BDTiaxuxdFlW8C30ezNOpNRWOpoaLoNtYNj16n1
         lTFpLujtlPC276Ggi7o2CWR5gbch5RciqyJMJRKXLt3osZsp2AiotoTCeZyWXyYJGXnG
         pg18kqCpbckyWvNRguhurX4OSUrWgZkGRPj8aexU5R5YF8N9Y/0FPaEZFXS5wAxiDMZt
         YPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4KXV+V0Y4LXWPPHdZtOjtg8LvuBqOTRdhrp/IuPJ9+8=;
        b=he3VyrupfgXpPjG1s8agmZHbZ7wm4n+aHUGUTg6uL12M/Qg+gQ6zJxP6WnlN+yBx92
         uTwC0T2WignH89KkyUqRwoKG6mp7yDfbbknWtAEfVzjS3q88PugqrkKlHNR4xiIIv7nL
         MwLo98jCO1pzwrrtn6Ijtde2s5whqqcE1FbLN6yjAL+EiU/GYDzf0lPAHgcA04r0csx9
         Bd0Qq6eTQDSSgNIYqYZXn+gETGCLOiAw0bRhZ5prmrnB8Ge5pOW9JPeEe+Ndh1fW0SzR
         rwUBc3eT8rqvtRfka3qWyzYqZBcbt7X62bKVqlgablKvwTPQYWHQ+E7tswJ+/WM/aWHH
         0sQw==
X-Gm-Message-State: APjAAAWbVD9jPKwIvIhr1L2rFL/1s5dw/xIwX0PduGa1tbWGEYbs9QFx
        RLibIwD1TJBNIO56MWHWRiec+5TR
X-Google-Smtp-Source: APXvYqzZNgRm67Z0+QJn8zTfHlqzu7K1Yt7lmPEYuME4IPpRegXaoHYksn7cR2CQUU9RRt1GZPz8NA==
X-Received: by 2002:a17:90a:bf03:: with SMTP id c3mr19010402pjs.112.1565038548372;
        Mon, 05 Aug 2019 13:55:48 -0700 (PDT)
Received: from [172.27.227.246] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id l1sm115986930pfl.9.2019.08.05.13.55.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 13:55:47 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: Add l2tp tests
To:     David Miller <davem@davemloft.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
References: <20190801235421.8344-1-dsahern@kernel.org>
 <20190805.132042.1186329327655280064.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5ba87d9f-bbcd-33be-2be9-9a365ca0039a@gmail.com>
Date:   Mon, 5 Aug 2019 14:55:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190805.132042.1186329327655280064.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/19 2:20 PM, David Miller wrote:
> From: David Ahern <dsahern@kernel.org>
> Date: Thu,  1 Aug 2019 16:54:21 -0700
> 
>> From: David Ahern <dsahern@gmail.com>
>>
>> Add IPv4 and IPv6 l2tp tests. Current set is over IP and with
>> IPsec.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> ---
>> The ipsec tests expose a netdev refcount leak that I have not had
>> time to track down, but the tests themselves are good.
> 
> Don't you need to add this to the Makefile too?
> 

interesting. I don't run tests via the Makefile, so I missed that for a
few others as well. Will send a v2 and an update for others.
