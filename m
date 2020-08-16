Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77F2458F2
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 20:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgHPSPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 14:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgHPSPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 14:15:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817F9C061786;
        Sun, 16 Aug 2020 11:15:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so6384372plt.3;
        Sun, 16 Aug 2020 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7eITYE/vrrdjskd5W7C36g1IzW1kO3mM/GcgPPbFuKM=;
        b=HyPaN9HRG0Mi2qCWoWQx2PWfgGD2dBMJy83WaE5KBS0qWZhAdue1tcVB+6k4X3wbWV
         orTzizKZM0nOpr6g5pdNxG6X1Ai7b0ECGTNhODzbnm4fz2SbWfGMTv+4yg/VWrIk8rP+
         ceCz3kcdSvD3j0bjsvWCGXfJzKjViIEIq4nxZgOPIgAkKc2GUSpO+lex0X94OZ0PrQxG
         hkBB1LyvGbrtPdso3OLwC8NQ238kWFtR0S/A1hVYHeBR7JP1oUtMPViMsu313u56BYDG
         hOZVQpAIk6OtRere0FTLbQQISXsfiEmlxZ8fyHQR/Z8zkeFk7qA0UdhgHNpwdv1x7gGk
         qXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7eITYE/vrrdjskd5W7C36g1IzW1kO3mM/GcgPPbFuKM=;
        b=e6n/iw6zj9w7gGCm6JK9egMeiRqISPgw24vviIEXs2t4eiyu9ciad+OjtvhAmZyFxi
         f4fNU4A8s5eL28AR+bqR+w6vUftCRcLkO4RiAnZfas2ndKu6LEmvD/R7epokkM+9e87b
         CSZttHdZIjDfqawV/TYxXMhou0o80VmkomnBUCEBqaA8d2NDgMSpsWOnn0gPCd6gqEWE
         U7q1b+A2r8Vgqo2Pw1yDJAdzgHCBRarszPwb5VmF1k/lKNPZ14wS2hxsctvcjAV6jMn4
         aaizefBfiWiyu0hHpGX5hNuIvIjHdzTAw6C3cEIwgPVnQnVfuHcP4z7xPPxkBm2CeL+S
         urbg==
X-Gm-Message-State: AOAM530jIrocG3jusvxOyLseEhIf+2fqiHm7SRIuihjO5V+adlCiy4UQ
        Eli6g3xV9dzttz8H4nTsCpz+DB8afl0=
X-Google-Smtp-Source: ABdhPJzDVeD/HiVJO3rMb15GrpoaQIdnJhsHTB/12q5ZLb9bhTvfgDd0zzTyp6ouNffxA9p6np8XfA==
X-Received: by 2002:a17:90a:8c8f:: with SMTP id b15mr9660930pjo.84.1597601743152;
        Sun, 16 Aug 2020 11:15:43 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q6sm3113098pjr.20.2020.08.16.11.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 11:15:42 -0700 (PDT)
Subject: Re: [PATCH 2/2] net: socket: implement SO_DESCRIPTION
To:     Pascal Bouchareine <kalou@tfz.net>, linux-kernel@vger.kernel.org
Cc:     linux-api@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20200815182344.7469-1-kalou@tfz.net>
 <20200815182344.7469-3-kalou@tfz.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7c910594-b297-646e-9410-f133fd62a902@gmail.com>
Date:   Sun, 16 Aug 2020 11:15:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815182344.7469-3-kalou@tfz.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/20 11:23 AM, Pascal Bouchareine wrote:
> This command attaches the zero terminated string in optval to the
> socket for troubleshooting purposes. The free string is displayed in the
> process fdinfo file for that fd (/proc/<pid>/fdinfo/<fd>).
> 
> One intended usage is to allow processes to self-document sockets
> for netstat and friends to report
> 
> We ignore optlen and constrain the string to a static max size
> 
>

1) You also ignored what would happen at accept() time.

Please test your patches with ASAN.

2) Also, why is that description specific to sockets ?

3) When a new socket option is added, it is customary to implement both setsockopt() and getsockopt()
  for things like CRIU.

