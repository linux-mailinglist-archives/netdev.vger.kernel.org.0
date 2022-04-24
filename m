Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02C650D375
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiDXQcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiDXQc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:32:28 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DECD9E9E2
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 09:29:27 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id m11so3875443oib.11
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 09:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=7h9/OR15Kl1bK9q+KTH2JZSi7u8Zbhe9edJ//3rox5c=;
        b=QIA/o4DcNOaI8rqVNLOdYju6DuTIa1Pt7X1v8SsDeeoIOIeIX244ZN08in/2Ioegye
         xg1yAHVcESGqNjNFxGjzFoez2vCyncEdBDXsyu1X1tb5rNdFgT0yY4UB+/G+IeCTdW2K
         T6187u/mLWMSJL+o2MFEbOew03TpC7gqGUP3PnC9K41uSdFgplCzrbzsc1kHKTf3axIV
         IImp/JF4cy3yCh+WIe3SbryCLGGe3eUCi+ksOSBML9XiLFT3/q4btzU64hAuTB9+q70o
         rbChtDInVp3j8/XDAm3bzB3uDB8MpLc54lGfgd6aMii5zsXVh2Rtw4v2fWYcrhXF93GE
         rFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7h9/OR15Kl1bK9q+KTH2JZSi7u8Zbhe9edJ//3rox5c=;
        b=svCy1ZVMxEZgjVID7xGMTDVW1jadTAPiUdDxXA+HDIhiYFtiNhSJMmy1BQGVYfXmuG
         pQfzczX2jEqvg1Iq6vPaEeHuwVN257Ycw8KRtibDbbP03Lierx66J6MdacNPlw5nLf9O
         Ian5vfZlXOYLHZCFHiKTVhzfpySsVbC0Q+v+Mv8TkDKoqrp3PM5qbPKvb3gQc6FSnN/P
         ABOwIUqZ0J1lNqN1l0IT/xTIIuG5Xu6y9QMBJqTxK64QeOj1hi2/4ZeR6x++9Um8QmHL
         28E4zt9c4MWOxdeu0livReMFT38uOUJJNAE/hnd9/4WcgSid024lldjiOosEukZg8kok
         y/ig==
X-Gm-Message-State: AOAM53337ci9bYO1DJIXUv2uf6Mh7V885ev5odVODbLVKcNAs2AY+Grp
        N1Qsh/wsW6CIP4ZioEnOMtY=
X-Google-Smtp-Source: ABdhPJxBBbxZB2bwF+TKrbnhVPSMbhPUsZI8Ka+OGH/vVqB2q9NQMb0+VrHe/o1EeBsVlZ1urtcF+w==
X-Received: by 2002:aca:180b:0:b0:2f7:23ae:8cd1 with SMTP id h11-20020aca180b000000b002f723ae8cd1mr10797730oih.146.1650817766682;
        Sun, 24 Apr 2022 09:29:26 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.69])
        by smtp.googlemail.com with ESMTPSA id h21-20020a056808015500b00323c43663e2sm2819581oie.32.2022.04.24.09.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 09:29:26 -0700 (PDT)
Message-ID: <07614827-2527-fc9d-43da-d8a30d987494@gmail.com>
Date:   Sun, 24 Apr 2022 10:29:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v2] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Content-Language: en-US
To:     Roopa Prabhu <roopa@nvidia.com>,
        Jaehee Park <jhpark1013@gmail.com>, outreachy@lists.linux.dev,
        Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
References: <20220421164022.GA3485225@jaehee-ThinkPad-X1-Extreme>
 <c2eb6a8a-531e-7a6e-267c-23577f2e95e8@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <c2eb6a8a-531e-7a6e-267c-23577f2e95e8@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/22 9:48 PM, Roopa Prabhu wrote:
> 
> On 4/21/22 09:40, Jaehee Park wrote:
>> Add a boilerplate test loop to run all tests in
>> vrf_strict_mode_test.sh. Add a -t flag that allows a selected test to
>> run.
>>
>> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
>> ---
> 
> Thanks Jaehee.
> 
> CC, David Ahern
> 
> David, this might be an overkill for this test. But nonetheless a step
> towards bringing some uniformity in the tests.
> 
> next step is to ideally move this to a library to remove repeating this
> boilerplate loop in every test.
> 
> 
> .../selftests/net/vrf_strict_mode_test.sh | 31 ++++++++++++++++++-
> 
>>   1 file changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/net/vrf_strict_mode_test.sh
>> b/tools/testing/selftests/net/vrf_strict_mode_test.sh
>> index 865d53c1781c..ca4379265706 100755
>> --- a/tools/testing/selftests/net/vrf_strict_mode_test.sh
>> +++ b/tools/testing/selftests/net/vrf_strict_mode_test.sh
>> @@ -14,6 +14,8 @@ INIT_NETNS_NAME="init"
>>     PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
>>   +TESTS="init testns mix"
>> +
>>   log_test()
>>   {
>>       local rc=$1
>> @@ -353,6 +355,23 @@ vrf_strict_mode_tests()
>>       vrf_strict_mode_tests_mix
>>   }

Add:

################################################################################
# usage

>>   +usage()
>> +{
>> +    cat <<EOF
>> +usage: ${0##*/} OPTS
>> +
>> +    -t <test> Test(s) to run (default: all)
>> +          (options: $TESTS)
>> +EOF
>> +}

Add:

################################################################################
# main

>> +while getopts ":t:h" opt; do
>> +    case $opt in
>> +        t) TESTS=$OPTARG;;
>> +        h) usage; exit 0;;
>> +        *) usage; exit 1;;
>> +    esac
>> +done
>> +
>>   vrf_strict_mode_check_support()
>>   {
>>       local nsname=$1
>> @@ -391,7 +410,17 @@ fi
>>   cleanup &> /dev/null
>>     setup
>> -vrf_strict_mode_tests
>> +for t in $TESTS
>> +do
>> +    case $t in
>> +    vrf_strict_mode_tests_init|init) vrf_strict_mode_tests_init;;
>> +    vrf_strict_mode_tests_testns|testns) vrf_strict_mode_tests_testns;;
>> +    vrf_strict_mode_tests_mix|mix) vrf_strict_mode_tests_mix;;
>> +
>> +    help) echo "Test names: $TESTS"; exit 0;;
>> +
>> +    esac
>> +done
>>   cleanup
>>     print_log_test_results

This change makes vrf_strict_mode_tests unused. Move the log_section
before the tests in that function to the function handling the test.
e.g., move 'log_section "VRF strict_mode test on init network
namespace"' to vrf_strict_mode_tests_init.

Alsom, make sure you are using tabs for indentation vs spaces.
