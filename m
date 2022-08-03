Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E0158875C
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 08:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbiHCG3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 02:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237191AbiHCG3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 02:29:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9579957247;
        Tue,  2 Aug 2022 23:29:32 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659508171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m1qsL55BteuTwDu3+h+SjLPzdZh13JHKIId3RPSdQyM=;
        b=nKAFnlD7yYR37GqZvxGdY5UrDZHVaUAEKnsresvrhaffvWTJ57auG6QfWFKfzbOc0/bgUQ
        r/J7Cu1MCcCiUyg182UIyYixLklp7bgka1WOqnaSqt7yeg7sJptVjWd6r1QeWl9cS7XWh+
        AIqTfLg83+XhrOj3szZKIh5MVi2Z7crXBDMqyUts3O2yntblQ6yuAzQMKflDEXoRXJynJp
        BSq7rhpfIGe3oICsMu2nieEJ28MtcrQKS0hQrcSBz118t5l2YILoHenOEbh2avgDP5bzH/
        o6B5BsqVIhNN+ZKcpdVTpJv59RWARWmXOsrGkUWF9uOFxGK9gj8Ck37vo/sLhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659508171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m1qsL55BteuTwDu3+h+SjLPzdZh13JHKIId3RPSdQyM=;
        b=fHfVZk7nC1DotnSE/H4xTQkCQNZC669A+3fIPopIrXOXDA2Wk0xVrrDPvkvnRidLMgG172
        TdwTEpaTj+Q+7zDQ==
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
In-Reply-To: <CAADnVQ+aDn9ku8p0M2yaPQb_Qi3CxkcyhHbcKTq8y2hrDP5A8Q@mail.gmail.com>
References: <20220606103734.92423-1-kurt@linutronix.de>
 <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
 <87pmhj15vf.fsf@kurt>
 <CAADnVQ+aDn9ku8p0M2yaPQb_Qi3CxkcyhHbcKTq8y2hrDP5A8Q@mail.gmail.com>
Date:   Wed, 03 Aug 2022 08:29:29 +0200
Message-ID: <87edxxg7qu.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Aug 02 2022, Alexei Starovoitov wrote:
> On Tue, Aug 2, 2022 at 12:06 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>>
>> Hi Alexei,
>>
>> On Tue Jun 07 2022, Alexei Starovoitov wrote:
>> > Anyway I guess new helper bpf_ktime_get_tai_ns() is ok, since
>> > it's so trivial, but selftest is necessary.
>>
>> So, I did write a selftest [1] for testing bpf_ktime_get_tai_ns() and
>> verifying that the access to the clock works. It uses AF_XDP sockets and
>> timestamps the incoming packets. The timestamps are then validated in
>> user space.
>>
>> Since AF_XDP related code is migrating from libbpf to libxdp, I'm
>> wondering if that sample fits into the kernel's selftests or not. What
>> kind of selftest are you looking for?
>
> Please use selftests/bpf framework.
> There are plenty of networking tests in there.
> bpf_ktime_get_tai_ns() doesn't have to rely on af_xdp.

OK.

> It can be skb based.

Something like this?

+++ b/tools/testing/selftests/bpf/prog_tests/check_tai.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022 Linutronix GmbH */
+
+#include <test_progs.h>
+#include <network_helpers.h>
+
+#include <time.h>
+#include <stdint.h>
+
+#define TAI_THRESHOLD	1000000000ULL /* 1s */
+#define NSEC_PER_SEC	1000000000ULL
+
+static __u64 ts_to_ns(const struct timespec *ts)
+{
+	return ts->tv_sec * NSEC_PER_SEC + ts->tv_nsec;
+}
+
+void test_tai(void)
+{
+	struct __sk_buff skb = {
+		.tstamp = 0,
+		.hwtstamp = 0,
+	};
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.ctx_in = &skb,
+		.ctx_size_in = sizeof(skb),
+		.ctx_out = &skb,
+		.ctx_size_out = sizeof(skb),
+	);
+	struct timespec now_tai;
+	struct bpf_object *obj;
+	int ret, prog_fd;
+
+	ret = bpf_prog_test_load("./test_tai.o",
+				 BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
+	if (!ASSERT_OK(ret, "load"))
+		return;
+	ret = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_OK(ret, "test_run");
+
+	/* TAI != 0 */
+	ASSERT_NEQ(skb.tstamp, 0, "tai_ts0_0");
+	ASSERT_NEQ(skb.hwtstamp, 0, "tai_ts0_1");
+
+	/* TAI is moving forward only */
+	ASSERT_GT(skb.hwtstamp, skb.tstamp, "tai_forward");
+
+	/* Check for reasoneable range */
+	ret = clock_gettime(CLOCK_TAI, &now_tai);
+	ASSERT_EQ(ret, 0, "tai_gettime");
+	ASSERT_TRUE((ts_to_ns(&now_tai) - skb.hwtstamp) < TAI_THRESHOLD,
+		    "tai_range");
+
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tai.c b/tools/testing/selftests/bpf/progs/test_tai.c
new file mode 100644
index 000000000000..34ac4175e29d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tai.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022 Linutronix GmbH */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("tc")
+int save_tai(struct __sk_buff *skb)
+{
+	/* Save TAI timestamps */
+	skb->tstamp = bpf_ktime_get_tai_ns();
+	skb->hwtstamp = bpf_ktime_get_tai_ns();
+
+	return 0;
+}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLqFckTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgoZGEACo7ODXo1jnKwFPs8liSbG418EZwe/F
oKWWzarRsYvdFtJZBQu/B19YqalwVDWcvhxjiSvs5jrfnuVMAUXzZe2I0okxYhzk
glU/TvAMQJZuTtSswRreUI2vT4eTs0/DoCTQVTLBfTIHzube/AloFkOCP4wH6DwT
q4oVlnZgejwgn/g4uYfKlHz8Dp+VfH7D2Q/lzxdCclyzMjvGcIRgaK6sgwe7JU9h
91E0o/D00AZt14M+qIvzYQftRYD2Qq7HYJNyZXxcYgylE7/yYb9qMyWbsl7OTlOw
aE7ebxqT/5iMZh22qsRKEiOETBagC7mjFifNhcMm+K7loGS9EvqPjlc/LiBhvHlR
2JdCTEFMAecCwQOfxsFsAKMzJ5+C96nx/8joIrEwzEE4QSAdwA4lz+ZqI5Q86zuI
lU9wts83ikr29InOKZc4jDR6FSc0GN63imiN728dtqjStgprU6Z4OElLCMoSJNAH
2EKleqMXSIbLknzVtEzSMDW1axiBu/Cxy7JxIv8ikasEtA0qUrTIOu84ZG3b3ZBy
alhiXqkiMyJ8BeC7sYRG2YM+Wry9N/XW7c18sR2l0ac0m+J1d4dGzc26y8HstEEk
ffmbsaBsQbvILdL8jJ+nTIyS5BJjdJ+1/isL1vEtJQTssDqo0Bf1J5ZfhgLHVs/Q
Josc5wPsqsJAxQ==
=7TkQ
-----END PGP SIGNATURE-----
--=-=-=--
