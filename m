Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7B28EF52
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 11:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbgJOJYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 05:24:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58682 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgJOJYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 05:24:00 -0400
Received: from mail-ej1-f72.google.com ([209.85.218.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kleber.souza@canonical.com>)
        id 1kSzUL-0007hx-1r
        for netdev@vger.kernel.org; Thu, 15 Oct 2020 09:23:57 +0000
Received: by mail-ej1-f72.google.com with SMTP id j7so818413ejy.7
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 02:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mwtKmR2fNubfkF8A5SPE3kKNfRmuqI9cZpPnRNk3eOA=;
        b=DoJeT08JOrux41rhomFS7hxIHUUREEqSvYM1JgOKR+QkjAGlANFHoxNc3Btw9yJcm4
         v1cpd598h+3QiuUYNKvd3y5f70+7ABNkTrTHJydWQ2ZkcgXquOuW3fygOYbwE257JCcq
         TdpwqoPIVx7RjKay8QlerDN2djd8L8PC1b8Subd2BShv0pyTxbcPD0TDKiVzut6lg22P
         alnKAtcqRB8WUPMF8stGng2DeYbgyTVPfDrek/w+sVDnvfVnCRszeS80VW5zz+BYB+/8
         +olqRlloCHJf+38m71diim1Z3EpshbonOQbGBJiwO3Mkw0wnQjRig1LCvaZIWoKZmDuQ
         OC4g==
X-Gm-Message-State: AOAM531boiqLTVpZn/hPp1Kq0sWXM6I0Jp2d3qZxtFc3f2JjU4ZmLeAM
        4zmwavinKu75lyFVxYXKqB7rtmK0aQMktm/3mDs83hceS6Oue+uq1jOSgtkh3io/8BeTV1EO+hI
        AtiEXyXz8Zdb1zPHxakdzEltxReMKzRXZnw==
X-Received: by 2002:a50:9e87:: with SMTP id a7mr3347409edf.297.1602753836705;
        Thu, 15 Oct 2020 02:23:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpVpqaaU3paTspFtNc0NW+sAXjF1fruo1f8S2mt6XXDAqYN2weUlu44ZjENjuUWrWzN1C1oA==
X-Received: by 2002:a50:9e87:: with SMTP id a7mr3347396edf.297.1602753836445;
        Thu, 15 Oct 2020 02:23:56 -0700 (PDT)
Received: from ?IPv6:2a02:8108:4640:10c0:6cbe:6d37:31ed:e54b? ([2a02:8108:4640:10c0:6cbe:6d37:31ed:e54b])
        by smtp.gmail.com with ESMTPSA id r24sm1152157edm.95.2020.10.15.02.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 02:23:55 -0700 (PDT)
Subject: Re: [PATCH 2/2] Revert "dccp: don't free ccid2_hc_tx_sock struct in
 dccp_disconnect()"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        dccp@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201013171849.236025-1-kleber.souza@canonical.com>
 <20201013171849.236025-3-kleber.souza@canonical.com>
 <20201014204230.56cbfb12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Kleber Souza <kleber.souza@canonical.com>
Autocrypt: addr=kleber.souza@canonical.com; prefer-encrypt=mutual; keydata=
 mQENBFjjmLgBCADW/wnobGtt4lIvs0nkVbvecpvmvH6j7oFy92KxnAVPr4akWmLwLHH8id1k
 tKJlR1KlINf089anZfIK9uC6lFWjlmrg94U+9zZHUlG+MdLeJrqRWJAxqjz2DT3EYq9vDpxt
 uLaZws5EAWvxswa9oTtbwIWA1sqeps5DWUw95zFGeaxS/hisdlywU5G+I/pKLNkwTMyjwICC
 gHuUvCNuuOt5ZDu3i6Z76XKedu6YyWSVquesMzWAt6XO3QTXLB2b67eqalxxbTSHdkzrt5sR
 Ai4BQhr5d3jziYWRK5tPi+nj72/kWv0C12WQqzSFOZ5rYEZu3Ypyu+t4AoTzJ1GpzZEhABEB
 AAG0NktsZWJlciBTYWNpbG90dG8gZGUgU291emEgPGtsZWJlci5zb3V6YUBjYW5vbmljYWwu
 Y29tPokBVwQTAQgAQQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAIZARYhBPLtrW77uQZf
 0wPbYUaq8zVw4RYrBQJd0827BQkG0WiDAAoJEEaq8zVw4RYrQ2wIAKsYBtAMQMO5iAL/soSw
 WtHduzSRllxK1E1bLyO6bc7SlUH5T7am3jCQ+1PyLMZXVkVDz7YJwCTmX3lb/IPjSuRXvBgQ
 05P2IlfIRVd0P2sqQyUGcA5Uahd98z5ZS4jTOLZEOIT6KaQJGXFjQAnJSg5/A6IlCTrRC/2/
 AKCBIyV0rLkuBMlLfVvRmXsjxz/Wi8KNCQ5ZjEUtnE6oIejnFAiyhNOxtDMCfPOh6uSoslp8
 qlqpG5IoJAHYlTCeIak07OoFp8LtkiuGgDnQA2HuhUNt/5YGshPLFRgSFrhLQdW7qCtZRUA7
 +mcJMEuaolhggv4yeDq5WLydwDdDpqUClK+5AQ0EWOOYuAEIAMJqK7zV//x1PaUVVnJiSoEZ
 FBCOoZelEajq4veDVUEUoOvXCVv93aQEnAZtb4wqAlGtZKGn74oaxgVjRLvUIUFWRf+FvcWh
 mzO2geaTmRQ4W5XdFeCymNmuwDVIH90ZjwFFZI5Mc6lFX8k4eBPhxNxXuhM+8rHWpiHVwUap
 /YqYxyvEP88BVrQqZQgwQjGVDE9PNIOwPUsYGdhSd+8lvFP2ygVR3BhlLT9aAJqsGRyQWEuj
 CA5/xyTRi1nfF/cAUQkfFCXHj0Hiddw0zTclBuWdZzqdQZwF64e4OwAy+XtJ6lYeuHM/Ztxg
 ebWFnWILqZLLowCwp2inyZeXC1IuTQcAEQEAAYkBHwQYAQgACQUCWOOYuAIbDAAKCRBGqvM1
 cOEWK2ZQCACByBGwoXsqfSZB+lnkTp5dV1aQ+peC7T+I8GQKVvckFVv3lv73ibm1uBNrnRjO
 A6802JneP1M8Qo8h1olc0iXyXnIpnMz1dZBsj5VJoYRMes6UB96PuafdNKnVo6XYc9xE0QMR
 CIUoZ37nC7gMCgAhM5eY4SjMxjy8aXiNpWt7WGCZoCvRSrWn0CrWGvMriXbqHf5/PHhoOGCR
 rK1PlxFYriuuBtGUP/kAy2rzT4B5NywXrAHg4IrgMxEdYHy6LiutpSRKmFHwO4IAmB8pUrbe
 wJxW6Rkg2c10vzfvPChs8bedvyb8eioU19QS0prjxywrWie6fwT5NqGmE6Nv4+kA
Message-ID: <686668d9-8d7a-1ad1-a210-0b6abaa8dc36@canonical.com>
Date:   Thu, 15 Oct 2020 11:23:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201014204230.56cbfb12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.10.20 05:42, Jakub Kicinski wrote:
> On Tue, 13 Oct 2020 19:18:49 +0200 Kleber Sacilotto de Souza wrote:
>> From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>>
>> This reverts commit 2677d20677314101293e6da0094ede7b5526d2b1.
>>
>> This fixes an issue that after disconnect, dccps_hc_tx_ccid will still be
>> kept, allowing the socket to be reused as a listener socket, and the cloned
>> socket will free its dccps_hc_tx_ccid, leading to a later use after free,
>> when the listener socket is closed.
>>
>> This addresses CVE-2020-16119.
>>
>> Fixes: 2677d2067731 (dccp: don't free ccid2_hc_tx_sock struct in dccp_disconnect())
>> Reported-by: Hadar Manor
> 
> Does this person has an email address?

We have received this report via a private Launchpad bug and the submitter
didn't provide any public email address, so we have only their name.

> 
>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>

