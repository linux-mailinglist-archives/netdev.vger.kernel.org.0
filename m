Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D87E471589
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhLKTK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhLKTK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:10:57 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A3EC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:10:57 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id i12so10908839qvh.11
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bDahYECyHbU9X0XOtlvZovwOA5REfJDfCpkOXYk0VFE=;
        b=mjdSNhqKviKgU0oz+ybpxVtu93ffkwfy/x6AIdUXEDGbQs0/abWQUHYoUF4iqnZmsU
         Z9HHk9bSwFBAxwNZvzbHaBCQJd1ZDWY07G6HE2tH5jj6f6lg03r3X4zi04lPE7HCkmKi
         4gRMCvQXObuo5Z1b4mX7HuC39AtZDKhSNLkV0qLOBDzJdvEl4Tqwvjg3ztfJP2D0ERoS
         wMiH5dSERnD+pHDFkD6U6hhQnvB7o0k1p4vWKzm6OOdIe6jnRQtcrwazcvvQiqeRmQdi
         4M+4nW9QeI5sPwnCEiUaK1+p2xNt7lwqnXhlu2jYFofCHooHpcPwhi/aygse5/22XjGo
         OmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bDahYECyHbU9X0XOtlvZovwOA5REfJDfCpkOXYk0VFE=;
        b=aNG7yGkIDihf/rmYojn8g7CARkfNt39cv4gpIhwLmFlranzLbMEBIAgB5HUiMEWpzX
         HwVUtFfInU5TC8ljBzh8sKlMUfLoyx8avov9c5rcau1WaToAP6xGnbzCGhmxIAX3RMb/
         FRM7mhl3qjTtSv0z680QKA4/YAK7Jezqsnavb5BDCWmDGb1lLg6peg2v1tgExh42u5bR
         WJqzdTCBR8ogQMSj2ywyFsuZDVwQrPikQt3qhabBsyH115vjsop3K7klTy3dcOKSqvjN
         WCKqrJh2xLcyLBYSGetfA3qB8gFEHtI70wm3omRH8mrXIEKJtZOn6JWA2iLJPP4BFakg
         uLFg==
X-Gm-Message-State: AOAM531n0M0awuMFYStlBUyur8K0AIGga+lngCBLhElbCnS1c11IhsXJ
        N9L0PNSQcS9T9lgcBVuw2i8rxg==
X-Google-Smtp-Source: ABdhPJxldkJalEazkMUXq8UWc6ItilmklJfAwlaC3zLVnjzMAxd7TlxNB4q++OwjR7Y2RWjBzAuYbQ==
X-Received: by 2002:a0c:ff49:: with SMTP id y9mr32578122qvt.102.1639249856509;
        Sat, 11 Dec 2021 11:10:56 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id a38sm3297747qkp.80.2021.12.11.11.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:10:56 -0800 (PST)
Message-ID: <56e9b12d-ef9d-38df-0255-1ef6cdb4e34b@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:10:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 04/12] flow_offload: return EOPNOTSUPP for the
 unsupported mpls action type
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-5-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-5-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:27, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> We need to return EOPNOTSUPP for the unsupported mpls action type when
> setup the flow action.
> 
> In the original implement, we will return 0 for the unsupported mpls
> action type, actually we do not setup it and the following actions
> to the flow action entry.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>


Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
