Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1034E261CE8
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732194AbgIHT1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731047AbgIHQAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:00:04 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D92EC0A5532
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:58:09 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t16so15620420ilf.13
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eOBqxluYgbtjs+pdtfnNcqC14VM+ovLGlJmuXt6lHEQ=;
        b=Oy0A8+M16qNc4yfjYpMQ6owubLcoHXzycgMd+u8z5AKssBax2mNX/xMC+Rb57P2s2R
         rr1tNq+klKPiJ0n3I6jnpovRrk/WV3Ttw2eeviiBdwNgMpbi4SKuNG5JafIWpDlgsMd2
         4BEWFU8HGLt4uzcDIfStu2l97lPEvr0pptc4WX5iIpnI17L5TVqFOA1XvTmj5wCZWsep
         UucIkmrMdYR3jDtfgMQZpFThhPT3Iw2IBgp2RyxR5dXlFzZsO5C7TS7pXMQmqi11wH5Q
         7p6hmbte0G83ZZwB2Oa8LDToMHJEl13cAonwZTj7Gs0R/cg14ovkz/3YJBQMH1Zf7Rtq
         yPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eOBqxluYgbtjs+pdtfnNcqC14VM+ovLGlJmuXt6lHEQ=;
        b=Tshbm0mk4UlxsCIvK+iHBLFdtQ9nbEFAKx++izE3TXNsRcCKgYkIUlNSD7w2trzib/
         Tuan74fLnb8DFCGiFahKn/Punpdd18ZewMgOx4x9FeQCvW9Y5MXRgnlzKMt9+U/xnayA
         scTKbvbZAVMFmeu1sS6OcUFfc4q8aQA29M3XKJ3/7XqcKOeKig3A+edwqK3K8sjeIG8f
         KMkx6B52b13o43ARpzQD47REX+UgEJq3OPMY4kLlObHBDv1oxLwn1lFCJsUlAwsDfvFU
         oOH6VTmof4krK81YvL3q6KfWPOp5B0QWGiMOl6zWZR8a2nipWWzjhaS6ZxJybzOlKDtU
         RSjw==
X-Gm-Message-State: AOAM531GDGJC6sHcfpzSis6llUuQQHgAr2tLnMsO+bNv/3Q0JWbe/n/K
        q3Ro5ZrW6sn0D94RxP4tG/Q=
X-Google-Smtp-Source: ABdhPJyHn7TasF+5jbf/oaSVhyD/Qu296qgCvQF3VXPiNYXwB37XnoP9mS+QzoO2qimFL3ZRjY6jew==
X-Received: by 2002:a92:5f59:: with SMTP id t86mr24134980ilb.111.1599577089023;
        Tue, 08 Sep 2020 07:58:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id d19sm8855992iod.38.2020.09.08.07.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:58:08 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 08/22] nexthop: vxlan: Convert to new
 notification info
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-9-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <636e2c33-6936-f703-6be9-4cec8aef4b6a@gmail.com>
Date:   Tue, 8 Sep 2020 08:58:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-9-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Convert the sole listener of the nexthop notification chain (the VXLAN
> driver) to the new notification info.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan.c | 9 +++++++--
>  net/ipv4/nexthop.c  | 2 +-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index b9fefe27e3e8..29deedee6ef4 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -4687,9 +4687,14 @@ static void vxlan_fdb_nh_flush(struct nexthop *nh)
>  static int vxlan_nexthop_event(struct notifier_block *nb,
>  			       unsigned long event, void *ptr)
>  {
> -	struct nexthop *nh = ptr;
> +	struct nh_notifier_info *info = ptr;
> +	struct nexthop *nh;
> +
> +	if (event != NEXTHOP_EVENT_DEL)
> +		return NOTIFY_DONE;
>  
> -	if (!nh || event != NEXTHOP_EVENT_DEL)
> +	nh = nexthop_find_by_id(info->net, info->id);

hmmm.... why add the id to the info versus a nh pointer if a lookup is
needed?

> +	if (!nh)
>  		return NOTIFY_DONE;
>  
>  	vxlan_fdb_nh_flush(nh);

