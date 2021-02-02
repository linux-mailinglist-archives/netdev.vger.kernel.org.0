Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15F230C559
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhBBQUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236132AbhBBQSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:18:25 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFBBC061788
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 08:16:31 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id z36so5260247ooi.6
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 08:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tfPhsgFKMufoydraJ1eQ3p+XcyflF+JNoSJzGjqCR+k=;
        b=L9S8Dbw88EhKa6T1h0z213WTPidBK3n/coltgp9W8iXMTSt2BmTSZkdwOaMBV+Zf00
         19Uq1CYhY+P1M489qd/IgpYe/j/EHKVMKTiMSvKVpnwuHo9k9VkE3iVmOhqHB5uJgkme
         1BXPiMFj2FK8vty2+q7ODfuJJWUuUA//u0OdKX1wYFyGTQQwEcKUfTKkrbe6eMPg2ePm
         DER5B4VdwOCkdSGMgUzgT6ct0QXhBhGMiLctgAny1orNrOFlKtuk0kW4w0J32iqWpgYk
         l+NZYsJhAQe99kxSsb7C7Naf8iBhnq3Et7D81bylyQcvUG61IffCh97Tj2rNadh5G3EW
         3vxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tfPhsgFKMufoydraJ1eQ3p+XcyflF+JNoSJzGjqCR+k=;
        b=KuJElfieJvem1FUFeCn3dWno0igbm1bSxxNYUiJ4DWp+c3u2wgevDeCU9D+KATvPUv
         cKpX58sNFniCiKGn4l5E+y8docRBPFoVOdr5qnvm2P19N7l5UiZWOSX+f1Fme9XNABmV
         Vua5FiiS0mDLFXtRPgq59pdL4ksfZedYoCb2Hu/ZS6/YBP564o3pGbqUfg3CI7aG3dOd
         U1eCbPdCNUeyFYnOOOJnIFj/GxcDxYoNHtyR89O5frdyQyUHo8UawyNCLIXAHVar/c/Y
         Wijgj7q7tFNvU2u5LcpHBE8BE+Tjfp0iACfY5MeEB0rTeVmTCLlWID1uktyYzFDWUqWY
         Rp4Q==
X-Gm-Message-State: AOAM533W2DbG7OFSkTY4BkOBPXU8N7xr5Gt5mAgzOELHU0sOdnmU9rgS
        /pPcjW2KXVhc6YzXgDQTlcyhogzLdDg=
X-Google-Smtp-Source: ABdhPJzQhxG12fnIEGL4Kk/CfNu5h4cQF6RxRhF8ZObROz1CsWweffBsfYHgaNUrnId/kr9euOTyvQ==
X-Received: by 2002:a4a:ea5a:: with SMTP id j26mr15766191ooe.45.1612282590568;
        Tue, 02 Feb 2021 08:16:30 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id v138sm5140080oia.32.2021.02.02.08.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 08:16:29 -0800 (PST)
Subject: Re: [PATCH RESEND net-next] netlink: add tracepoint at NL_SET_ERR_MSG
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <fb6e25a4833e6a0e055633092b05bae3c6e1c0d3.1611934253.git.marcelo.leitner@gmail.com>
 <20210201173400.19f452d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210202123007.GE3288@horizon.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <37002645-e09b-1067-eda6-ee30155afe47@gmail.com>
Date:   Tue, 2 Feb 2021 09:16:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202123007.GE3288@horizon.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 5:30 AM, Marcelo Ricardo Leitner wrote:
> 
> Also, if the message is a common one, one may not be able to easily
> distinguish them. Ideally this shouldn't happen, but when debugging
> applications such as OVS, where lots of netlink requests are flying,
> it saves us time. I can, for example, look at a perf capture and
> search for cls_flower or so. Otherwise, it will all show up as
> "af_netlink: <err_msg>"

Modules should be using the NL_SET_ERR_MSG_MOD variant, so the message
would be ""af_netlink: cls_flower: <err_msg>"

I get the value in knowing the call site, so not arguing against that.
Just hoping that your experience matches theory.

