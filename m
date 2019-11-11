Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F85F7470
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKKNBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:01:10 -0500
Received: from www62.your-server.de ([213.133.104.62]:46868 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKNBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:01:10 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iU9JV-0002oj-Qs; Mon, 11 Nov 2019 14:01:01 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iU9JV-000Qka-5w; Mon, 11 Nov 2019 14:01:01 +0100
Subject: Re: [PATCH bpf-next 2/2] selftests: bpf: test_tc_edt: add missing
 object file to TEST_FILES
To:     Simon Horman <simon.horman@netronome.com>,
        Anders Roxell <anders.roxell@linaro.org>
Cc:     ast@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        songliubraving@fb.com
References: <20191110092616.24842-1-anders.roxell@linaro.org>
 <20191110092616.24842-2-anders.roxell@linaro.org>
 <20191111124501.alvvekp5owj4daoh@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4ce79d06-e8af-6547-240d-50e3038a6ae7@iogearbox.net>
Date:   Mon, 11 Nov 2019 14:01:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191111124501.alvvekp5owj4daoh@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25630/Mon Nov 11 10:59:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/19 1:45 PM, Simon Horman wrote:
> On Sun, Nov 10, 2019 at 10:26:16AM +0100, Anders Roxell wrote:
>> When installing kselftests to its own directory and running the
>> test_tc_edt.sh it will complain that test_tc_edt.o can't be find.
>>
>> $ ./test_tc_edt.sh
>> Error opening object test_tc_edt.o: No such file or directory
>> Object hashing failed!
>> Cannot initialize ELF context!
>> Unable to load program
>>
>> Rework to add test_tc_edt.o to TEST_FILES so the object file gets
>> installed when installing kselftest.
>>
>> Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ general rule")
>> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
>> Acked-by: Song Liu <songliubraving@fb.com>
> 
> It seems to me that the two patches that comprise this series
> should be combined as they seem to be fixing two halves of the same
> problem.

Yep, agree, please respin as single patch.

Thanks,
Daniel
