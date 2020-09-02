Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD2325AC25
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 15:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgIBNiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 09:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIBNcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 09:32:39 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D0CC061246
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 06:32:34 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so6635699ejo.9
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 06:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=917w7cMeyQJPmg3O5pTWvy7oizYPXb73Fu6zj/DMIu4=;
        b=pG7+I5sv367/NzaNjp7LwTUD3lgW+Pr/Wb2m0IBkPc0v/xe9hUZTwGk0bBFDekJJ4b
         4KaCfJAp8b9wbnLFyjXy5s78BBZeJPcxyimDtsRuvUNSFk3WmRHay1YK3LLyUVGsSX9t
         T9alMgdDvyxL8hEDrdg9c/ookhMUq6T8k44AVs4S7v5ERshnPEl7aD5TjQFeWnxdmaBB
         /RpIuk+pgbAXbGS4WtEbJQBsV2r8eZ5UP5pEMC5w/O0jvxTpvHwlIJ1CoMmPcSEO473E
         J3Ny1I3sES8VW2iqvFcCNYmws9iW0si4ceeJrfMBHahsFBUxOdqVBzrxzs+DKQ/9q3FT
         I3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=917w7cMeyQJPmg3O5pTWvy7oizYPXb73Fu6zj/DMIu4=;
        b=OYYI1xdtjeQlryLQW09jZGafYnnZozxTJ5xoiMcq8v7NAPSLQgf8ExhIW00tW+0fqZ
         bBLWcwnI6MJ/1JFJYc9POD5roHj5Jd78DUIfWir0CECBx8YBXujcOsxSUf649EYnxNM3
         k/vQxXDGfOtrb1fkZqwLiB4xoTD1NdVCDaHzTQ9pDgBF9cWVcox47gauSaOwo8QMi8X0
         DgYN2Qeb3pyc+GyU8jyhM6AVPidQOGJT5xnG0d2uo94efHPTEWaWjCBiVqFvUiM1tkka
         lxu6JybxEEVj2oGAe1YQRDHSRy3pa38GmYs8BE0nIBrVdNXvwGQg99vgh/T4sAB+CQUg
         D+Iw==
X-Gm-Message-State: AOAM533PszkeYuEtCIjZe61xsLa1iIwAAwtRb2uAKsbux3wJ5Fr437iJ
        GPXi4uwxdNt4hJ+GLApZPaltoMRrbmfOcQ==
X-Google-Smtp-Source: ABdhPJyFshoN8ETfAEDFIN/PNrj7dVp+MjrOxFRWs/V0+J/l182pxMw17MTvuei/5JxUwBzZm1dtgw==
X-Received: by 2002:a17:906:37c1:: with SMTP id o1mr1297ejc.279.1599053552616;
        Wed, 02 Sep 2020 06:32:32 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:b949:8004:3927:fdba])
        by smtp.gmail.com with ESMTPSA id s23sm3331595edt.10.2020.09.02.06.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 06:32:31 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: mptcp: fix typo in mptcp_connect
 usage
To:     Davide Caratti <dcaratti@redhat.com>
References: <6c43e5404c41f91ed9324e20c35a4e4fdb0ed1de.1599046871.git.dcaratti@redhat.com>
Cc:     mptcp@lists.01.org, netdev@vger.kernel.org
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <022366c7-c916-8841-348b-b1981341b810@tessares.net>
Date:   Wed, 2 Sep 2020 15:32:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6c43e5404c41f91ed9324e20c35a4e4fdb0ed1de.1599046871.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Davide,

On 02/09/2020 13:44, Davide Caratti wrote:
> in mptcp_connect, 's' selects IPPROTO_MPTCP / IPPROTO_TCP as the value of
> 'protocol' in socket(), and 'm' switches between different send / receive
> modes. Fix die_usage(): swap 'm' and 's' and add missing 'sendfile' mode.

Good catch!

I guess we don't need this on -net or further, this test program is 
always used with its wrapper mptcp_connect.sh.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
