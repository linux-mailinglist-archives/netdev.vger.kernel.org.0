Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DA939C79
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 12:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfFHKo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 06:44:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46243 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfFHKo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 06:44:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so4493324wrw.13
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 03:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LwTq/QdEo9S1EorWQWeXguEKoNn3QNRdA3wVTvrf2ro=;
        b=ivtLs9akPS/T2NmT5RSCeqp6b2YNLrsVQVURdYA3FfJ9Tyhc/wWdh8R5JBFT/kmP0e
         AgVsmvhsZDC8OP/QLYPX8oKWecGQZR5nfxcK2T78rPohC/S/aFiJTG5MFNGq8201obzU
         30YOfgahO/SM52JT9aFXJyikYp1J1HeoMYHN1pefMvWbv/jEbGOPlfJC+44jEFFaukyT
         9NannmdRn8nV1MI8JlpWrQBumdUmrkivVOVIslaNzXYZHEXV26+1pQX03ry8ALStUqq4
         TCPiHcs2+d9pV6Twb+9dMgb3bWgBBRr7dPkW8pn2ZwgsOsEUTzpSIhBrL/tkOh0XINRs
         PQaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LwTq/QdEo9S1EorWQWeXguEKoNn3QNRdA3wVTvrf2ro=;
        b=uRKh1zxfT7jN6i3yHfd80WZPjFUsljyzdyoSQD/i3PEgL2QP/16hF5uHijgkNvKY7e
         Q7ZRXsxKF/mOJf9y097WQR47c1q180MoDHEPpLSCVZkv0Qq7uJaqJTPaJawJJAWPq9Vx
         Jl56/pICkeNVh8JGObfP1PHbRDStckZXJSwtMtOtgz5y1GffWGPVaTGfdN6BCFKV1NK+
         Wq/Bc3BJU6ZM6H5ruuU+kpBfiHjznn1r2uymX+MJAF5olbQaiYNIrqvazEYLOZoensHq
         pwqjkKBLYp0MA6r+ylCnrX0PXz8RzYavgI7/TB6+KNCQoebQIkK7YQO83Bnh9oOBYBg0
         KMAw==
X-Gm-Message-State: APjAAAX4qoQ0USILkgmyLMN3YNAMnM8i5H2CKI8ZtMhEIKsT9nuPMlU1
        lt60ljE27+syGDRUXWljt5B3B7IebJc=
X-Google-Smtp-Source: APXvYqwcAJsypQ6CbVMB0O5Bd3ZNDSI89OiEqk7cm44XzGr+VV4RTp/vvd0UUz/zM2dtseme6S83AA==
X-Received: by 2002:a5d:4141:: with SMTP id c1mr22743086wrq.159.1559990696583;
        Sat, 08 Jun 2019 03:44:56 -0700 (PDT)
Received: from [192.168.1.2] ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id q9sm7192108wmq.9.2019.06.08.03.44.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 03:44:55 -0700 (PDT)
Subject: Re: [PATCH net-next 9/9] selftests: ptp: Add Physical Hardware Clock
 test
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-10-idosch@idosch.org>
 <CA+h21hrAzdb0Bnn4dbJqnqRAhgR-3r+DBEYyEUh=_rk6Jh3ouA@mail.gmail.com>
