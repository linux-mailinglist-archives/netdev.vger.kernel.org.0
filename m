Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3740246CB83
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbhLHDXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbhLHDXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:23:41 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E06C061574;
        Tue,  7 Dec 2021 19:20:09 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id bf8so2234574oib.6;
        Tue, 07 Dec 2021 19:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ipzGWXUTrKfsJcUKnBbciLM67OZ1SYoLF2ZfjF2KeT4=;
        b=bobOpMtKzG9mSNF4Fp2Op+a2P8xAsFhOpDUPZrn5XqfOy1O61yRXHLXXfDqtiISE4p
         NVgm6ACxEriLu1giILI5FSQkA62MP/XtmDO7HskU/15cW5ksrK9E4PL2A16QGIRXYaX8
         y91IuVcs3AyQpr3hxxifbv22CxX8mGT6jP+95YOEPcF3YggrAAHP6apEctKuArWUZpAk
         YlHfAl4rlcTA0yL1cfZgYnhHs2hgKoX0eZKxZ//PtGKTYSbiagQ0nCfufoOAKGxDQ/HT
         baYVjtYXOU9Fh0gVOqY6AGn9tIEbkRviWeNNI9wthjxv9qK/3FsllLjfi+PTi4cXh5rX
         P1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ipzGWXUTrKfsJcUKnBbciLM67OZ1SYoLF2ZfjF2KeT4=;
        b=TA+k+tu5kbXNIuRxg9Vi9SGk8TusLO1QgR43g0pYsweWz2EfJhy3c5rNI5MzAZb+aZ
         j5/IPFEx4bIVYtdcp+taIKNuTDvdOBoY3wyQCBMQ3E33Pu13fQ8gdppcTOqZPhsDveau
         4Ksbcs8hE7x7KNv0AfInSiV2k9RnCsZEgaOwDMWeG3NHQPeYSjXoLSUCRb8WOQ12Ifig
         0U+wDN4AkYo3g3fXkzby8LqmkgDs88stPrHDl0MJlW5kKdzLwqk4bohOgxeyVQ19O4co
         KPSmD8kvI6cctbWrTVi3JpNd9EzwRe/DX00yW+rRw7dn0CQ+2dYrQ/il6gROEYj2T6P3
         XJsQ==
X-Gm-Message-State: AOAM532UxQ9u1x0z2ZRJpT1PvaIe8vls9zW80aikuUur+N1XzQ5kXxdf
        RKAyOXOaOJn5I/Z8wGmgXkM=
X-Google-Smtp-Source: ABdhPJyH0gWYQ1T5h3GfTNMDRwlAXjdRTRWOmqe5j8m70em6JUBwiUNxj0q/fGAnHMMHLwR5iGW7nw==
X-Received: by 2002:a05:6808:1903:: with SMTP id bf3mr9073447oib.7.1638933609321;
        Tue, 07 Dec 2021 19:20:09 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a3sm355301oil.32.2021.12.07.19.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 19:20:09 -0800 (PST)
Message-ID: <2918f246-7a48-4395-42bb-d50b943480c6@gmail.com>
Date:   Tue, 7 Dec 2021 20:20:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: selftests/net/fcnal-test.sh: ipv6_ping test failed
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>
Cc:     "Zhou, Jie2X" <jie2x.zhou@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>, lkp <lkp@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>,
        "Li, ZhijianX" <zhijianx.li@intel.com>
References: <PH0PR11MB4792DFC72C7F7489F22B26E5C56E9@PH0PR11MB4792.namprd11.prod.outlook.com>
 <20211207075808.456e5b4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211207075808.456e5b4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 8:58 AM, Jakub Kicinski wrote:
> Adding David and Zhijian.
> 
> On Tue, 7 Dec 2021 07:07:40 +0000 Zhou, Jie2X wrote:
>> hi,
>>
>>   I test ipv6_ping by "./fcnal-test.sh -v -t ipv6_ping".
>>   There are two tests failed.
>>
>>    TEST: ping out, VRF bind - ns-B IPv6 LLA                                      [FAIL]
>>    TEST: ping out, VRF bind - multicast IP                                       [FAIL]
>>
>>    While in fcnal-test.sh the expected command result is 2, the result is 1, so the test failed.
>>    ipv6_ping_vrf()
>>    {
>>     ......
>>         for a in ${NSB_LINKIP6}%${VRF} ${MCAST}%${VRF}
>>         do
>>                 log_start
>>                 show_hint "Fails since VRF device does not support linklocal or multicast"
>>                 run_cmd ${ping6} -c1 -w1 ${a}
>>                 log_test_addr ${a} $? 2 "ping out, VRF bind"
>>         done
>>
>>     The ipv6_ping test output is attached.
>>     Did I set something wrong result that these tests failed?
>>
>> best regards,

ping6 is failing as it should. Can you send a patch to change the
expected rc from 2 to 1?
