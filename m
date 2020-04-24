Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D0B1B7212
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 12:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgDXKdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 06:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbgDXKdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 06:33:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8DAC09B045
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 03:33:19 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so9420268wrt.5
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 03:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8mmiQQPPszvQVjLjDnxudjKdNdDpKLMPzK3SPDltDkg=;
        b=N8cVAR3SbbkajX3SjF3RCO2CXV0r0cDbs6A9cFr7RDZzz2oLXnQulRG380/+xo36j+
         MSLooZIdvpU9KwiPc2NSNyWUap0tcVSkYz+dBI0EfhLUEeSqW8Okkbv0NPiHGADCw/7v
         ZR+ijfUnXSaw8RKysnMQLWH4ChK3ZhiARb7bwarYyns+8cE7vN1FHnQGB9wkPUyjdK7D
         c1Wl8ep+cXAbR+TQOua8FVN5jIW+FyalKtxkpx2uuGWza2zKgoE4B1ZsmhUx6nampgNG
         9nXrqGGurZTjETYuFN4odxbxW4bpVmoDB5vyA8T6wfmGfzEEIN1zTMqi8qRmNbx9pmJC
         uUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8mmiQQPPszvQVjLjDnxudjKdNdDpKLMPzK3SPDltDkg=;
        b=WoPamiPIE9rYI1s+/kN8nN5aLj7ZNg92SSO8KH7XpPZ/TtaqFnD/CpD2hSfhqEU0SK
         g1XhPku0E5DfpP+APr0iRCJyutSYEua6ZZUJWb7Eg4ckxUHGlHsohbLpNYXkvf/A2DEL
         wE7f6RS70IzUCfMk8R4Sy64nMju8CN/HviH8GGyTGQw3ga/aTxKub8XRQ8Jrs9S/SSTG
         Q8VF0J+W9OqcewAM0uF5FP4OqXSdtoaOhA9tGPRSwH+NYvJ5GwbHzFER7wA9OKBCHhCR
         82kYWrNgeq/zf1JHy7wOh7OWh7zz2ozuGKEHlsnwSr1fWUKeOHrY87EX2aZ+tIT5mwz3
         lLdw==
X-Gm-Message-State: AGi0PuY66n80newxJS6DFeLyAF6KWLEW2vSSxl6SRs80EpR42urET1l0
        QlXdNNXnTMB5Bhc2oCFT0qnUAw==
X-Google-Smtp-Source: APiQypKSinIlQfWTkZxmoBz6nD2ehaxyuCzlaY54OHochW6acrjfxEhPgTw5y641aF4rZ73Yv/+Pfw==
X-Received: by 2002:adf:f091:: with SMTP id n17mr10225990wro.200.1587724398492;
        Fri, 24 Apr 2020 03:33:18 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.129])
        by smtp.gmail.com with ESMTPSA id z8sm7176272wrr.40.2020.04.24.03.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 03:33:18 -0700 (PDT)
Subject: Re: [PATCH bpf-next 10/10] bpftool: add link bash completions
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200424053505.4111226-1-andriin@fb.com>
 <20200424053505.4111226-11-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <e52e945a-0a20-a93f-77f1-e2165fb4a3dd@isovalent.com>
Date:   Fri, 24 Apr 2020 11:33:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424053505.4111226-11-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-23 22:35 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Extend bpftool's bash-completion script to handle new link command and its
> sub-commands.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Looks great, thanks!
Reviewed-by: Quentin Monnet <quentin@isovalent.com>