Message-ID: <3ec0658a-0224-39b5-edb5-e34d65c1fc3a@gmail.com>
Date:   Sat, 8 Jun 2019 13:44:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrAzdb0Bnn4dbJqnqRAhgR-3r+DBEYyEUh=_rk6Jh3ouA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/19 2:15 PM, Vladimir Oltean wrote:
> On Mon, 3 Jun 2019 at 15:25, Ido Schimmel <idosch@idosch.org> wrote:
>>
>> From: Shalom Toledo <shalomt@mellanox.com>
>>
>> Test the PTP Physical Hardware Clock functionality using the "phc_ctl" (a
>> part of "linuxptp").
>>
>> The test contains three sub-tests:
>>    * "settime" test
>>    * "adjtime" test
>>    * "adjfreq" test
>>
>> "settime" test:
>>    * set the PHC time to 0 seconds.
>>    * wait for 120.5 seconds.
>>    * check if PHC time equal to 120.XX seconds.
>>
>> "adjtime" test:
>>    * set the PHC time to 0 seconds.
>>    * adjust the time by 10 seconds.
>>    * check if PHC time equal to 10.XX seconds.
>>
>> "adjfreq" test:
>>    * adjust the PHC frequency to be 1% faster.
>>    * set the PHC time to 0 seconds.
>>    * wait for 100.5 seconds.
>>    * check if PHC time equal to 101.XX seconds.
>>
>> Usage:
>>    $ ./phc.sh /dev/ptp<X>
>>
>>    It is possible to run a subset of the tests, for example:
>>      * To run only the "settime" test:
>>        $ TESTS="settime" ./phc.sh /dev/ptp<X>
>>
>> Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
>> Reviewed-by: Petr Machata <petrm@mellanox.com>
>> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>> ---
>>   tools/testing/selftests/ptp/phc.sh | 166 +++++++++++++++++++++++++++++
>>   1 file changed, 166 insertions(+)
>>   create mode 100755 tools/testing/selftests/ptp/phc.sh
>>
>> diff --git a/tools/testing/selftests/ptp/phc.sh b/tools/testing/selftests/ptp/phc.sh
>> new file mode 100755
>> index 000000000000..ac6e5a6e1d3a
>> --- /dev/null
>> +++ b/tools/testing/selftests/ptp/phc.sh
>> @@ -0,0 +1,166 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +ALL_TESTS="
>> +       settime
>> +       adjtime
>> +       adjfreq
>> +"
>> +DEV=$1
>> +
>> +##############################################################################
>> +# Sanity checks
>> +
>> +if [[ "$(id -u)" -ne 0 ]]; then
>> +       echo "SKIP: need root privileges"
>> +       exit 0
>> +fi
>> +
>> +if [[ "$DEV" == "" ]]; then
>> +       echo "SKIP: PTP device not provided"
>> +       exit 0
>> +fi
>> +
>> +require_command()
>> +{
>> +       local cmd=$1; shift
>> +
>> +       if [[ ! -x "$(command -v "$cmd")" ]]; then
>> +               echo "SKIP: $cmd not installed"
>> +               exit 1
>> +       fi
>> +}
>> +
>> +phc_sanity()
>> +{
>> +       phc_ctl $DEV get &> /dev/null
>> +
>> +       if [ $? != 0 ]; then
>> +               echo "SKIP: unknown clock $DEV: No such device"
>> +               exit 1
>> +       fi
>> +}
>> +
>> +require_command phc_ctl
>> +phc_sanity
>> +
>> +##############################################################################
>> +# Helpers
>> +
>> +# Exit status to return at the end. Set in case one of the tests fails.
>> +EXIT_STATUS=0
>> +# Per-test return value. Clear at the beginning of each test.
>> +RET=0
>> +
>> +check_err()
>> +{
>> +       local err=$1
>> +
>> +       if [[ $RET -eq 0 && $err -ne 0 ]]; then
>> +               RET=$err
>> +       fi
>> +}
>> +
>> +log_test()
>> +{
>> +       local test_name=$1
>> +
>> +       if [[ $RET -ne 0 ]]; then
>> +               EXIT_STATUS=1
>> +               printf "TEST: %-60s  [FAIL]\n" "$test_name"
>> +               return 1
>> +       fi
>> +
>> +       printf "TEST: %-60s  [ OK ]\n" "$test_name"
>> +       return 0
>> +}
>> +
>> +tests_run()
>> +{
>> +       local current_test
>> +
>> +       for current_test in ${TESTS:-$ALL_TESTS}; do
>> +               $current_test
>> +       done
>> +}
>> +
>> +##############################################################################
>> +# Tests
>> +
>> +settime_do()
>> +{
>> +       local res
>> +
>> +       res=$(phc_ctl $DEV set 0 wait 120.5 get 2> /dev/null \
>> +               | awk '/clock time is/{print $5}' \
>> +               | awk -F. '{print $1}')
>> +
>> +       (( res == 120 ))
>> +}
>> +
>> +adjtime_do()
>> +{
>> +       local res
>> +
>> +       res=$(phc_ctl $DEV set 0 adj 10 get 2> /dev/null \
>> +               | awk '/clock time is/{print $5}' \
>> +               | awk -F. '{print $1}')
>> +
>> +       (( res == 10 ))
>> +}
>> +
>> +adjfreq_do()
>> +{
>> +       local res
>> +
>> +       # Set the clock to be 1% faster
>> +       res=$(phc_ctl $DEV freq 10000000 set 0 wait 100.5 get 2> /dev/null \
>> +               | awk '/clock time is/{print $5}' \
>> +               | awk -F. '{print $1}')
>> +
>> +       (( res == 101 ))
>> +}
>> +
>> +##############################################################################
>> +
>> +cleanup()
>> +{
>> +       phc_ctl $DEV freq 0.0 &> /dev/null
>> +       phc_ctl $DEV set &> /dev/null
>> +}
>> +
>> +settime()
>> +{
>> +       RET=0
>> +
>> +       settime_do
>> +       check_err $?
>> +       log_test "settime"
>> +       cleanup
>> +}
>> +
>> +adjtime()
>> +{
>> +       RET=0
>> +
>> +       adjtime_do
>> +       check_err $?
>> +       log_test "adjtime"
>> +       cleanup
>> +}
>> +
>> +adjfreq()
>> +{
>> +       RET=0
>> +
>> +       adjfreq_do
>> +       check_err $?
>> +       log_test "adjfreq"
>> +       cleanup
>> +}
>> +
>> +trap cleanup EXIT
>> +
>> +tests_run
>> +
>> +exit $EXIT_STATUS
>> --
>> 2.20.1
>>
> 
> Cool testing framework, thanks!
> Some things to consider:
> - Why the .5 in the wait commands?
> - I suspect there's a huge margin of inaccuracy that the test is
> missing by only looking at the 'seconds' portion of the PHC time after
> the adjfreq operation (up to 10^9 - 1 ppb, in the worst case).
> 
> Tested-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Regards,
> -Vladimir
> 

