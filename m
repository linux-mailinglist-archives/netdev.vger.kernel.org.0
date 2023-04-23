Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1E6EBE4B
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjDWJbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDWJbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:31:13 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2A01736;
        Sun, 23 Apr 2023 02:31:11 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f86ee42669so3211335f8f.2;
        Sun, 23 Apr 2023 02:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682242270; x=1684834270;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7DjsGg+EctX81SX9/IJNQdK65TEuTZPCWm+kZmYW/Nk=;
        b=FPp6fBkBv/9paP4hbcrxxxBzYdZUqSXmrs84vl8HTtATPmWmTPeGWTx3Y01dAfgIB4
         wYKGL47R6hcxYwBJwnLJ6J6p6vQOhI5xqG6YmWQ+rRriytYpesqwGIn/xlC0K/Bmuz1i
         gbyKiEFwjSXFzpXrqMN0ARW0JNENcLo1TWGGWmZhrBCJsIHF5uab/LeCakrW+TKKRqN6
         tQ626Feyl+GeY+S8rgozUhR+DRr/R1TgCuPwRdZHMEso9eLA397GakZXuy8gGS8adeiD
         hhLmPeRnb7XoeLmYUlhJlCt38ZO2QW/bWx3H9i1iMfWiJ5up624ww+bnSAEcnxXFG4mr
         DCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682242270; x=1684834270;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7DjsGg+EctX81SX9/IJNQdK65TEuTZPCWm+kZmYW/Nk=;
        b=TQitkUzywlXZPM2ZBbVMdZRzK9e/Z3MzBb85r3WjzH+G7ivUIPwvTGwBBh5Cif/uN2
         qFLvvzHJ5BX/2o3zsnFZ1uKG7zS7o/NJsVVLkstPEsk1LPO0TUG+3jMbDVVRUXnaV4uu
         HrpTdfPryDvC+AhY8ryOkkI0PE6cw0J7LtSDoinDx2VsmiDBXHE/s8wJDdPfAc3D5WLM
         eQsgRCIHPZEYcrKO6GHMjXC79GEsTIEYn+El24ifsli/jzWRhoPpUl/I/nDdgS2msQPY
         UUUgQjHoumfPA7ByeSBVBaBsCnxPdqYvn2nCz2bPhZWRnTX5ylTN4Bd1DoZu2BnfblvN
         8odQ==
X-Gm-Message-State: AAQBX9cBfmJ3eGVxM0aS7Nv30s2oPafZGaDoY36ilsnpvECa5N/0Wvx7
        qM3xPwbNEvNkJOUFkVpka80=
X-Google-Smtp-Source: AKy350Z+OQaff5BNcUXtWRRG+r2VL6rpmC0y033PYTvY1+D+SKuwAkkt0tse2C/L/EZKm4RoSQu5vg==
X-Received: by 2002:a5d:4681:0:b0:2f7:b941:94cf with SMTP id u1-20020a5d4681000000b002f7b94194cfmr7306804wrq.17.1682242269654;
        Sun, 23 Apr 2023 02:31:09 -0700 (PDT)
Received: from [192.168.0.157] ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id s9-20020adfdb09000000b00301a351a8d6sm7768796wri.84.2023.04.23.02.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Apr 2023 02:31:09 -0700 (PDT)
Message-ID: <da23eb41-f3b6-16cb-def7-c87388c55423@gmail.com>
Date:   Sun, 23 Apr 2023 12:31:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH bpf,v2 4/4] selftests/bpf: Add tc_socket_lookup tests
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz,
        eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20230420145041.508434-1-gilad9366@gmail.com>
 <20230420145041.508434-5-gilad9366@gmail.com> <ZEFr1M0PDziB2c9g@google.com>
