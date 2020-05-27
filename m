Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CA31E35BB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 04:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgE0Cd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 22:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgE0Cd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 22:33:56 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A84C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:33:56 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id y1so7370629qtv.12
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TEb7X22ls1Eu3smxb1S6zKQHKgtXqtg2/AXutIphOuA=;
        b=iziDwc0gJYFU5BW7YeDSKO+pqNyabppbeboIKKUPyLr326oPYCRwkWmub1c9G7M5yY
         fdE1lm1O4E3lrh9wV4c9DNYVGLkSHZoepZ692RP/SqBjGmR8vSmJe9e+r0jcYlrzQZC7
         QOJtEH8yGA+NSB39Y8Y+M283WKkMsJ4ZmUUwcCU6V27qJCif3mQtGikZDQ7XatjjxYh+
         lgL/TWl+GINB4+I+ygbvJRAWrqPRYJWxT6+Dq5NdkjdX/OqOKoiBCAP3KnP3UFMIJzBc
         B8cveLb5vWD+Q3OrH04XPNTN0Hrgj69xlUTOEF5E3WSXZ1Sx5Te7Fp/xf1f+eN6zYFPh
         KdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TEb7X22ls1Eu3smxb1S6zKQHKgtXqtg2/AXutIphOuA=;
        b=DGw1ap8R/EdIzXGVnKvbU2KnOQ2OJcOhA/g4kJ2xnWdlYSG01tdEyPECOpDQTIu7+j
         Rm1JY88H64J9AiFG+91bl6OBdO8fDnyp13cXCVREJ6eGDGwXl6a+RX20w+BkogbdxARn
         hAXvrtVV5wBq4/7emCBo9jllJ3Q1BTyvwpb3GFC2hoHTnbSDi9DRELIo5EAHCSLxxIBp
         qHURMZBje1FU5LHApvW/p+IC3/2MS5mTOibckCaQcqaKLHtw5qVJ4ZVfF/BBnjtSkWbE
         x3+PzdqaiYxo2hlLTLGQNBvmblRCNYdFdl+5zh2l/XjR7sXCqKvXnk3qBPh+CfaXOSrp
         A+2w==
X-Gm-Message-State: AOAM532CNg3G9g3lkMg/TYQ/AwqZ/4qcqKTxYP0VzFsgnHRktj3GEn7C
        S/ZMkrNbI6pRNZvVWnYSlYw=
X-Google-Smtp-Source: ABdhPJzKPqMnt6ukq9FtwkFFqeEo2UHu1QgdSdqy2FjUosY2yVh18s3HmWnlIEWEaYNN5dQ485SIdg==
X-Received: by 2002:ac8:7c8e:: with SMTP id y14mr2056478qtv.112.1590546835759;
        Tue, 26 May 2020 19:33:55 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id i94sm1316916qtd.2.2020.05.26.19.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 19:33:55 -0700 (PDT)
Subject: Re: bpf-next/net-next: panic using bpf_xdp_adjust_head
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "brouer@redhat.com" <brouer@redhat.com>
References: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
 <52d793f86d36baac455630a03d76f09a388e549f.camel@mellanox.com>
 <0ee9e514-9008-6b30-9665-38607169146d@gmail.com>
 <e7d481d62d13607f57d5ecbdaf92f1c45b189bb6.camel@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea7b8966-ba4b-3cb9-7d9c-48f2c169fac4@gmail.com>
Date:   Tue, 26 May 2020 20:33:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e7d481d62d13607f57d5ecbdaf92f1c45b189bb6.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 7:56 PM, Saeed Mahameed wrote:
> On Tue, 2020-05-26 at 18:31 -0600, David Ahern wrote:
>> On 5/26/20 3:23 PM, Saeed Mahameed wrote:
>>> Anyway I can't figure out the reason for this without extra digging
>>> since in mlx5 we do xdp_set_data_meta_invalid(); before passing the
>>> xdp
>>> buff to the bpf program, so it is not clear why would you hit the
>>> memove in bpf_xdp_adjust_head().
>>
>> I commented out the metalen check in bpf_xdp_adjust_head to move on.
>>
>> There are number of changes in the mlx5 driver related to xdp_buff
>> setup
> 
> These changes are from net-next, the offending merge commit is from
> net..
> so either it is the combination of both or some single patch issue from
> net.

Good point. Just loaded top of 'net' and it works fine.

f2fb6b6275eb (HEAD -> net-master, net/master) net: stmmac: enable
timestamp snapshot for required PTP packets in dwmac v5.10a
