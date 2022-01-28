Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EDC49F4EC
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239626AbiA1IJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiA1IJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:09:32 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0908FC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 00:09:32 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o11so5825339pjf.0
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 00:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=60eR7cqDZuL/+e8EBnINpvK1Txj9LvT3yi1EqNBrS3E=;
        b=Ia30ruswPfs2wIiai66J6mHjirqShTj8AiwvfiRbhInXd5dGlxTuJZPX4Jjn2WtpX5
         dSv/cAe3LqyqFQ1XpcsToXdYM9jGHB0gPTn8jVenyYT/sjZi+/4IEzFrU4iQTs9ibHE/
         snrFQXKxW4bE11a6P52YPYeF116CDCRt2qVCohjXR1ZBISnLgY16ahEJIwH3h2AxWCPp
         R3ePJjUC79irAb3BkPEqbGZvCEtM2tqFma+JD4x6qg7dA7NbR+Gg4h1fVMFBlEseoGCd
         t5Ysktyy2iO7AxIpy0EUD/bgyP44iBS74Jju7el1527qxefzoDAbLKj5tlvPC0C4PXMO
         35LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=60eR7cqDZuL/+e8EBnINpvK1Txj9LvT3yi1EqNBrS3E=;
        b=G4blUUUX7xD1KEGyU284xcdzuBRen8k9qEK+dlT0T/s+K3qwDEdRvu7NpBMN3QMnCv
         aq3dzieWT7gHInkwbQUEn5F41yFGwqeqPe1GUaWz33pN0P7di3XwyPknGC28TTEZP0Hw
         B59qdWYa9WZaE2d9ghYtd99b9IEoiJft6tFllFf1iPE7bA9K4nLlq0XiGcm4G8sIq50/
         hoD6etRkUBIdOIfSLRMTonxG8C0823oGd4ffdM74LNOVqBC1FsHySJGJIT8E/jOh84Wj
         jgDtXvTsJCszEPUjbIKqIzfjhgg7f4c6paAN23SXb/UvqBinyQSsDyC3ghQiwaK4LyJK
         4UtQ==
X-Gm-Message-State: AOAM530qIaWAn9hQ/g2CbHR6KqZUBGXGSjjZ7XzMyV4rOROFFndrCWJF
        IMECc1w8OFXDpF/Hk9fAg5E=
X-Google-Smtp-Source: ABdhPJwUHepmismbgCrHsj0QlqQBCZLa4Ub92AV8MBlFy+KlTIweW+48DSGSaD9A320IpsKFwQIhww==
X-Received: by 2002:a17:903:249:: with SMTP id j9mr7049817plh.95.1643357371591;
        Fri, 28 Jan 2022 00:09:31 -0800 (PST)
Received: from Laptop-X1 ([47.243.140.117])
        by smtp.gmail.com with ESMTPSA id l17sm8371310pfu.61.2022.01.28.00.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 00:09:31 -0800 (PST)
Date:   Fri, 28 Jan 2022 16:04:54 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC net-next 3/5] bonding: add ip6_addr for bond_opt_value
Message-ID: <YfOjpuyiiwp+UffI@Laptop-X1>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
 <20220126073521.1313870-4-liuhangbin@gmail.com>
 <bc3403db-4380-9d84-b507-babdeb929664@nvidia.com>
 <YfJDm4f2xURqz5v8@Laptop-X1>
 <7501da6a-1956-6fcf-d55e-5a06a15eb0e3@nvidia.com>
 <YfKLgL6qMDEQTS3Y@Laptop-X1>
 <e080838e-ea33-7340-716c-f61cd57c32fd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e080838e-ea33-7340-716c-f61cd57c32fd@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 02:14:16PM +0200, Nikolay Aleksandrov wrote:
> Yeah, something like that so you can pass around larger items in the extra storage, but please
> keep it to the minimum e.g. 16 bytes for this case as we have many static bond_opt_values
> and pass it around a lot.

OK, I will update the patch after Chinese new year holiday.

Thanks
Hangbin