From:   Gilad Sever <gilad9366@gmail.com>
In-Reply-To: <ZEFr1M0PDziB2c9g@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/04/2023 19:44, Stanislav Fomichev wrote:
> On 04/20, Gilad Sever wrote:
>> Verify that socket lookup via TC with all BPF APIs is VRF aware.
>>
>> Signed-off-by: Gilad Sever <gilad9366@gmail.com>
>> ---
>> v2: Fix build by initializing vars with -1
>> ---
>>   .../bpf/prog_tests/tc_socket_lookup.c         | 341 ++++++++++++++++++
>>   .../selftests/bpf/progs/tc_socket_lookup.c    |  73 ++++
>>   2 files changed, 414 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/tc_socket_lookup.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c b/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
>> new file mode 100644
>> index 000000000000..5dcaf0ea3f8c
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
>> @@ -0,0 +1,341 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>> +
>> +/*
>> + * Topology:
>> + * ---------
>> + *     NS1 namespace         |   NS2 namespace
>> + *			     |
>> + *     +--------------+      |   +--------------+
>> + *     |    veth01    |----------|    veth10    |
>> + *     | 172.16.1.100 |      |   | 172.16.1.200 |
>> + *     |     bpf      |      |   +--------------+
>> + *     +--------------+      |
>> + *      server(UDP/TCP)      |
>> + *  +-------------------+    |
>> + *  |        vrf1       |    |
>> + *  |  +--------------+ |    |   +--------------+
>> + *  |  |    veth02    |----------|    veth20    |
>> + *  |  | 172.16.2.100 | |    |   | 172.16.2.200 |
>> + *  |  |     bpf      | |    |   +--------------+
>> + *  |  +--------------+ |    |
>> + *  |   server(UDP/TCP) |    |
>> + *  +-------------------+    |
>> + *
>> + * Test flow
>> + * -----------
>> + *  The tests verifies that socket lookup via TC is VRF aware:
>> + *  1) Creates two veth pairs between NS1 and NS2:
>> + *     a) veth01 <-> veth10 outside the VRF
>> + *     b) veth02 <-> veth20 in the VRF
>> + *  2) Attaches to veth01 and veth02 a program that calls:
>> + *     a) bpf_skc_lookup_tcp() with TCP and tcp_skc is true
>> + *     b) bpf_sk_lookup_tcp() with TCP and tcp_skc is false
>> + *     c) bpf_sk_lookup_udp() with UDP
>> + *     The program stores the lookup result in bss->lookup_status.
>> + *  3) Creates a socket TCP/UDP server in/outside the VRF.
>> + *  4) The test expects lookup_status to be:
>> + *     a) 0 from device in VRF to server outside VRF
>> + *     b) 0 from device outside VRF to server in VRF
>> + *     c) 1 from device in VRF to server in VRF
>> + *     d) 1 from device outside VRF to server outside VRF
>> + */
>> +
>> +#include <net/if.h>
>> +
>> +#include "test_progs.h"
>> +#include "network_helpers.h"
>> +#include "tc_socket_lookup.skel.h"
>> +
>> +#define NS1 "tc_socket_lookup_1"
>> +#define NS2 "tc_socket_lookup_2"
>> +
>> +#define IP4_ADDR_VETH01 "172.16.1.100"
>> +#define IP4_ADDR_VETH10 "172.16.1.200"
>> +#define IP4_ADDR_VETH02 "172.16.2.100"
>> +#define IP4_ADDR_VETH20 "172.16.2.200"
>> +
>> +#define NON_VRF_PORT 5000
>> +#define IN_VRF_PORT 5001
>> +
>> +#define IO_TIMEOUT_SEC	3
>> +
>> +#define SYS(fmt, ...)						\
>> +	({							\
>> +		char cmd[1024];					\
>> +		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
>> +		if (!ASSERT_OK(system(cmd), cmd))		\
>> +			goto fail;				\
>> +	})
>> +
>> +#define SYS_NOFAIL(fmt, ...)					\
>> +	({							\
>> +		char cmd[1024];					\
>> +		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
>> +		system(cmd);					\
>> +	})
> [..]
>
>> +static int make_socket(int sotype, const char *ip, int port,
>> +		       struct sockaddr_storage *addr)
>> +{
>> +	struct timeval timeo = { .tv_sec = IO_TIMEOUT_SEC };
>> +	int err, fd;
>> +
>> +	err = make_sockaddr(AF_INET, ip, port, addr, NULL);
>> +	if (!ASSERT_OK(err, "make_address"))
>> +		return -1;
>> +
>> +	fd = socket(AF_INET, sotype, 0);
>> +	if (!ASSERT_OK(fd < 0, "socket"))
>> +		return -1;
>> +
>> +	err = setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo, sizeof(timeo));
>> +	if (!ASSERT_OK(err, "setsockopt(SO_SNDTIMEO)"))
>> +		goto fail;
>> +
>> +	err = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo, sizeof(timeo));
>> +	if (!ASSERT_OK(err, "setsockopt(SO_RCVTIMEO)"))
>> +		goto fail;
>> +
>> +	return fd;
>> +fail:
>> +	close(fd);
>> +	return -1;
>> +}
>> +
>> +static int make_server(int sotype, const char *ip, int port, const char *ifname)
>> +{
>> +	struct sockaddr_storage addr = {};
>> +	const int one = 1;
>> +	int err, fd = -1;
>> +
>> +	fd = make_socket(sotype, ip, port, &addr);
>> +	if (fd < 0)
>> +		return -1;
>> +
>> +	if (sotype == SOCK_STREAM) {
>> +		err = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one,
>> +				 sizeof(one));
>> +		if (!ASSERT_OK(err, "setsockopt(SO_REUSEADDR)"))
>> +			goto fail;
>> +	}
>> +
>> +	if (ifname) {
>> +		err = setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,
>> +				 ifname, strlen(ifname) + 1);
>> +		if (!ASSERT_OK(err, "setsockopt(SO_BINDTODEVICE)"))
>> +			goto fail;
>> +	}
>> +
>> +	err = bind(fd, (void *)&addr, sizeof(struct sockaddr_in));
>> +	if (!ASSERT_OK(err, "bind"))
>> +		goto fail;
>> +
>> +	if (sotype == SOCK_STREAM) {
>> +		err = listen(fd, SOMAXCONN);
>> +		if (!ASSERT_OK(err, "listen"))
>> +			goto fail;
>> +	}
>> +
>> +	return fd;
>> +fail:
>> +	close(fd);
>> +	return -1;
>> +}
> Any reason you're not using start_server from network_helpers.h?
> It's because I need to bind the server socket to the VRF device.
