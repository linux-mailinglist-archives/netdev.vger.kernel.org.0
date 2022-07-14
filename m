Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C3D574110
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 03:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiGNB42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 21:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiGNB41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 21:56:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AAA186E7;
        Wed, 13 Jul 2022 18:56:26 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so989693pjl.4;
        Wed, 13 Jul 2022 18:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/HwVTDi+4NLrssqr45u1MZ4AuJzAIfp0c8yWZrK3Dyc=;
        b=kVnUL1AJG/0K+SKHHWX21xULfOGbwWHV+QMbcVWKzAkQsPYF++1KdkSUJtffea4M7X
         NSdJnvR4WJLIjpklZxIpmheo+1P6BNPqzMm+3pn2qNEyyyxQt41LhWrYRai8N8qOOv36
         Q2yLYQKzVJRwl3pgya3UMS3lm/RHCNn+drYJ5igao/jEshMWvbur/OO46Vee2Lgmny3q
         lVBdH/U13HprcFFC97KGbYrlm2ugz6aFW5E9FskiHcVUEOu2+jZZknYoDjcvCVYZcj6i
         MNynCXFp6sDrNesdli9aYvfz6NKPywv3CdowyLWltPI9sDsaQt/P5lhZCUq/FithbRHr
         HECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/HwVTDi+4NLrssqr45u1MZ4AuJzAIfp0c8yWZrK3Dyc=;
        b=FeoQXhGruKYODDYEFiKTR5GGF2iZbRmamzCPJydhXJXwdTgUvQDscrrusa+vVshjOa
         TGIXq/MdZDON/kcdjhx6/aybaboPJPeNaxhwGlJETFfx2wv/bnhMt1cxHotROPBGUP9Q
         hUv4HGCSa26MiSdgTLQe6lSrkp8ZxVHzvSRZY0MSlcz9cY4U1rUISHZS3ITEKbuc9dAp
         vpoLfp2rekyw0mV/UUBOJGB7SH5lDhhZLOHUNbP1gX4cpqKrS42///OQx7ryWkY/pFke
         nxhMlomNrLaZUdYpAGbdxNN004eQsb1hroR1uSSU5x8OvfsULVt93sRh7SuhOtKDgECH
         yqMA==
X-Gm-Message-State: AJIora/aUGi2ysx28d5hbED3OiTnojuMt8cH/Z2gLMl0a15iGnmegSit
        IHfe6WHbWteYStytnSos3Z0=
X-Google-Smtp-Source: AGRyM1sMPTNT1B/8Mj5lKjn2UDW1iizkOcWz+81Nbwm0kw6fNaOtyH1c2flAesrVmp04RtiW9aYpTw==
X-Received: by 2002:a17:902:ebc1:b0:168:fd13:8adc with SMTP id p1-20020a170902ebc100b00168fd138adcmr5973551plg.161.1657763786128;
        Wed, 13 Jul 2022 18:56:26 -0700 (PDT)
Received: from [192.168.42.10] ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id b3-20020a170902650300b0016a0bf0ce32sm101883plk.70.2022.07.13.18.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 18:56:25 -0700 (PDT)
Message-ID: <c13ea117-c0e9-418f-62ab-11f141abff8a@gmail.com>
Date:   Thu, 14 Jul 2022 09:56:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] selftests/bpf: Return true/false (not 1/0) from bool
 functions
Content-Language: en-US
To:     sdf@google.com
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        xiaolinkui@kylinos.cn, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20220713011000.29090-1-xiaolinkui@kylinos.cn>
 <Ys7rAaRKbTEzvjFY@google.com>
From:   Linkui Xiao <xiaolinkui@gmail.com>
In-Reply-To: <Ys7rAaRKbTEzvjFY@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your suggestion, I'll clean it up

