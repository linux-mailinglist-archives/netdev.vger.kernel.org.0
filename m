Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D04D1287AE
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfLUFwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:52:35 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42687 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:52:35 -0500
Received: by mail-lf1-f65.google.com with SMTP id y19so8631190lfl.9;
        Fri, 20 Dec 2019 21:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=in-reply-to:references:thread-topic:user-agent:mime-version
         :content-transfer-encoding:subject:from:date:to:cc:message-id;
        bh=+uQX5kulqv/PKGmB7gvcQnAHsnEH4BjCPKMdEA66DhA=;
        b=otWN34AKR9/4GhBBMaNPWfvw/sRWx3NG0rXGh+r0iWveDnD9yWkOBG2mHcN+w+94qd
         5Y50q/Pd/XLamntpsiDbm5u5Dnl7I1Qj40IhThgRzyVTxYYPQcR/KytKiU++1a6t54Ma
         nfM+yIT1Bwna32NYkUO5hp7/22kCxjzqlhYQwYka7P1vLP9dswJokXBoDxZZz0s1Cdjw
         0/t5NydFSrur7r/Dt+7nKRoTQ0PGCCgoav2ZD/Ko9eKdFxv68M/BlNY9H8sk8ifVRM46
         FymQsgEdON+dqgqw0zAL1HoTFfvG3eII64kBM2pJWTK/KuP7FtHvrkbedml9p9Ir3o+E
         +4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:in-reply-to:references:thread-topic:user-agent
         :mime-version:content-transfer-encoding:subject:from:date:to:cc
         :message-id;
        bh=+uQX5kulqv/PKGmB7gvcQnAHsnEH4BjCPKMdEA66DhA=;
        b=IQjcxjRuz7xtd+eZTLWQXo3jX87iKo0TSOnOi45YiNODHPGtlJrx/a2BMCLJGNyos8
         AfHDMJ1rGbw5tU3iXo7qmnONTk3ew/wAcWTlVnEXySANzAcEXL+CU1oNKTuDko2Q517R
         5iT5kfwCftHIke4FW84PKOjgM0OGJY231HrAyJl7p08SWRUISxzviTwmFRcASMY3pmdS
         OwU/3kGNy2F+6qYWSVwR7eYo+v0TBjw56XVo6fI3EoQZaxCZ4/tDW9v9eIeZjIG+zSAO
         vJ7SsvkFcFXOXD+XNQE+w8O6r8dQDEyTKFhJikPDu89NbmVRn7EO5jpHtpxvSbvoYWrL
         jafA==
X-Gm-Message-State: APjAAAXLICpL4hV5ry0h/uc20mgx/y/qwtWDvivmBXrmxB4Csp6czq7e
        K8oqRtDHuSNccLC6CmUwWEM=
X-Google-Smtp-Source: APXvYqwu5aNgUwrk2a86bwIBU1pegdWazhY028npX6sMTCYZ21s//iuTiT6/s59fopa+2hzThKRPDg==
X-Received: by 2002:a05:6512:4c6:: with SMTP id w6mr11314398lfq.157.1576907552911;
        Fri, 20 Dec 2019 21:52:32 -0800 (PST)
Received: from [169.254.1.1] ([109.232.240.14])
        by smtp.gmail.com with ESMTPSA id o69sm4911804lff.14.2019.12.20.21.52.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Dec 2019 21:52:32 -0800 (PST)
In-Reply-To: <20191220161756.GE5058@localhost.localdomain>
References: <20191220044703.88-1-qdkevin.kou@gmail.com> <20191220161756.GE5058@localhost.localdomain>
X-Referenced-Uid: 11
Thread-Topic: Re: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
User-Agent: Android
X-Is-Generated-Message-Id: true
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Local-Message-Id: <2f449128-7175-4759-b1cb-ccf7d2edadb5@gmail.com>
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
From:   kevin kou <qdkevin.kou@gmail.com>
Date:   Sat, 21 Dec 2019 13:52:22 +0800
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <2f449128-7175-4759-b1cb-ccf7d2edadb5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As this trace used to trace the changes of SCTP association state in respon=
se to incoming packets(SACK)=2E It is used for debugging SCTP congestion co=
ntrol algorithms, so according to the code in include/trace/events/sctp=2Eh=
, this trace event only prints the below information, and seems it is hard =
to point out if the SACK is duplicate one=2E=C2=A0



