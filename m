Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C4157218B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 19:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiGLRFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 13:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiGLRFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 13:05:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E04DBFAF1;
        Tue, 12 Jul 2022 10:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657645550; x=1689181550;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=rPxMZ+Vw5uzO4+6HpSJz1lqVx99t6Z9trYQCIx/TXKA=;
  b=mJpu+NKIV3fcJpi5eB03XT7mn5lVUTCWDJb97ALuikap2G6s7KPDmBgm
   S7W6FKLT8FLWYCRc2Tt77e8Xant6f/NmmOSUU+0I86iW+RkPgOxM9sq0c
   FmwWa6Sm4gTbWBze/djyGjVHDOaM5ZeVvM/oQDWl9j4unEHXy4ugB5xkf
   CATjjsR+R//eCgCwRnDpzZv+sKmRvAbr2gsEmWmboQKwvnnfiapB1sOUO
   PMjl7A7TOFeUvDFMaQq8camJ1MdPCpljUhyNM4M9Og9zO2TGdYUT79I9u
   oVsPSp0A+XdcP+soYAbuz0BcfcNkSwDYAyfdUgGl8wDu41T8h50G358Jj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285733892"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="285733892"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 10:05:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="663024910"
Received: from eklong-mobl.amr.corp.intel.com ([10.209.68.103])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 10:05:47 -0700
Date:   Tue, 12 Jul 2022 10:05:47 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
cc:     Jiri Olsa <olsajiri@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
Subject: Re: [PATCH bpf-next] mptcp: Add struct mptcp_sock definition when
 CONFIG_MPTCP is disabled
In-Reply-To: <23fa8509-5b2d-6263-1543-443c9c896348@tessares.net>
Message-ID: <d8cecd5-64b-5e5f-3fa-93dbbef3c2@linux.intel.com>
References: <20220711130731.3231188-1-jolsa@kernel.org> <6d3b3bf-2e29-d695-87d7-c23497acc81@linux.intel.com> <5710e8f7-6c09-538f-a636-2ea1863ab208@tessares.net> <Ys1lKqF1GL/T6mBz@krava> <23fa8509-5b2d-6263-1543-443c9c896348@tessares.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1561649209-1657645548=:60884"
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1561649209-1657645548=:60884
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 12 Jul 2022, Matthieu Baerts wrote:

> Hi Jiri,
>
> On 12/07/2022 14:12, Jiri Olsa wrote:
>> On Tue, Jul 12, 2022 at 11:06:38AM +0200, Matthieu Baerts wrote:
>>> Hi Jiri, Mat,
>>>
>>> On 11/07/2022 23:21, Mat Martineau wrote:
>>>> On Mon, 11 Jul 2022, Jiri Olsa wrote:
>>>>
>>>>> The btf_sock_ids array needs struct mptcp_sock BTF ID for
>>>>> the bpf_skc_to_mptcp_sock helper.
>>>>>
>>>>> When CONFIG_MPTCP is disabled, the 'struct mptcp_sock' is not
>>>>> defined and resolve_btfids will complain with:
>>>>>
>>>>>  BTFIDS  vmlinux
>>>>> WARN: resolve_btfids: unresolved symbol mptcp_sock
>>>>>
>>>>> Adding empty difinition for struct mptcp_sock when CONFIG_MPTCP
>>>>> is disabled.
>>>>>
>>>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>>>> ---
>>>>> include/net/mptcp.h | 4 ++++
>>>>> 1 file changed, 4 insertions(+)
>>>>>
>>>>> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
>>>>> index ac9cf7271d46..25741a52c666 100644
>>>>> --- a/include/net/mptcp.h
>>>>> +++ b/include/net/mptcp.h
>>>>> @@ -59,6 +59,10 @@ struct mptcp_addr_info {
>>>>>     };
>>>>> };
>>>>>
>>>>> +#if !IS_ENABLED(CONFIG_MPTCP)
>>>>> +struct mptcp_sock { };
>>>>> +#endif
>>>>
>>>> The only use of struct mptcp_sock I see with !CONFIG_MPTCP is from this
>>>> stub at the end of mptcp.h:
>>>>
>>>> static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock
>>>> *sk) { return NULL; }
>>>>
>>>> It's normally defined in net/mptcp/protocol.h for the MPTCP subsystem code.
>>>>
>>>> The conditional could be added on the line before the stub to make it
>>>> clear that the empty struct is associated with that inline stub.
>>>
>>> If this is required only for this specific BPF function, why not
>>> modifying this stub (or add a define) to return "void *" instead of
>>> "struct mptcp_sock *"?
>>
>> so btf_sock_ids array needs BTF ID for 'struct mptcp_sock' and if CONFIG_MPTCP
>> is not enabled, then resolve_btfids (which resolves and populate all BTF IDs)
>> won't find it and will complain
>>
>> btf_sock_ids keeps all socket IDs regardles the state of their CONFIG options,
>> and relies that sock structs are defined even if related CONFIG option is disabled
>
> Thank you for the explanation. I didn't know about that.
>
> Then it is fine for me to leave it in mptcp.h. If it is not directly
> linked to bpf_mptcp_sock_from_subflow(), I guess it can stay there but
> maybe better to wait for Mat's answer about that.
>
>> if that is false assumption then maybe we need to make btf_sock_ids values optional
>> somehow
>

I'd rather keep the full mptcp_sock definition in net/mptcp/protocol.h 
since moving it would require also moving a few other structs it depends 
on.

Defining the empty struct in mptcp.h is fine with me and it sounds like 
that meets the needs of btf_sock_ids - but I'd like a v2 of this patch 
that moves the new empty struct declaration next to the inline 
btf_mptcp_sock_from_subflow function in mptcp.h

--
Mat Martineau
Intel
--0-1561649209-1657645548=:60884--
