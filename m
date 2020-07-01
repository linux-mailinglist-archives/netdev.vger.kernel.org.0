Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46459210BBE
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgGANGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgGANGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:06:54 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D95C03E97A
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 06:06:53 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d15so19642702edm.10
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 06:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wd8wIUrS0456MwTk/SUgUrxYCu2AOW/qWk9t9J64btw=;
        b=a+jKZaWfW7ug8WaGI1cTqoOla1mXa9kb0RodqQPga7XkTvjpRsoWlXgvIvdXmeS6sV
         /AKdQk53TmtjP5yPT0wjEhji6LUrEKZZ9u0IsWeOUaKVinzO85Rvuj8zEdtD/J3YSU1J
         W0UPuet6/q2Dvc9+W+U393z4LHba7mC+gpE0LPnhJri7KhCgzvbsGFzWXQkDnz6Fc+H8
         0KD/N9x1FTn2CgZvHwu4xmhnaSQoLlKAsr/YH23sM4qKeZsBGSKRzqtiM+hHPtarDq1w
         3RZSsQrG978hrlDUik6NASx1vRDl047YN86gd5paLHlWwQZoLldL980JQGUfcPg56C9g
         uoxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wd8wIUrS0456MwTk/SUgUrxYCu2AOW/qWk9t9J64btw=;
        b=nIt6/tz3MnZke/gJiu6+YDMtJYHdPJylHTNJUYR5opCyod7C4E/BzZTeQltB3nk80d
         lRWxN5f5y+6TP03dEEpxLsnGNsWvwejUfxd6HC1c1eiGn65af5kt8SVmI9u1PE96KoFb
         JC8jNnbLVWeDxhmJZ2ceTJw8fmCJWPiKQS85GeNjO/wHtLf4dRJctbygslTxU/3dCXPU
         xCOZwcsNLpa+17zPvgcmL1BIXFZGHtU4olZtf+6ljsjzlOqsE4xnlR+iyJrRAU0eLXPh
         POUs1XsxGyFbxn3jiCF2bfRLm5+EDLqhGXkUH80ElkZZONi1ia0u+qvMs75QjHJ9hBBi
         9yeg==
X-Gm-Message-State: AOAM533vetxzknPxppw9cZQOk1TYNTGR/MzuY1qqCLYMN207HJpnVnSM
        hPIJLIYhoNkOIl0D/DwMS3Gt4X1V5Z8=
X-Google-Smtp-Source: ABdhPJzmgtQ6RayagjPq0oip89sEoJ2zbx/GqpUShmT8ndS7xK7HxJx+LUofhq10Choy/lSFyF5JNw==
X-Received: by 2002:a50:ba8b:: with SMTP id x11mr29784069ede.201.1593608812313;
        Wed, 01 Jul 2020 06:06:52 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id b4sm6020172edx.96.2020.07.01.06.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 06:06:51 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] selftests: mptcp: add option to specify size
 of file to transfer
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org
References: <20200630192445.18333-1-fw@strlen.de>
 <20200630192445.18333-2-fw@strlen.de>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <1943d2bb-fc60-4614-07db-e56d7e3a824d@tessares.net>
Date:   Wed, 1 Jul 2020 15:06:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630192445.18333-2-fw@strlen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 30/06/2020 21:24, Florian Westphal wrote:
> The script generates two random files that are then sent via tcp and
> mptcp connections.
> 
> In order to compare throughput over consecutive runs add an option
> to provide the file size on the command line: "-f 128000".
> 
> Also add an option, -t, to enable tcp tests. This is useful to
> compare throughput of mptcp connections and tcp connections.
> 
> Example: run tests with a 4mb file size, 300ms delay 0.01% loss,
> default gso/tso/gro settings and with large write/blocking io:
> 
> mptcp_connect.sh -t -f $((4 * 1024 * 1024)) -d 300 -l 0.01%  -r 0 -e "" -m mmap
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Thank you for the patch! The new '-t' option was also very helpful when 
investigating the issue 6 on Github!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
--
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