On 7/13/22 23:55, sdf@google.com wrote:
> On 07/13, xiaolinkui wrote:
>> From: Linkui Xiao<xiaolinkui@kylinos.cn>
>                    ^ space here?
>
>> Return boolean values ("true" or "false") instead of 1 or 0 from bool
>> functions.  This fixes the following warnings from coccicheck:
>
>> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:407:9-10: WARNING:
>> return of 0/1 in function 'decap_v4' with return type bool
>> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:389:9-10: WARNING:
>> return of 0/1 in function 'decap_v6' with return type bool
>> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:290:9-10: WARNING:
>> return of 0/1 in function 'encap_v6' with return type bool
>> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:264:9-10: WARNING:
>> return of 0/1 in function 'parse_tcp' with return type bool
>> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:242:9-10: WARNING:
>> return of 0/1 in function 'parse_udp' with return type bool
>
>> Generated by: scripts/coccinelle/misc/boolreturn.cocci
>
>> Signed-off-by: Linkui Xiao<xiaolinkui@kylinos.cn>
>
> This patch likely needs a resend with proper [PATCH bpf] or
> [PATCH bpf-next] subject to end up in patchwork and to be picked up.
>
> Take a look at Documentation/bpf/bpf_devel_QA.rst section "Q: How do I
> indicate which tree (bpf vs. bpf-next) my patch should be applied to?".
>
> Since that's a cleanup, you most likely want to target bpf-next.
>
>> ---
>>   .../selftests/bpf/progs/test_xdp_noinline.c   | 30 +++++++++----------
>>   1 file changed, 15 insertions(+), 15 deletions(-)
>
>> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c 
>> b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
>> index 125d872d7981..ba48fcb98ab2 100644
>> --- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
>> @@ -239,7 +239,7 @@ bool parse_udp(void *data, void *data_end,
>>       udp = data + off;
>
>>       if (udp + 1 > data_end)
>> -        return 0;
>> +        return false;
>>       if (!is_icmp) {
>>           pckt->flow.port16[0] = udp->source;
>>           pckt->flow.port16[1] = udp->dest;
>> @@ -247,7 +247,7 @@ bool parse_udp(void *data, void *data_end,
>>           pckt->flow.port16[0] = udp->dest;
>>           pckt->flow.port16[1] = udp->source;
>>       }
>> -    return 1;
>> +    return true;
>>   }
>
>>   static __attribute__ ((noinline))
>> @@ -261,7 +261,7 @@ bool parse_tcp(void *data, void *data_end,
>
>>       tcp = data + off;
>>       if (tcp + 1 > data_end)
>> -        return 0;
>> +        return false;
>>       if (tcp->syn)
>>           pckt->flags |= (1 << 1);
>>       if (!is_icmp) {
>> @@ -271,7 +271,7 @@ bool parse_tcp(void *data, void *data_end,
>>           pckt->flow.port16[0] = tcp->dest;
>>           pckt->flow.port16[1] = tcp->source;
>>       }
>> -    return 1;
>> +    return true;
>>   }
>
>>   static __attribute__ ((noinline))
>> @@ -287,7 +287,7 @@ bool encap_v6(struct xdp_md *xdp, struct 
>> ctl_value *cval,
>>       void *data;
>
>>       if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
>> -        return 0;
>> +        return false;
>>       data = (void *)(long)xdp->data;
>>       data_end = (void *)(long)xdp->data_end;
>>       new_eth = data;
>> @@ -295,7 +295,7 @@ bool encap_v6(struct xdp_md *xdp, struct 
>> ctl_value *cval,
>>       old_eth = data + sizeof(struct ipv6hdr);
>>       if (new_eth + 1 > data_end ||
>>           old_eth + 1 > data_end || ip6h + 1 > data_end)
>> -        return 0;
>> +        return false;
>>       memcpy(new_eth->eth_dest, cval->mac, 6);
>>       memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
>>       new_eth->eth_proto = 56710;
>> @@ -314,7 +314,7 @@ bool encap_v6(struct xdp_md *xdp, struct 
>> ctl_value *cval,
>>       ip6h->saddr.in6_u.u6_addr32[2] = 3;
>>       ip6h->saddr.in6_u.u6_addr32[3] = ip_suffix;
>>       memcpy(ip6h->daddr.in6_u.u6_addr32, dst->dstv6, 16);
>> -    return 1;
>> +    return true;
>>   }
>
>>   static __attribute__ ((noinline))
>> @@ -335,7 +335,7 @@ bool encap_v4(struct xdp_md *xdp, struct 
>> ctl_value *cval,
>>       ip_suffix <<= 15;
>>       ip_suffix ^= pckt->flow.src;
>>       if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
>> -        return 0;
>> +        return false;
>>       data = (void *)(long)xdp->data;
>>       data_end = (void *)(long)xdp->data_end;
>>       new_eth = data;
>> @@ -343,7 +343,7 @@ bool encap_v4(struct xdp_md *xdp, struct 
>> ctl_value *cval,
>>       old_eth = data + sizeof(struct iphdr);
>>       if (new_eth + 1 > data_end ||
>>           old_eth + 1 > data_end || iph + 1 > data_end)
>> -        return 0;
>> +        return false;
>>       memcpy(new_eth->eth_dest, cval->mac, 6);
>>       memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
>>       new_eth->eth_proto = 8;
>> @@ -367,8 +367,8 @@ bool encap_v4(struct xdp_md *xdp, struct 
>> ctl_value *cval,
>>           csum += *next_iph_u16++;
>>       iph->check = ~((csum & 0xffff) + (csum >> 16));
>>       if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
>> -        return 0;
>> -    return 1;
>> +        return false;
>> +    return true;
>>   }
>
>>   static __attribute__ ((noinline))
>> @@ -386,10 +386,10 @@ bool decap_v6(struct xdp_md *xdp, void **data, 
>> void **data_end, bool inner_v4)
>>       else
>>           new_eth->eth_proto = 56710;
>>       if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct ipv6hdr)))
>> -        return 0;
>> +        return false;
>>       *data = (void *)(long)xdp->data;
>>       *data_end = (void *)(long)xdp->data_end;
>> -    return 1;
>> +    return true;
>>   }
>
>>   static __attribute__ ((noinline))
>> @@ -404,10 +404,10 @@ bool decap_v4(struct xdp_md *xdp, void **data, 
>> void **data_end)
>>       memcpy(new_eth->eth_dest, old_eth->eth_dest, 6);
>>       new_eth->eth_proto = 8;
>>       if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
>> -        return 0;
>> +        return false;
>>       *data = (void *)(long)xdp->data;
>>       *data_end = (void *)(long)xdp->data_end;
>> -    return 1;
>> +    return true;
>>   }
>
>>   static __attribute__ ((noinline))
>> -- 
>> 2.17.1
>
