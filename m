Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B5D5E11C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfGCJey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:34:54 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:42579 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfGCJey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 05:34:54 -0400
Received: by mail-wr1-f54.google.com with SMTP id a10so862006wrp.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 02:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZCaGvqtjPu+wMpfCpkHUU1Nn3NIhv5ULL6eB8EUuNns=;
        b=rNZ27E06UkQ5XV4bn8nk4JRTjCU+cDmJeaA5YkduS6EGJvmw7E9OkIK80ViY5JlHUQ
         hWsrMfyYuzvTX1pwp0cVvdK0DVV2ipZSKG0YTcxno2NT9QCoaLndilCPGICgTu6jCCBY
         Fwil2mIUT0eH1InKk1noNNcLa2CsmueBNib2z8sH8h1sX0ktYsC4feJcjkl08gRSgMCp
         GOH57orM0Upb1T4it+hFFlPDhMny0cskZylyLgUnl9NS+L/ltXWxv7seq8hnas9gc7WS
         ava8iNsQFYC1qdZw38wHu9TstGYvV9y8F9RIR3yysXFaZWOQPl6yYVqyPt07D6/xso8b
         Hzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZCaGvqtjPu+wMpfCpkHUU1Nn3NIhv5ULL6eB8EUuNns=;
        b=f0pmeD0SSrIIwmwBPTJMAz5qAYuWpk+uD9Q9DU6ZLF30aXkvzc16H/sWURIkd5zPfA
         6v50LZ85pH61meds0z8vygvUeTz2vR60BnONBB7A+bePpRlZ8K6Ag4T5ZbUjqNgNcgZ3
         w1h9KIIOFDS9cT6O5eTnziNmt+7Edu1YFgdMtJ9U5MqJvRWCRbDTkoBlb1LNxDtuMWLn
         Xz+TXhafBGcFggAm8Qo5J+nIYoVbbzWyhZnXyj98AO1CVPt5egCrGNDHVBG22cOUWutx
         GkahsAmWK5baEc1gKE5hhGGpXC3NV71Ahcj7yLD0Bi4bFBgNp8zS3EsBmdF7tTfNKUE7
         BA1A==
X-Gm-Message-State: APjAAAVzlEAu6h0hdlDjtC18ta2ECNCWRTvXcteRdjXi12XAQ0L445Jf
        VOkpuv1yam0IeS5YudHYNatl+K2v
X-Google-Smtp-Source: APXvYqz7uxKnONomCjeeY+VnTRzGh/zhO0udNyOKPD102SDYOPTlpe7nY7taOd4gQ8mUJ00cX+nJRw==
X-Received: by 2002:adf:e446:: with SMTP id t6mr28920171wrm.115.1562146492667;
        Wed, 03 Jul 2019 02:34:52 -0700 (PDT)
Received: from [192.168.8.147] (196.166.185.81.rev.sfr.net. [81.185.166.196])
        by smtp.gmail.com with ESMTPSA id p4sm480236wrs.35.2019.07.03.02.34.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 02:34:52 -0700 (PDT)
Subject: Re: Shall we add some note info for tcp_min_snd_mss?
To:     ZhangXiao <xiao.zhang@windriver.com>, edumazet@google.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <5D1C68C8.6020408@windriver.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <564a6863-0db9-a07b-0cfc-b41ea8e9c9f8@gmail.com>
Date:   Wed, 3 Jul 2019 11:34:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5D1C68C8.6020408@windriver.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/3/19 1:35 AM, ZhangXiao wrote:
> Hi David & Eric,
> 
> Commit 5f3e2bf0 (tcp: add tcp_min_snd_mss sysctl) add a new interface to
> adjust network. While if this variable been set too large, for example
> larger then (MTU - 40), the net link maybe damaged. So, how about adding
> some warning messages for the operator/administrator? In document, or in
> source code.

What kind of warning message do you 
envision exactly ?

The sysctl is global, devices MTU can be quite arbitrary.

Like almost all sysctls, sysadmins are supposed to know what they are doing.
