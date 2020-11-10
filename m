Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9F52ACC02
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgKJDsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKJDsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:48:54 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F47C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 19:48:54 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id r12so12295621iot.4
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 19:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nbsqLugZyK3YHDWoNDCZP+JdbtUKvtBB94M4SvpecBU=;
        b=o+qYughVE6n5njdHSCcgvCfNDFNUT/w5NdVCXEC2Nb4BaA+DbZ5x0G/n35Zz8JrXW4
         5L/sHeaiNrFZEZycIlHrGILWh5vHCncRe2ORHhOFhEAravi+KfueBOe0srN9N5Gwih/F
         bumxgVESJUwMSMHd4XV0qHzd29NMmrxIUiMWryKre7nqXef0ZcD+HmfKvO4IiP68SmqQ
         gEXdrjyI+aS0eTPh0sQTJ6h+cdatWY7AuDXEoaQhAublb488fhjQvNntn4lAXCFv569C
         aqNO8GcB9fRY5fE5ctUM3mt+yM8UkvyZPttbFzJBrrOFmQdTwtqkcVdd7thHtfjDcfTH
         7VtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nbsqLugZyK3YHDWoNDCZP+JdbtUKvtBB94M4SvpecBU=;
        b=G9aPJWZy9wIRKdZ39dd9UvMurnd5QuXi3qG8pez11vf852y9jTeX4soi2inic9vKdi
         m0E4aXMNBz4K3RhxWHqM3jORG5DrKgJ7n7ClsPdFK4j05dMmYSUp5g/+Dpt/fyCXb1Js
         AvRcfmN1HWgDXdzsQYsh9rhetqKiAqTYFKOvgBoaByH1A84UkOcL5m9OskS6lMTp0bdO
         UF/gIFRJLiLx33KJqFbfcVnB345/o6wU+aEolpN45fU4k8noKl4uzXahgebnsyC3Kxa5
         jovjR9XCnJhHtutd+C8Er2dZQFILzq1f9EltBLZr1QRx838SY+baOyjU7MtTtbPZnCYd
         agVg==
X-Gm-Message-State: AOAM5313kLkl8Fq4vTznLyEIJ4sE/bHyqx05M0LqnE7nVp41rU+11V2l
        JyMI18xY3i8mPux1v3LT60c=
X-Google-Smtp-Source: ABdhPJxaGKoHmbv7wPtsMSCARYW3P0cfMvs+rYP//JSuFxAKiJxWIQjoFSTBnP4o4d7P0OxrVjI7fw==
X-Received: by 2002:a05:6638:18e:: with SMTP id a14mr13225557jaq.46.1604980133562;
        Mon, 09 Nov 2020 19:48:53 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7980:a277:20c7:aa44])
        by smtp.googlemail.com with ESMTPSA id l12sm6760729ioq.16.2020.11.09.19.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 19:48:52 -0800 (PST)
Subject: Re: [PATCH net-next 00/18] nexthop: Add support for nexthop objects
 offload
To:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20201104133040.1125369-1-idosch@idosch.org>
 <20201106113159.6c324275@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201109154105.GB1796533@shredder>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1022fa34-6334-0aab-fabd-973fed85b70e@gmail.com>
Date:   Mon, 9 Nov 2020 20:48:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201109154105.GB1796533@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/20 8:41 AM, Ido Schimmel wrote:
> Great, thank you. And thanks David for the awesome work on the nexthop
> infrastructure.

thanks. Looking forward to the next round of patches for h/w offload.
