Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277C84FB6E4
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344105AbiDKJIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344230AbiDKJIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:08:05 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AA3201B5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:05:51 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b24so17471717edu.10
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v4z7ciQz0pMAhP2xoz2akjfMI+qQ/Mok6WikmTBqsYw=;
        b=tExJp+KgFpJ4L78z/xw5eqoIi0XRxRVIvDLn5hd6ER/6T0J9opCve52t/72GZK1QEs
         oMNTPbuOztVr9urcUkXJ2jwDFtD9Npi9NyjTezw4nXQvLHLZHafc9/Law32cc9yzt9kK
         nOHUQBLkhaq8dNPs4Qx73mDAtPZJwUvS7/zf+/EP+vhZ4WrqxADruiqxUyOtNk3DcooQ
         ayi0IziFBArzr866houQ8yQU9ihW2YQCQH3Uo/2gWW44DXN5g6xEKzAtu9cPoYYjzK9+
         kswhfTkuBRTOa1gy9V3Ce2Q8bClVQ+Q/df/8X8sDISMWP05PYBLR7rhchelPT0lpned6
         f+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v4z7ciQz0pMAhP2xoz2akjfMI+qQ/Mok6WikmTBqsYw=;
        b=ZEIAVFE9T3JkKUvoPsGGLneRLpOnIgx0lEjD6afZS2RzkCALb16GbBOBlkpOgzpB2z
         FM52C+iGgfkprBKe9tC09A9fnNGNvFs3RlbMht7Gn7r6895+UdKGxl9gotgdlx0pQTAt
         w7b6VxZjErW46dlxxq0G//S/7RTT9u0Uk6ebcz2Zk7oqOpR56/9rNvoYLqw0jf8BkZvm
         YTU7w2Q3wulKjo4EPBewODPM6WncRsxty3nZGiEvgNuSjbGLpTmh33UyVmECV0q278W0
         HO5OFAOahWyI6wEB2QcijAAlukoCxttAt2nVX7y1fU8BUmBlW+zVA04PCJXxtsAo0c/C
         Sisw==
X-Gm-Message-State: AOAM530pYZiVfMlPhBbSn+naxC8z9VqDQm6vY8He8uUaJb44XUwOBVlx
        kGwQA2+5WmbHp4M95rm+olqltg==
X-Google-Smtp-Source: ABdhPJzL62lxf1dH7Rlxl3m77KsOIvn0rPi/DP1y2PaxTFSyqas+xdQpMvWvwAQdRizF+JK1MD41wQ==
X-Received: by 2002:a05:6402:438b:b0:41b:5212:1de1 with SMTP id o11-20020a056402438b00b0041b52121de1mr32849288edc.384.1649667950273;
        Mon, 11 Apr 2022 02:05:50 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709067c0c00b006e86db76851sm2768598ejo.193.2022.04.11.02.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 02:05:49 -0700 (PDT)
Message-ID: <61e817f3-8d06-b190-6023-1b89e05e4482@blackwall.org>
Date:   Mon, 11 Apr 2022 12:05:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 3/6] net: bridge: fdb: add new nl attribute-based
 flush call
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-4-razor@blackwall.org> <YlPpqKFeAs5oCHGD@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YlPpqKFeAs5oCHGD@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 11:41, Ido Schimmel wrote:
> On Sat, Apr 09, 2022 at 01:58:54PM +0300, Nikolay Aleksandrov wrote:
>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>> index 221a4256808f..2f3799cf14b2 100644
>> --- a/include/uapi/linux/if_bridge.h
>> +++ b/include/uapi/linux/if_bridge.h
>> @@ -807,7 +807,15 @@ enum {
>>  /* embedded in IFLA_BRIDGE_FLUSH */
>>  enum {
>>  	BRIDGE_FLUSH_UNSPEC,
>> +	BRIDGE_FLUSH_FDB,
>>  	__BRIDGE_FLUSH_MAX
>>  };
>>  #define BRIDGE_FLUSH_MAX (__BRIDGE_FLUSH_MAX - 1)
>> +
>> +/* embedded in BRIDGE_FLUSH_FDB */
>> +enum {
>> +	FDB_FLUSH_UNSPEC,
> 
> BTW, is there a reason this is not called FLUSH_FDB_UNSPEC given it's
> embedded in BRIDGE_FLUSH_FDB, which is embedded in IFLA_BRIDGE_FLUSH ?
> 
> Regardless, in the cover letter you have '[ BRIDGE_FDB_FLUSH ]', which
> is actually BRIDGE_FLUSH_FDB. I only noticed it because the code didn't
> match what I had in my notebook, which I copied from the cover letter :)
> 

Oops, that's a mismatch between an older version of the set and this one. :)

>> +	__FDB_FLUSH_MAX
>> +};
>> +#define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
>>  #endif /* _UAPI_LINUX_IF_BRIDGE_H */

