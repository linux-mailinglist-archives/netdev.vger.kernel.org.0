Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5081934DEFB
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 05:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhC3DHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 23:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhC3DHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 23:07:37 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10929C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 20:07:37 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so14280332oto.2
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 20:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yo99VsZkIESPxOVXMxfl44B2rhglYcRvbs5H1fESv0I=;
        b=QkWXPaW4XadFtNVNq4+AF0DOtLJI5HF+Ig0wC0SKa9PW2njgCogCLPSXRYc0HoxBBb
         S5AXwSJTiIQSrv+bhzAfMxmuagpnYqUmfMOXs2s5ktsKLFoOXVmQc99kK7e4Yr+C8u4t
         QOOsLcmA8VDTXg6Qv7OdVrT88pI2UbAbaOpFnIfnCsuXcx7npcQrD7f7HKNbnvCm0KBS
         ALdS9xk/EPTLF624kFRCKCcp3pno1/6MNUk0pacsGy9ifsx2Y20+hNxE5TkyBOPTEvQE
         bbs3PfTiUgDW5IeDgBi6Tc1z7qJfn0mt7ArWofYiqQ73ikfhWZMpfxPHcQ04UVVvkT+x
         IyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yo99VsZkIESPxOVXMxfl44B2rhglYcRvbs5H1fESv0I=;
        b=hPcMo50i1639IQS71JL+LFDAosViQIw2QVk4PtxrbbFXaf6l4hQRA5kr3SpdgPIjjt
         PngOozA8x28EBGIqntqnVSnFkPo+dVuFQvbXqagXco/IGqFkozgjsxH7AHqvcsmc2Cdf
         asTImW2e6jXeNbW1R0W6J/7Ip+za/tsaKTSe/WlkLv/azyErWEMrpChz6ZDeQsyF3J+K
         GK9APEw5QUV9MnK+5oma6bpuA7GQdiuhgPL/PxZLxohVSCcPsPlRaS8OdGmE20YPo9c3
         VLPnNxGgjCVZ5sUFHtaLfVMUvsFpZbP7LiwuMHCja/YvWU/1JEr/Xo4s2m5dul28Vt7u
         yF4w==
X-Gm-Message-State: AOAM533tlcJdLekLR/okQraVkMUgDMsW0IBzpIFc8QlN3eHTmLNmBpxS
        Vm8sV1DSwOsRYPsdZsrvmCjE9i0UZD4=
X-Google-Smtp-Source: ABdhPJzfdUKSEjICmd6B/rFlCg9iQshSFhra+2+p9oQoyVqag3YHXaS40bPDJMYnEWYUExk2yaupPg==
X-Received: by 2002:a05:6830:2472:: with SMTP id x50mr24968896otr.69.1617073656254;
        Mon, 29 Mar 2021 20:07:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id w16sm4921933otq.15.2021.03.29.20.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 20:07:35 -0700 (PDT)
Subject: Re: [PATCH] Add Open/R to rt_protos
To:     Cooper Ry Lees <me@cooperlees.com>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
References: <20210326150513.6233-1-me@cooperlees.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <21b6c796-f225-44f3-da3a-f1f3635f5d6c@gmail.com>
Date:   Mon, 29 Mar 2021 21:07:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210326150513.6233-1-me@cooperlees.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/21 9:05 AM, Cooper Ry Lees wrote:
> From: Cooper Lees <me@cooperlees.com>
> 
> - Open Routing is using ID 99 for it's installed routes
> - https://github.com/facebook/openr
> - Kernel has accepted 99 in `rtnetlink.h`
> 
> Signed-of-by: Cooper Lees <me@cooperlees.com>
> ---
>  etc/iproute2/rt_protos | 1 +
>  1 file changed, 1 insertion(+)
> 

applied to iproute2-next.
