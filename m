Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3C612AF88
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLZXJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:09:19 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45015 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfLZXJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:09:18 -0500
Received: by mail-pf1-f193.google.com with SMTP id 195so12983510pfw.11;
        Thu, 26 Dec 2019 15:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:cc:references:reply-to:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sWE7GNf9+nrChKRRJ4/kK18J2sSUWt8kAqGPEiWQLKE=;
        b=ZnG2Ezgcv32wvAPlLLqz8J4hHp5822iBYqm03oZloMEhMrijuK0Hx/83Prqj/BMNfC
         rPjdUM2Tf+Q4eaHAJY7o/qpuL6V7zSbOQgUGOvZsMH15XY8+zaz/lRKvNTU9xG97pAlp
         TDBu4McPh7O2UJGzxex4acMjFIcOEYiPSLuFeHapfyK/3PwmrzVqOkNENJ7ebFwyS2Ix
         /YxSjz5hikKyh6Ye3iYX+wjKnx+dkGEcxbYnjgSCPr06GRarFuMp2nxfEjouShhYfult
         eSMkCzoZ5LGBPq4L3K8K7Z6VgohoYuUR10HKgxZ3FGlMt7028lP+iXlVJWIsQZlzegcT
         nDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:cc:references:reply-to:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sWE7GNf9+nrChKRRJ4/kK18J2sSUWt8kAqGPEiWQLKE=;
        b=PJedQ1vbuMUhMeiKMc3mwSdlYGoI4YvV0FCpUJMnHwDobulOf9Rhzt5yWBN5PB+hlA
         rXU+1YyWiIB6PZ37DHxBSdX3ERD5WeDB4EWBLnH4VtxXxnABJgrGyI7p+L5REfaMk2st
         B91mRY0eA83OzLxErohCVbHlo4NqIX8DQs/jR7mPqfdW5wx/Zsq7yt1ZWwiF/GekIiOJ
         E1EcX6qYaE5llgktChCtYo4DwlCZhJPurRF1eWHkGGyc3KrCMz5cb12H4qlZ5iblCZ1K
         Xp8sYutldllUzw8/zQf7qY3pVqm3V9FHkAq+Rwyrq8IR5dJJa1zylNb9ZYECVAEHEQNB
         ufcg==
X-Gm-Message-State: APjAAAUfqfsIfmo0lUkW2B3PUAESDaBk1BckTIzVOHwIZXPwug/2Y7WC
        vxl2oUWP4D15Rswcb6/wjFDTNCxP8mk=
X-Google-Smtp-Source: APXvYqzplSP6Qo+lnLYgHHX/3pjnIZrgDCDB7Bsk4Z8DoNDyu+4Y/0Xx1og7SL1u7pHmdow2iFekGg==
X-Received: by 2002:a63:1c5e:: with SMTP id c30mr52244612pgm.30.1577401757798;
        Thu, 26 Dec 2019 15:09:17 -0800 (PST)
Received: from ?IPv6:2408:8215:b21:57c1:740a:4f15:ce01:1643? ([2408:8215:b21:57c1:740a:4f15:ce01:1643])
        by smtp.gmail.com with ESMTPSA id l127sm35376601pgl.48.2019.12.26.15.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 15:09:17 -0800 (PST)
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into
 sctp_outq_sack
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
Reply-To: davem@davemloft.net
From:   Kevin Kou <qdkevin.kou@gmail.com>
Message-ID: <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
Date:   Fri, 27 Dec 2019 07:09:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101
 Thunderbird/72.0
MIME-Version: 1.0
In-Reply-To: <20191226122917.431-1-qdkevin.kou@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



 >From: Kevin Kou <qdkevin.kou@xxxxxxxxx>
 >Date: Thu, 26 Dec 2019 12:29:17 +0000
 >
 >> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
 >> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
 >> and trigger sctp_probe_path_trace in sctp_outq_sack.
 > ...
 >
 >Applied, but why did you remove the trace enabled check, just out of
 >curiosity?

Actually, the check in trace_sctp_probe_path_enabled also done in
trace_sctp_probe_path according to the Macro definition, both check
if (static_key_false(&__tracepoint_##name.key)).



include/linux/tracepoint.h
#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
	extern struct tracepoint __tracepoint_##name;			\
	static inline void trace_##name(proto)				\
	{								\
		if (static_key_false(&__tracepoint_##name.key))		\
			__DO_TRACE(&__tracepoint_##name,		\
				TP_PROTO(data_proto),			\
				TP_ARGS(data_args),			\
				TP_CONDITION(cond), 0);			\
		if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {		\
			rcu_read_lock_sched_notrace();			\
			rcu_dereference_sched(__tracepoint_##name.funcs);\
			rcu_read_unlock_sched_notrace();		\
		}							\
	}
			
			
	static inline bool						\
	trace_##name##_enabled(void)					\
	{								\
		return static_key_false(&__tracepoint_##name.key);	\
	}
