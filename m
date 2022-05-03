Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9EB518E70
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 22:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbiECUP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 16:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242518AbiECUPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 16:15:43 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D432A40E6F
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 13:10:55 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id hf18so14439434qtb.0
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 13:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1mYaYvNIZ0izntpEDGvK45tZbegQEZj2gmMuTxCoewk=;
        b=dQUYLaGTGISBy7cFpa7kWZE6Ny/DEkMsQ//YDsZwPOOJV3biQw1n4rzLV7fm9HTEtM
         ovXdFMjtFQ/EbltnsjGwZLUGjC+3iCB+DIFCybR/eRW5zeHRDNkD1aZMSf2ZYtTBt6tT
         ZmGvusCT7gawthGe6yRVljR9PErOaspEwqN21BVHokyevAoOMfktAGPbpKi2lgQrNUqz
         DUHuZOncIpiY3Lh1G5rtALpdNtq24vSSFrmj5h1pfEA1UYG/wd12KtaO4nIqQGLTeC8q
         9ixR5IQqN5En+4SvX+2BFv/5SWu/IJC7+TMaOhkPQZPQDwCN0BW4sTGPSsrv/7+jNFPL
         emuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1mYaYvNIZ0izntpEDGvK45tZbegQEZj2gmMuTxCoewk=;
        b=WfMLdAS2SQn1JEaOUmhSaYp4mCXAlQuzbiVh/0KkTvuHZXzvaJyKK3uLQofSeg5nHx
         lSAtjmzb5sMzovOeKq1OBN5p9B5ncArbrAemv68SeT+Ws+zNX4Qu7KgQyaB611Cw83FH
         1XvInt5p5Pi2CA/srT+TqW0OaIgxUnPidN1kGyrX+tvJGZUDHVs0P2nC4hucTsjjNlIh
         LdplGOltk+CIAHJa4pQ+fHC+sPLnMmJuStrMG2VHzVV9mnz4dOkPusu67P5ZJ/h5Tqid
         mJyRGUMzfHovYNuKKf+N0Pb6VVj9HO0nrERMxEH/Zb7RpMslA1L7va9kSq7pVtcbo0Ro
         NA8A==
X-Gm-Message-State: AOAM531Q54SUS++dQQ7tj3UykuOIR3a5HiDpKSjxxJ8caDZkJcSKB2lS
        b1lNzF9ipI7AQGcxCPBonVw99Q==
X-Google-Smtp-Source: ABdhPJx6Bjf0PUVExGoUd/qBL/jgYVBd0AC6HZYxvYLrvcPnQekuplY1nsKhzsJfDa2bsqGe1clxIw==
X-Received: by 2002:a05:622a:201:b0:2f3:a9a1:17dd with SMTP id b1-20020a05622a020100b002f3a9a117ddmr7775332qtx.226.1651608654398;
        Tue, 03 May 2022 13:10:54 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-27-184-148-44-6.dsl.bell.ca. [184.148.44.6])
        by smtp.googlemail.com with ESMTPSA id n68-20020a37a447000000b0069fc13ce1edsm6629285qke.30.2022.05.03.13.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 13:10:53 -0700 (PDT)
Message-ID: <7e4682da-6ed6-17cf-8e5a-dff7925aef1d@mojatatu.com>
Date:   Tue, 3 May 2022 16:10:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net/sched: act_pedit: really ensure the skb is
 writable
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
References: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What was the tc pedit command that triggered this?
Can we add it to tdc tests?

cheers,
jamal

On 2022-05-03 10:05, Paolo Abeni wrote:
> Currently pedit tries to ensure that the accessed skb offset
> is writeble via skb_unclone(). The action potentially allows
> touching any skb bytes, so it may end-up modifying shared data.
> 
> The above causes some sporadic MPTCP self-test failures.
> 
> Address the issue keeping track of a rough over-estimate highest skb
> offset accessed by the action and ensure such offset is really
> writable.
> 
> Note that this may cause performance regressions in some scenario,
> but hopefully pedit is not critical path.
> 
> Fixes: db2c24175d14 ("act_pedit: access skb->data safely")
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Tested-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> Note: AFAICS the issue is present since 1da177e4c3f4
> ("Linux-2.6.12-rc2"), but before the "Fixes" commit this change
> is irrelevant, because accessing any data out of the skb head
> will cause an oops.
> ---
>   include/net/tc_act/tc_pedit.h |  1 +
>   net/sched/act_pedit.c         | 23 +++++++++++++++++++++--
>   2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
> index 748cf87a4d7e..3e02709a1df6 100644
> --- a/include/net/tc_act/tc_pedit.h
> +++ b/include/net/tc_act/tc_pedit.h
> @@ -14,6 +14,7 @@ struct tcf_pedit {
>   	struct tc_action	common;
>   	unsigned char		tcfp_nkeys;
>   	unsigned char		tcfp_flags;
> +	u32			tcfp_off_max_hint;
>   	struct tc_pedit_key	*tcfp_keys;
>   	struct tcf_pedit_key_ex	*tcfp_keys_ex;
>   };
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index 31fcd279c177..a8ab6c3f1ea2 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -149,7 +149,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>   	struct nlattr *pattr;
>   	struct tcf_pedit *p;
>   	int ret = 0, err;
> -	int ksize;
> +	int i, ksize;
>   	u32 index;
>   
>   	if (!nla) {
> @@ -228,6 +228,20 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>   		p->tcfp_nkeys = parm->nkeys;
>   	}
>   	memcpy(p->tcfp_keys, parm->keys, ksize);
> +	p->tcfp_off_max_hint = 0;
> +	for (i = 0; i < p->tcfp_nkeys; ++i) {
> +		u32 cur = p->tcfp_keys[i].off;
> +
> +		/* The AT option can read a single byte, we can bound the actual
> +		 * value with uchar max. Each key touches 4 bytes starting from
> +		 * the computed offset
> +		 */
> +		if (p->tcfp_keys[i].offmask) {
> +			cur += 255 >> p->tcfp_keys[i].shift;
> +			cur = max(p->tcfp_keys[i].at, cur);
> +		}
> +		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
> +	}
>   
>   	p->tcfp_flags = parm->flags;
>   	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> @@ -308,9 +322,14 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
>   			 struct tcf_result *res)
>   {
>   	struct tcf_pedit *p = to_pedit(a);
> +	u32 max_offset;
>   	int i;
>   
> -	if (skb_unclone(skb, GFP_ATOMIC))
> +	max_offset = (skb_transport_header_was_set(skb) ?
> +		      skb_transport_offset(skb) :
> +		      skb_network_offset(skb)) +
> +		     p->tcfp_off_max_hint;
> +	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
>   		return p->tcf_action;
>   
>   	spin_lock(&p->tcf_lock);

