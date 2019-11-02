Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0347FECF29
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKBOeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 10:34:18 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:37741 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfKBOeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 10:34:17 -0400
Received: by mail-il1-f195.google.com with SMTP id s5so828478iln.4;
        Sat, 02 Nov 2019 07:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QqxgrxraiNr6QGsrgDTomSVloF/MS9ElgqG76PnzehY=;
        b=r/mfm+mWDrzuVQG/CuFZG/XSqiDA5eaAoi0rvCSicKpZKr+P8To1mRqKRETXj66KQi
         gDpYv7MSZ8Reh8XoMdkjefThjk3J3nrRfpgKF29ldlv7RSEkFIph7k4J8iRGOxxPa6qE
         +QZS9GIXyxOYhbUyaw3OeD/7FQngsn26IjEGyIvPr38wY1yCvgXYaY5+U77oS1GRH5SO
         5GDys2nCsvJ3mfcAslrHRsYnC3HJgTAhALWY6PilAdgebYsA164BhOE6ahNoLBh+HTBw
         kSjrMlUF0ZSivAU2YlI2y8UDZyQ4sft+M2rjAOQvYc5SbZ7VfIv9HKv2GR3iPswX9aLF
         6sLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QqxgrxraiNr6QGsrgDTomSVloF/MS9ElgqG76PnzehY=;
        b=dCNAShXw7jsljrsirDcDm4ug8b1bPYImgU/TUV3H4Bs1KB4gYujhG/CjNB2I8A+T1M
         61nbzrFIxbl7dfWD5eWGRm+ltwCd9UgXqxl2hrCFqHrSf81pP0EXWD8K781S7yhx+idw
         +9Sq9IeBzKvBG28ZirW8/W7hNy6X9TiLTvvGKheoqQJEgrbWz5Wq1+1Gq/mAWW61mTRQ
         44EEiD6ljVSg6ckCnhwfgpqm1mUdMgvNxbWF0u+NJ5ct3AlSPAqdPuTAijP3CpBm3ObM
         zmK6yfy/+g1EZIO9ZMuijlzJfaTQ4f4fuk5/Weg74mpnivjllaH/wMrwxPyLvVyMWhsw
         +VIg==
X-Gm-Message-State: APjAAAUrUWVsp+95wDqGGqD07joubu94mf4YdiTQJhhG778SBiQ+AUGy
        BqkjM/lUBH5+xCetTPJb7pcugzAr
X-Google-Smtp-Source: APXvYqwNH5hBBbCUltn6ko4oDbi192evu5qEPmqOOiFdwrpxkIMxdwMqCuAQRy1jhUdykTFas6m5nw==
X-Received: by 2002:a92:1642:: with SMTP id r63mr19452726ill.83.1572705256328;
        Sat, 02 Nov 2019 07:34:16 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d194:3543:ed5:37ec])
        by smtp.googlemail.com with ESMTPSA id e13sm98378iom.50.2019.11.02.07.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2019 07:34:15 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] selftest: net: add icmp reply address test
To:     Francesco Ruggeri <fruggeri@arista.com>, davem@davemloft.net,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20191101233408.BC15495C0902@us180.sjc.aristanetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0a03def6-3ea0-090f-048f-877700836df2@gmail.com>
Date:   Sat, 2 Nov 2019 08:34:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191101233408.BC15495C0902@us180.sjc.aristanetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/19 5:34 PM, Francesco Ruggeri wrote:
> Verify that in this scenario
> 
>                    1.0.3.1/24
> ---- 1.0.1.3/24    1.0.1.1/24 ---- 1.0.2.1/24    1.0.2.4/24 ----
> |H1|--------------------------|R1|--------------------------|H2|
> ----            N1            ----            N2            ----
> 
> where 1.0.3.1/24 and 1.0.1.1/24 are respectively R1's primary and
> secondary address on N1, traceroute from H1 to H2 show 1.0.1.1
> 
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
> ---
>  tools/testing/selftests/net/Makefile          |   2 +-
>  .../testing/selftests/net/icmp_reply_addr.sh  | 106 ++++++++++++++++++
>  2 files changed, 107 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/net/icmp_reply_addr.sh
> 

Hi:

It would be better to combine both of these into a single test script;
the topology and setup are very similar and the scripts share a lot of
common code.

The script can be a generic traceroute.sh and then contain 2 tests:
1. IPv4 - verify reply address test,
2. IPv6 - verify reply address test.

Making 1 script with multiple tests allows other tests to be added in
the future with less overhead. This is how other tests under net are done.

Also, you still have these using macvlan devices. The intent is to use
network namespaces to mimic nodes in a network. As such veth pairs are a
better option for this intent.

There are 2 scripts under net (l2tp.sh and fcnal-test.sh) that contain
functions -- create_ns and connect_ns  -- that really reduce the
overhead of creating tests like this. Actually you could copy l2tp.sh to
traceroute.sh and quickly update it for these tests.

