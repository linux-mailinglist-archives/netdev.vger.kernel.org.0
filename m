Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A832A2AA6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 13:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgKBM0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 07:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728359AbgKBM0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 07:26:07 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56964C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 04:26:07 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id p12so1678708qtp.7
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 04:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aUQj2V64RB7RoN7QABG9by5K/7a1K8A2JYfWs4jDWPI=;
        b=VN+GRa38LzFFtDiA1QHxmdTCffEDz/JdmS4aI4uNchAThzwYZUBCN61pMK78O688+3
         UqqSeF9xjie1VShxpVaGBIFB7UUvBtQdKVg2SNZfFLEBtrqwLilt3ARVPuI+ZJs0lagc
         yYVcEKmNsHfzjcQnWVoB3xach3ZPfPNyGMDpr5iyl4fXqsowt4pZiQVX4JlCi+J2D98n
         03FU2lhfHJcDXuthw1T4PHtsUhOk9pcY/1ELxqrOtwps4SMfaDkPOkm0bnprFKAu606m
         8ffgqiCLc7p5RMO/4SJbJllACb4v5gUgyedA62+qVk61Jw409FwbLThiQbfoSzEXUgIV
         4Brw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aUQj2V64RB7RoN7QABG9by5K/7a1K8A2JYfWs4jDWPI=;
        b=JW9ZBs/gla7LkhcTKnoNMgBXYq1fSma77B5rplOGpz4u3za9GWOKtyA2//LELWKOBP
         Er7b0DYrwIoA5s1+ZQatYlvFfImFVzD5ttKIQx3JjeY/b+klmTlEgtUfMTg0B35w9/rz
         IcEPmI+q3OqDJqdgiudx8nYpzgulY8zrhzgsfnn6M9Eb6aWWiDKHqqZPhHu+lQBZ8WSp
         CioINAeYuaT3i61kTY3Iw5KMzqQXOrJ2fq9PR6G0CBOguWcYrqNdBzGAMQyZA5q35ct0
         ydF5Kp3gWfIlc4vgOWM2pDkJCDSXHxtV6X8hwAXvViHjMMjul/an7An94IVzlIqOM0bj
         XV8w==
X-Gm-Message-State: AOAM530DLVAHNEBg81hoDdjYDerUClT64ULVReSnU0CN1HTajgPHqNQ+
        LLzBGTIGxpyDjnPkC37BisM3JA==
X-Google-Smtp-Source: ABdhPJy/mxYecyThCU7tstBUMJ70TpesxIMYUQZ/emH3OqGfZtaJPz0iIjXZ6QJASITSGZuiWMJ1Xg==
X-Received: by 2002:aed:3b2a:: with SMTP id p39mr13470256qte.211.1604319966646;
        Mon, 02 Nov 2020 04:26:06 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id t18sm3588207qtr.1.2020.11.02.04.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 04:26:05 -0800 (PST)
Subject: Re: [PATCH net-next] net: sched: implement action-specific terse dump
To:     Vlad Buslov <vlad@buslov.dev>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <20201031201644.247605-1-vlad@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <96c51cbb-1a72-d89d-5746-2930786f8afb@mojatatu.com>
Date:   Mon, 2 Nov 2020 07:26:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201031201644.247605-1-vlad@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thanks Vlad. Ive run the basic test and it looks good.
One thing i discovered while testing is that if the
cookie is set, we also want it in the dump. Your earlier
comment that it only costs if it was set is on point.

So please remove that check below:


 > +	if (cookie && !from_act) {
 > +		if (nla_put(skb, TCA_ACT_COOKIE, cookie->len, cookie->data)) {
 > +			rcu_read_unlock();
 > +			goto nla_put_failure;
 > +		}


cheers,
jamal



