Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6438E4730FE
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240246AbhLMP6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhLMP6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:58:52 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7D3C061574;
        Mon, 13 Dec 2021 07:58:52 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id n66so23678494oia.9;
        Mon, 13 Dec 2021 07:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yGfzyDYwTUBRIBWmk787nJHKxOhWCaJ2ogedCtBIFp0=;
        b=dWBgYGE+1jy15pU/SA8uESGrurPXMg+geN1MMCYoc0j6kMP23Hn9RK2A3u4Tpnm73p
         u3JxCPByl9oqKh+iIncJyQ9zdnU43V6bM9YI++TvIQgp8UMJtoPh2CCWGKBvnSiWb32X
         gHfazgNz8J+9MK2/WzmdsGQelYrXeBi3dmj6bbjOfviSc1SYz5SP7mZcqxSeSVw+v5Is
         qfMg+xiQZIIxa/eGmZerqWezZmYHINHKp+a+YKgd8hOCSoim2KtwA7GMo0bhZjHmIQZW
         74SYZL6ibpW4UprvE7ibe/aMBOX2wsUMs+G7ivknL2T7Efr+ZEQNq1Ene11whY8lNhWs
         hw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yGfzyDYwTUBRIBWmk787nJHKxOhWCaJ2ogedCtBIFp0=;
        b=PKvruxMFu/Do6L56Btpsp32A+NkRFHeLRmjqczNOb3Q6RqUsPgb2UUQDOk3qCwtFqC
         OC6o+RD6+MkfrDzeGNvOd/mAlxmGCcvsOZF38C89kJVo7wEcFYULIiUofyDnQNJAECt+
         iWMLrE0CSXzloGWIsS3VFbzOF3V2yIQJyemfLYbRG5/hijYhTgPdLsbbVg9Uld/P6xcS
         VdhFWpgS3jMxJebRY8Ex8hJmQrFVVgYLnvRObRl7zGaJf/IksrcZS4/CmWkFxdSOHsWV
         QUqTmI3qrVCIuU38PnRyuT7NdyG16ApwJoRNgU6IBKj/y6KtYSkXU6hfH8G5P2d8S7VB
         GOSg==
X-Gm-Message-State: AOAM532nF5AtKEJMzqCpp90c4Jy/rBvw+tPK4qozMpj5/afRhEYpVK6e
        I6hJunDMjeWktkHIGMxzk8V2cI2qLGg=
X-Google-Smtp-Source: ABdhPJxdEgNEluuOP+Mg+WGZz5WdDvYAl977/wITRh82fIbG32cqCCawD3aMXBeZ346805JYBy1fjA==
X-Received: by 2002:a05:6808:14c2:: with SMTP id f2mr28062103oiw.154.1639411132077;
        Mon, 13 Dec 2021 07:58:52 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id e14sm2306709oow.3.2021.12.13.07.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 07:58:51 -0800 (PST)
Message-ID: <56ae3614-f666-4eed-cfee-e2dc7b7eb169@gmail.com>
Date:   Mon, 13 Dec 2021 08:58:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v2] selftests: net: Correct case name
Content-Language: en-US
To:     "Zhou, Jie2X" <jie2x.zhou@intel.com>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, ZhijianX" <zhijianx.li@intel.com>,
        "Li, Philip" <philip.li@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>
References: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
 <bbb91e78-018f-c09c-47db-119010c810c2@fujitsu.com>
 <41a78a37-6136-ba45-d8fa-c7af4ee772b9@gmail.com>
 <4d92af7d-5a84-4a5d-fd98-37f969ac4c23@fujitsu.com>
 <8e3bb197-3f56-a9a7-b75d-4a6343276ec7@gmail.com>
 <PH0PR11MB47925643B3A60192AAD18D7AC5749@PH0PR11MB4792.namprd11.prod.outlook.com>
 <65ca2349-5d11-93fb-d9d3-22ff87fe7533@gmail.com>
 <PH0PR11MB4792C379D6C64BE6BA0ECED8C5749@PH0PR11MB4792.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <PH0PR11MB4792C379D6C64BE6BA0ECED8C5749@PH0PR11MB4792.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/13/21 2:44 AM, Zhou, Jie2X wrote:
> hi,
> 
>> After the last round of patches all tests but 2 pass with the 5.16.0-rc3
>> kernel (net-next based) and ubuntu 20.04 OS.
>> The 2 failures are due local pings and to bugs in 'ping' - it removes
>> the device bind by calling setsockopt with an "" arg.
> 
> The failed testcase command is nettest not ping.
> COMMAND: ip netns exec ns-A nettest -s -R -P icmp -l 172.16.1.1 -b
> TEST: Raw socket bind to local address - ns-A IP                              [FAIL]
> 
> It failed because it return 0.
> But the patch expected return 1.
> 
> May be the patch should expected 0 return value for  ${NSA_IP}.
> And expected 1 return value for  ${VRF_IP}.
> 
> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> index dd7437dd2680b..4340477863d36 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -1810,8 +1810,9 @@ ipv4_addr_bind_vrf()
>         for a in ${NSA_IP} ${VRF_IP}
>         do
>                 log_start
> +               show_hint "Socket not bound to VRF, but address is in VRF"
>                 run_cmd nettest -s -R -P icmp -l ${a} -b
> -               log_test_addr ${a} $? 0 "Raw socket bind to local address"
> +               log_test_addr ${a} $? 1 "Raw socket bind to local address"
> 
>                 log_start
>                 run_cmd nettest -s -R -P icmp -l ${a} -I ${NSA_DEV} -b
> 

apply *all* patches.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=0f108ae44520

