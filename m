Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C053E5AE5
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241168AbhHJNSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238385AbhHJNSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:18:36 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74209C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:18:14 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id r5so18246186oiw.7
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7mztSBvsSUzkVNQShe4KwQk3r+396JkXgO1NpnElkGo=;
        b=GIqyvCoZDHFHIArLH8wgUajSrIPjhTNix/6YoTjGttonFeX/TxqXCOwZrUcymPXwD8
         6ftawq/Xp3iICtmeHlm6AH8Vxb3GW1eYwGHdBhOQlsf+08zxRnmNMb0j4fKhaLK4ROZg
         jH5XwtGveNfuHv5QjZSYjr49wgvmkq6V5ZrfIRw+x8a2WM8MdjKeCJtQYbyQr+6RLG2G
         poBa4cER2w3L10p0ipD0YLrOK7zOGX686roDV+IS0fu2qtlUX8x1AjVa2gORSp9m5o0J
         GsWuNTmjQrvuxaSMClRCnyqhQ5P44kTg7wCrjlIVcQHA4EukThj2eo+IaNRuP2X5l/i6
         Jsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7mztSBvsSUzkVNQShe4KwQk3r+396JkXgO1NpnElkGo=;
        b=C8a+7/AKQIw9aJ17hRhut76Zp2fxSCqxToerULl5CbDNZ8GGwzZt0qe/2N0uWiVlkc
         laoqF6LScXF97EMxSdBDABrMWpeUpNdY6X/imwoKoei+CFsyqYW+MnHn1kQaw9YBLhJt
         N2J4uivUQgyDiy7ld62FYzWufJopEuSNKOVOfcdlva9JXrRCdBAXH43gm9d0syQCPKQP
         HxOiscTco8kYLBjM3gQcyH3ofcEmtDQTuIXrx3tZKobHgf4EyQnfv/ElkTEVGGd6YrEl
         64V9SprITCQjXJpmOGRF9XOPB6bbVP8FZugwrkCuOl3irxeiwXPwfYWvtyF5tFnrmGnK
         1XsA==
X-Gm-Message-State: AOAM5318NUE/M6vLeLcPaipPZ8JztYccfLQWV3XAhBBlmteKbyxwMZDv
        H+AG2YS9VyIznjdYJbnpns4=
X-Google-Smtp-Source: ABdhPJySP/hZPvfZYLWM/P7uJGjxEwUe2hkhQqHi4UoI0TVzctfs8Gslj2wRBwvFs/Xy7oMBl9vlxg==
X-Received: by 2002:aca:2316:: with SMTP id e22mr14487774oie.172.1628601493887;
        Tue, 10 Aug 2021 06:18:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id w16sm3907401oiv.15.2021.08.10.06.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:18:13 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] devlink: Show port state values in man page
 and in the help command
To:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210723145359.282030-1-parav@nvidia.com>
 <PH0PR12MB5481796816B64C41F8230E0ADCF79@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1b476bdd-dc87-4ddf-08b1-e2aaf7cca7f6@gmail.com>
Date:   Tue, 10 Aug 2021 07:18:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB5481796816B64C41F8230E0ADCF79@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/21 5:49 AM, Parav Pandit wrote:
> Hi David, Stephen,
> 
>> From: Parav Pandit <parav@nvidia.com>
>> Sent: Friday, July 23, 2021 8:24 PM
>>
>> Port function state can have either of the two values - active or inactive.
>> Update the documentation and help command for these two values to tell
>> user about it.
>>
>> With the introduction of state, hw_addr and state are optional.
>> Hence mark them as optional in man page that also aligns with the help
>> command output.
>>
>> Fixes: bdfb9f1bd61a ("devlink: Support set of port function state")
>> Signed-off-by: Parav Pandit <parav@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  devlink/devlink.c       |  2 +-
>>  man/man8/devlink-port.8 | 10 +++++-----
>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>
> Can you please review this short fix?
> 

It is assigned to Stephen, but some how marked as 'archived'. I removed
that label and it is back in Stephen's list.
