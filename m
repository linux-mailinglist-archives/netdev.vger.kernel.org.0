Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24CA55D670
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbiF0M1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 08:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiF0M1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 08:27:11 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37962AF6
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 05:27:09 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v14so12826632wra.5
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 05:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wbsk5o6KgdL4SnufubuiVYM7EL+gtXq5PDT+l+PqB58=;
        b=G39QUtITWY0/DbOcOb//w+M4CHOPXvYEoF0ubU5juOPNHcEYSrbvs643OgfKroXIDK
         HCnkbocFpkO8zOxae0uYMUwDCj8D8+g1OP5T04xB2IOh8VzD4Kq43QVYZduOEWxxN3n2
         TXvgzj0sEK993zoM4sITfkxNnS4p0fDaE/Or310c/w8ffN8kd0jI/k6mByuoK5jorTYh
         MXJxNy/srJ7sIfNNF2DN+XQmh/VGhAyTT+gdbvkIJbgGVGPnLN3p4hqfc0GcZuziZcYO
         zjntYDlGC9aTnlmUUrOEw7yZz7SHrfAsJcfhxAtYalKS4GetimgBD5h6UWA24P8f5RpN
         OI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wbsk5o6KgdL4SnufubuiVYM7EL+gtXq5PDT+l+PqB58=;
        b=EITAiPUYq0JXeL5XS1rnp+/faDk9BttMY8UwaLp87QmAZSLAWO/8VfpNtrXnbkil3C
         FDg77KEmzLfb1sDpf9wcGuUEjC2GOZkKogzayo+Db7euCcS76QHVA15691A/gOVC/aWD
         Q1hACl7UrQQWo5OXtQ+JaHGJVR2EhtjY1GndeCdXWqvMjS7CWuX3C32bQtKFSVzTmyzF
         F9kbFfGQ+68yDDwCrsqqmUmAKGNC6a65KEDp/IEUciYbe0Vv3Rd2He+LxgEMNe4qTR6M
         0SJ5TRDituTPhQ1jcXQb4HYBFWocciv3s4SkIcrcvn9XPUc9+/bctWSNfRF1GXp7jQcX
         reaw==
X-Gm-Message-State: AJIora8A127ZUDeQzrhefg/I9TzpRdml0Z67wBzutAmXvSxL+f4vH9Is
        Q6OmN5OHI0sjd+SIVfmxgVHRJg==
X-Google-Smtp-Source: AGRyM1s10QCPtzo9j4RkTgku5PKsw19klOZT3gv3QSpsPaPKYe0nS6sDZVGtf8it5iJlLaSmpS/klg==
X-Received: by 2002:a5d:6da8:0:b0:218:510a:be9f with SMTP id u8-20020a5d6da8000000b00218510abe9fmr12054141wrs.352.1656332828373;
        Mon, 27 Jun 2022 05:27:08 -0700 (PDT)
Received: from [10.44.2.26] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id d10-20020adff2ca000000b0021a38089e99sm10360546wrp.57.2022.06.27.05.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 05:27:07 -0700 (PDT)
Message-ID: <c1fb40e6-7bab-20a3-febe-3af3b84fc2cd@tessares.net>
Date:   Mon, 27 Jun 2022 14:27:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: mptcp: fix some spelling mistake in mptcp
Content-Language: en-GB
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
References: <20220627121626.1595732-1-imagedong@tencent.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220627121626.1595732-1-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Menglong Dong,

On 27/06/2022 14:16, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> codespell finds some spelling mistake in mptcp:
> 
> net/mptcp/subflow.c:1624: interaces ==> interfaces
> net/mptcp/pm_netlink.c:1130: regarless ==> regardless
> 
> Just fix them.

Thank you for this fix.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