TP_printk("asoc=3D%#l=
lx%s ipaddr=3D%pISpc state=3D%u cwnd=3D%u ssthresh=3D%u " "flight_size=3D%u=
 partial_bytes_acked=3D%u pathmtu=3D%u", __entry->asoc, __entry->primary ? =
"(*)" : "", __entry->ipaddr, __entry->state, __entry->cwnd, __entry->ssthre=
sh, __entry->flight_size, __entry->partial_bytes_acked, __entry->pathmtu)

=

2019=E5=B9=B412=E6=9C=8821=E6=97=A5 00:18, 00:18=EF=BC=8C=E5=9C=A8 Marcelo=
 Ricardo Leitner <marcelo=2Eleitner@gmail=2Ecom> =E5=B7=B2=E5=86=99:
>On Fr=
i, Dec 20, 2019 at 04:47:03AM +0000, Kevin Kou wrote:
>> The function sctp_=
sf_eat_sack_6_2 now performs
>> the Verification Tag validation, Chunk leng=
th validation, Bogu check,
>> and also the detection of out-of-order SACK b=
ased on the RFC2960
>> Section 6=2E2 at the beginning, and finally performs=
 the further
>> processing of SACK=2E The trace_sctp_probe now triggered be=
fore
>> the above necessary validation and check=2E
>> 
>> This patch is to=
 do the trace_sctp_probe after the necessary check
>> and validation to SAC=
K=2E
>> 
>> Signed-off-by: Kevin Kou <qdkevin=2Ekou@gmail=2Ecom>
>> ---
>> =
 net/sctp/sm_statefuns=2Ec | 3 ++-
>>  1 file changed, 2 insertions(+), 1 d=
eletion(-)
>> 
>> diff --git a/net/sctp/sm_statefuns=2Ec b/net/sctp/sm_stat=
efuns=2Ec
>> index 42558fa=2E=2Eb4a54df 100644
>> --- a/net/sctp/sm_statefu=
ns=2Ec
>> +++ b/net/sctp/sm_statefuns=2Ec
>> @@ -3281,7 +3281,6 @@ enum sct=
p_disposition
>sctp_sf_eat_sack_6_2(struct net *net,
>>  	struct sctp_sackh=
dr *sackh;
>>  	__u32 ctsn;
>>  
>> -	trace_sctp_probe(ep, asoc, chunk);
>>=
  
>>  	if (!sctp_vtag_verify(chunk, asoc))
>>  		return sctp_sf_pdiscard(n=
et, ep, asoc, type, arg, commands);
>> @@ -3319,6 +3318,8 @@ enum sctp_disp=
osition
>sctp_sf_eat_sack_6_2(struct net *net,
>>  	if (!TSN_lt(ctsn, asoc-=
>next_tsn))
>>  		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, c=
ommands);
>>  
>> +	trace_sctp_probe(ep, asoc, chunk);
>> +
>
>Moving it he=
re will be after the check against ctsn_ack_point, which
>could cause dupli=
cated SACKs to be missed from the log=2E
>
>Yes, from the sender-side CC we=
 don't care about it (yet), but it
>helps to spot probably avoidable retran=
smissions=2E
>
>I think this is cleaning up the noise too much=2E I can agr=
ee with
>moving it to after the chunk sanity tests, though=2E
>
>>  	/* Ret=
urn this SACK for further processing=2E  */
>>  	sctp_add_cmd_sf(commands, =
SCTP_CMD_PROCESS_SACK,
>SCTP_CHUNK(chunk));
>>  
>> -- 
>> 1=2E8=2E3=2E1
>>=
 

