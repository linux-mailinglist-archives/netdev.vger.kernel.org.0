Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE97E4A3A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502025AbfJYLqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:46:03 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:45545 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730372AbfJYLqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:46:03 -0400
Received: by mail-il1-f196.google.com with SMTP id u1so1533119ilq.12
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 04:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tYaEkgIB9GWVlm/FJ7iRMkqgyqU72eCgGRd6HkRmWj8=;
        b=xAlEN6fWmVr5/JU3L0H/lJXgXb7dJIDyju0PXQi0WqZHtjQUku6EjDrvfgzmu7khGt
         G7aCzb+5WyYNBQxxnzT8n85H83dyj+DJ/GbHP8fJ5pOR8EAH++865PMJR3UMlKmpELn8
         7cBgFRnbRkT6BwhFL2ByQ6gM0H97D0ErJrlwHRpYgz4xbgev0PnaUkvLE4pLCQPacXVZ
         OUwuLZgpwcNGvaAePue2nSIpacwGPEmZLwYf3jOhJqEpEj1ostUeno6ZO1gAkIFX5Gmb
         GIbErTO4HVxnds0BRF9Xe77mplr1o7Lkhg0b+rRoavu99uJWqHRLQVbzAFiziVPJ7wpJ
         fxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tYaEkgIB9GWVlm/FJ7iRMkqgyqU72eCgGRd6HkRmWj8=;
        b=BZAzeDTE1j8o/MVrZSK2vjLbgtbJdJEl2zNy9raRbjIVwrR//is8mVwuf4OneIrXAJ
         upVrz9Lo3WG/Z28l6mYDD3S9oFxlAPAQ/YKRJ/Wh1lj5l1+qbxEYU+MVS2q6m0nw2K5r
         XLboVVoZSVOdLt9jLnt8ir26AyxuXTUudQG215u2yx5rLfS/D6ptIl6MRJ4U+AvZDXWB
         t6Ca9N6oEPBvzMtr2wC21WNDSCfqQ+usrEzWyY93tr95O7S0jRWX/8C3Y3oaxQHrmGym
         CKbWexSquwtokblftPSnsM76NQvrCMNfGq4BmdZi/OFImZP8v3j8hUhCfTEX27zSaM74
         Z7GQ==
X-Gm-Message-State: APjAAAWlS9cFQeUJgcdf4PwhAZGTOmvoEFLm3ia0b0oM5skafLFSOpsn
        V9so3xmaRV742dXZ/TpYtgeZ7A==
X-Google-Smtp-Source: APXvYqyY34HWGExpARsP76styMb+0Zxjg4E0G8ye5pGne/vgnrw91w32ID8q9/Og30VKS3Y/Q/ubNg==
X-Received: by 2002:a92:8703:: with SMTP id m3mr3783104ild.233.1572003962494;
        Fri, 25 Oct 2019 04:46:02 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id u85sm322760ili.28.2019.10.25.04.46.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 04:46:01 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbfv9se6qkr.fsf@mellanox.com>
 <200557cb-59a9-4dd7-b317-08d2dac8fa96@mojatatu.com>
 <vbfsgni6mun.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <2f389edd-a0d1-2e44-4e14-64ddbd581d3d@mojatatu.com>
Date:   Fri, 25 Oct 2019 07:46:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfsgni6mun.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-24 2:05 p.m., Vlad Buslov wrote:
> 

> 
> Yes, of course. I was talking strictly about naming of
> TCA_ACT_FLAGS_FAST_INIT flag value constant.
> 

Sorry, I missed that. You know discussions on names and
punctiations can last a lifetime;->[1].
A name which reflects semantics or established style
is always helpful. So Marcelo's suggestion is reasonable..
In the same spirit as TCA_FLAG_LARGE_DUMP_ON, how about:
TCA_FLAG_NO_PERCPU_STATS?

cheers,
jamal
[1]http://bikeshed.com/
