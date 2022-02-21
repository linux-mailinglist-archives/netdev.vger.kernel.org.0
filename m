Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3FC4BE5B1
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355289AbiBUKmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:42:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355354AbiBUKkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:40:49 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840744B434
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 02:02:55 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id k1so26056798wrd.8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 02:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=4spbP8g3kH8kWJj7au2RUQjlvz8vP+xcK3qZ2pF3cn8=;
        b=Gg5vB8sQY2JfVjfQx2R5+fSVYczoNT+p/XvGOctR3yJER4y5YNmcMNPjyTtMxAAyPO
         KVsnH9PQ3MNlTuVEzm9E1MS/3ji0IzkB19LTKyjAklzuqQrxoBPUDEwoi+ORrTdC1xbf
         Zxz2MTtovhVxZ6xzBVQagIKHq/wsZXJo5uKg9TYa7UIovwDrkdvpir17gtf7tDF8cjhq
         YemyZuo/wd8a2s2f62lXIQ/cmtNIikheaw7JCz6jzeaYpM/M7vuVCxzUlzNxE/pfACYb
         Q7KhrEnie2B5awn9p5TRtMidNpn7L7MRodWl26L4KZYH3tjNrg4d59NHI7sR49eBmA0L
         w0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=4spbP8g3kH8kWJj7au2RUQjlvz8vP+xcK3qZ2pF3cn8=;
        b=Zz0K8K033dx6Mp6Ldcji8UHpHPppWLcUv62nnwb00UyAiCtaEHNcxqOJeirhXmqEw2
         CDdzeTH1GABPY4hA357zb4fRR19xgdyadw6npinHhYZLx2VXgsWandGs3XLneDrInKUb
         LiuKnTYUu3JLie06TiBl/bsOvSdvx5rCw6f803I8S2Ni5OC+Gb9yi5Eck6+7T0G2R2hn
         LvZhETsShtMVh5R1I/YmrcJQuXrTWfSkj1oz7jPfcibs4NEmQZgo1u6sRZZp/msW0iCW
         SihoPQVM+7MVcNCHGiIiNqNwuuAHVr0veXw7omw6xqRG3WvoBfUFS2yShnrWyr/+T5Cu
         nSKg==
X-Gm-Message-State: AOAM532mPDi0BhV9l6LDkOwEWuPtHUsbtno4xFBOI++NO0xAJG9/Rsmk
        dQ2azuWina/tEdDq0d2lHmSRbA==
X-Google-Smtp-Source: ABdhPJylZCA6xTSnt41gx8pHMBxY0LxZ+rJcNeqm+wB61rgZCKWqTRHWRpKsePNT7SfM9w7wxxQyeQ==
X-Received: by 2002:a5d:6606:0:b0:1d5:e69d:884c with SMTP id n6-20020a5d6606000000b001d5e69d884cmr14212282wru.160.1645437773990;
        Mon, 21 Feb 2022 02:02:53 -0800 (PST)
Received: from ?IPV6:2a01:e0a:b41:c160:bc91:e50c:999:2115? ([2a01:e0a:b41:c160:bc91:e50c:999:2115])
        by smtp.gmail.com with ESMTPSA id a10sm25032012wrt.59.2022.02.21.02.02.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 02:02:53 -0800 (PST)
Message-ID: <571939bd-724c-3f10-e220-b581eb307b34@6wind.com>
Date:   Mon, 21 Feb 2022 11:02:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] bpf: cleanup comments
Content-Language: en-US
To:     trix@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220220184055.3608317-1-trix@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220220184055.3608317-1-trix@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




Le 20/02/2022 à 19:40, trix@redhat.com a écrit :
> From: Tom Rix <trix@redhat.com>
> 
> Add leading space to spdx tag
> Use // for spdx c file comment
> 
> Replacements
> resereved to reserved
> inbetween to in between
> everytime to every time
> intutivie to intuitive
> currenct to current
> encontered to encountered
> referenceing to referencing
> upto to up to
> exectuted to executedYou can add them in scripts/spelling.txt


Regards,
Nicolas
