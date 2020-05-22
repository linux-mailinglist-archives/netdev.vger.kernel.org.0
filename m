Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C601DEE7F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgEVRpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgEVRpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 13:45:22 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7F2C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:45:22 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id a68so8828778otb.10
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8nFwFZLKxrEyletdUrVBri1Fb3wV5GBHQgTxC4ehdM0=;
        b=RlyQK/SLLmTukwvnL1dVZJ/m1gSuNsa9/Hn/5vSMRJPUk0R4k/Tq9s4aGLOfb1uFae
         CCb3g0BuXa3tu/SfiMq1yCQ+z+JhnCinbPj8AENjD61xRXfhXgOiwGxINW1HA7ScIcVR
         yHWv7aUZkpXh8dRr9VVcSFnszota0mVoHzTHwYrWVaIDeYam6NomAXCBLRsgj75F9xG2
         LmJipON5USHBrkfteo0hCJn0dmMf33d9woqGRlj/q8Nv/4ClpDaO8wY+dg6Or7W1PGmQ
         LG92p8sSCO+xRteFNojWFxMsO6mx3zZyCbzo+cEq4Xci60wC19k3I97KG4SKNzPCni6f
         UV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8nFwFZLKxrEyletdUrVBri1Fb3wV5GBHQgTxC4ehdM0=;
        b=iXH71mO48pFJq4HS5Hsatl3eOOTOlGiGlKTz1q3A5M5ttT/nvtIJr191O60US/sj7E
         FISa04F3H3Un9cdnxMy6W1dzxHlopA1K2pIVP9v7/hZYVCHvKs5UWfnNFh79cbya/R4G
         WsSD/W8dLiPojdlvAw61Y2Ov1O9PMVSbLSrC8LVLnaMa62DhutUb0ZHbkzTheZHKXhvw
         yw9AMSD4xjdWO+A+Qv9e5t7CjZPf1JvMdlZ9ZaAAe8uNn+IOReN+hnUSYVk78iJmfzEl
         hH52bydS+NDROQ78qGR5rvM4xNy9ruoEL55V/oLawYzhemFLG93JR0O+WXgM4Dh3w9pA
         mfNQ==
X-Gm-Message-State: AOAM531WdpvJzXG3jYIiuUOrXQAVkMGtO5k+CZw3hCe2D+ykH7G02hAZ
        +eGkJIAGLBjNzkF62ylhR44=
X-Google-Smtp-Source: ABdhPJycqwOhXmGn8GlMlx7LV2Zv01QfrJnbe4m6M1BK9vIEZcU10YU+JikWZq8rc2PXKYbsOBkvWg==
X-Received: by 2002:a9d:6356:: with SMTP id y22mr11363496otk.167.1590169521715;
        Fri, 22 May 2020 10:45:21 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5123:b8d3:32f1:177b? ([2601:282:803:7700:5123:b8d3:32f1:177b])
        by smtp.googlemail.com with ESMTPSA id 21sm2767065oiy.11.2020.05.22.10.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 10:45:21 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 2/4] bpf: Add support to attach bpf program
 to a devmap
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200522010526.14649-1-dsahern@kernel.org>
 <20200522010526.14649-3-dsahern@kernel.org> <87imgoj6tt.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a08edadc-7ab3-d23a-a8be-0897e2a11c08@gmail.com>
Date:   Fri, 22 May 2020 11:45:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87imgoj6tt.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 10:02 AM, Toke Høiland-Jørgensen wrote:
>> @@ -563,12 +619,23 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
>>  	if (!dev->dev)
>>  		goto err_out;
>>  
>> +	if (prog_id) {
>> +		prog = bpf_prog_by_id(prog_id);
>> +		if (IS_ERR(prog) || prog->type != BPF_PROG_TYPE_XDP ||
>> +		    prog->expected_attach_type != BPF_XDP_DEVMAP)
> 
> If the second or third condition fails here you never bpf_prog_put() the
> prog ref.
> 

good catch. Thanks, will fix.


