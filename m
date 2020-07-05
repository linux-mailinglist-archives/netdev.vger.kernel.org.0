Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF004214E69
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgGESOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgGESOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 14:14:41 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AE3C061794;
        Sun,  5 Jul 2020 11:14:41 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id 6so2125408qtt.0;
        Sun, 05 Jul 2020 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GIreVTA9iB/LiEwX5eX3Id+ZA6LegG5/LPJAdXTSiLo=;
        b=aFRXkn+gl/5LDeXVtACZ++CLgZGQgZVEZ+lWXFf0hwl23rd2STQGDjuBsh5UeCWuSg
         SFhb6+xZdmN3kAh5r0wG0/4D0Rp1+cnPRROR2Mk+5S9gYFZwJY7jTk9I+pPCDg6bsYQS
         /+e0EWquNjwKG63CMOoYPAw1SOnQ7FCmFk1abwKm5zLtTZvp96kWWgctM5zzMG+h98A1
         z23cms9ivIgazWxsuuCwlEQIVI09DS/EAlDarCavImwtkfrZW7N2/PpE249d7W4kF2ur
         NsrgMdCBX8qpQDHMS00cOFfhxLzwt/ZO2iyNXpRolt1rCxOMYtQn9HnLLiFvpF9UoaJ0
         Rugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIreVTA9iB/LiEwX5eX3Id+ZA6LegG5/LPJAdXTSiLo=;
        b=DSvbUGTI74L75do6XS51ZXfG+R8OM0CIH+m/wDDiV2/UEM6xF/anjWxqYrlSHPNDLF
         zmp77UN1tdjs9Ow42EsFLi8eSUcZk1jJryzDYItJmOYKuQQku61herbTjb/6ypmsXkYh
         dcUkl064dZyqKdtgK0MZWVjpcNIMLMC6aaovOdxDxhVYCV4TAGXTd/zG6u54TvaIbGkp
         V3a1beqj/3gC4ANQ+SKbrpcFME+InJv6MDfXHTGtviiX7e0d9hlcm3JAm55r83Li/Xx/
         u4v1GO24g7nSnZgpfyx+dWhPJjZem2Qd62vm3dnaJlZc27P1b+EubYcdoac21UNdFJt5
         s5Qw==
X-Gm-Message-State: AOAM532AWjekzpoMsf/qgcszjrMT5jGYtAU64RpkGs/iv43N3WbByOuM
        TEN0gaTb/52YMGHmnSvNY6oS4FQZ
X-Google-Smtp-Source: ABdhPJzCmZeanB6erjqmg+g3PP/SDAzYs5pBtaNFqWXVAiyBoy0FU6N4WY+gFVjTVGlweeuiIZI2oA==
X-Received: by 2002:ac8:4806:: with SMTP id g6mr42823257qtq.213.1593972880680;
        Sun, 05 Jul 2020 11:14:40 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id p7sm16478215qki.61.2020.07.05.11.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 11:14:40 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v1 0/4] RAW format dumps through RDMAtool
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200624104012.1450880-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <974f4012-d730-c44f-af2b-cb25797f2f47@gmail.com>
Date:   Sun, 5 Jul 2020 12:14:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200624104012.1450880-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/20 4:40 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
> v1:
>  * Kernel part was accepted, so this series has correct SHA for the
>    kernel header update patch.
>  * Aligned implementation to the final kernel solution of query
>    interface.
> v0:
> https://lore.kernel.org/linux-rdma/20200520102539.458983-1-leon@kernel.org
> 
> -----------------------------------------------------------------------------
> 
> Hi,
> 
> The following series adds support to get the RDMA resource data in RAW
> format. The main motivation for doing this is to enable vendors to
> return the entire QP/CQ/MR data without a need from the vendor to set
> each field separately.
> 

applied to iproute2-next. Thanks