Here, I was actually thinking about something like this:

check_with_tolerance()
{
	local res=$1
	local expected=$2
	local ppb=$3
	local expected_min=$(($expected - (($expected * $ppb) / 1000000000)))
	local expected_max=$(($expected + (($expected * $ppb) / 1000000000)))

	if [ $res -lt $expected_min ]; then
		printf "%d is more than %d ppb lower than expected %d (%d)\n" \
			$res $ppb $expected $expected_min
		return 1
	elif [ $res -gt $expected_max ]; then
		printf "%d is more than %d ppb higher than expected %d (%d)\n" \
			$res $ppb $expected $expected_max
		return 1;
	else
		printf "%d is within the +/-%d ppb tolerance of %d (%d - %d)\n" \
			$res $ppb $expected $expected_min $expected_max
		return 0;
	fi
}

settime_do()
{
	local res

	res=$(phc_ctl $DEV set 0 wait 120 get 2> /dev/null \
		 | awk '/clock time is/{print $5}' \
		 | awk -F. '{print $1 * 1000000000 + $2}')

	check_with_tolerance $res 120000000000 10000
}

adjtime_do()
{
	local res

	res=$(phc_ctl $DEV set 0 adj 10 get 2> /dev/null \
		 | awk '/clock time is/{print $5}' \
		 | awk -F. '{print $1 * 1000000000 + $2}')

	check_with_tolerance $res 10000000000 10000
}

adjfreq_do()
{
	local res

	# Set the clock to be 1% faster
	res=$(phc_ctl $DEV freq 10000000 set 0 wait 100 get 2> /dev/null \
		 | awk '/clock time is/{print $5}' \
		 | awk -F. '{print $1 * 1000000000 + $2}')

	check_with_tolerance $res 101000000000 10000
}


With the above changes:

SJA1105 hardware clock operations (not the timecounter ones that I 
submitted):

# ./phc.sh /dev/ptp1
119999611352 is within the +/-1000000 ppb tolerance of 120000000000 
(119880000000 - 120120000000)
TEST: settime                                                 [ OK ]
10001018472 is within the +/-1000000 ppb tolerance of 10000000000 
(9990000000 - 10010000000)
TEST: adjtime                                                 [ OK ]
100998300984 is within the +/-1000000 ppb tolerance of 101000000000 
(100899000000 - 101101000000)
TEST: adjfreq                                                 [ OK ]

But at a lower tolerance of 10000 ppb:

[root@OpenIL:~]# ./phc.sh /dev/ptp1
119998277344 is more than 10000 ppb lower than expected 120000000000 
(119998800000)
TEST: settime                                                 [FAIL]
10002033840 is more than 10000 ppb higher than expected 10000000000 
(10000100000)
TEST: adjtime                                                 [FAIL]
100998295304 is more than 10000 ppb lower than expected 101000000000 
(100998990000)
TEST: adjfreq                                                 [FAIL]

For reference, ptp_qoriq:

[root@OpenIL:~]# ./phc.sh /dev/ptp0
120000960470 is within the +/-10000 ppb tolerance of 120000000000 
(119998800000 - 120001200000)
TEST: settime                                                 [ OK ]
10000699770 is more than 10000 ppb higher than expected 10000000000 
(10000100000)
TEST: adjtime                                                 [FAIL]
101000211269 is within the +/-10000 ppb tolerance of 101000000000 
(100998990000 - 101001010000)
TEST: adjfreq                                                 [ OK ]

Regards,
-Vladimir
