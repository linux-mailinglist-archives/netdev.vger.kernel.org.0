Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B987479CAB
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 21:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhLRUxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 15:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbhLRUxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 15:53:05 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5605C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 12:53:05 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id w1so4477716ilh.9
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 12:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=D9CxRDuwaO90NwhAK/YCc4eVCem0FDVJQCMxRvIwU18=;
        b=PHo3EkosCS1Goy5mvbAZw1YeJmX28wLDrsT60u7SJSycSUJdvQpHxML7EZWzOJUxgs
         xrdI2lW3OJv7x73Qh1GmediVxMGXJG3dr2Y4ttb09lt/EbrWyoDcJhOL9x0oXARpY5DU
         d2xQjWat5QVZUD9aETgGkwAE6QwMuL+o/t6p2bCVlfdcCuN1AlKHMo2Sa3dGdNQy8N7G
         a4zOSxgNXO53E8Su56z1hz3OpukzXfDLu/iLh83Noh3T49bQ81ReHN+UdaNXlWL8eSG0
         xpz2KCXF64l+RzCWmchEko40rwKJODV15PTpE7hjgqtVx++Mu+1FsPO0GHdYKIJpPbuq
         4/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D9CxRDuwaO90NwhAK/YCc4eVCem0FDVJQCMxRvIwU18=;
        b=dS7p0pCtLMfC5JUMMud2WKYr0GKZiUjAMcIJSsU9zedIAtoLaktlAfVYU32wlTzqn3
         YdFNbi9ByJEbPYoMa4Z+PWBKOgYp/TgQ6frrRleCX8ziLXddt+nkWUMR4uKkbfGz/qUp
         RR+eSegakC6FLw5JkrrbgteeMIVk2iOzBeEhpE0LpLfwNsnKgc1TmuaDXZt+VOfmMzF+
         0Jno6ZwUEoyFo97mF9ga21+VbKWru6EmfX+APHZoiGfGC3s1JSr4WyATQRYKJ5y84BHt
         VEt2ShMSEhlSqKNYLDo5fFzCVBvVQXCCllt04U/0v89NR4tiIQdK3iMTkG5un9eL5bhQ
         zsCQ==
X-Gm-Message-State: AOAM531GYIdy+xcCKc+Ohm/KVH/0WTlIFCL4kgehmbV30jh+S0sv1VSp
        D/cK6V62RvuIYwQewKBW+uE=
X-Google-Smtp-Source: ABdhPJxw/Xi25FdgBQAjQARai8EDFZ54aU8vWuKnGsbpVbuIbszpAmQaZ7OnJEHRiRhsPvKZBmmjbA==
X-Received: by 2002:a05:6e02:170e:: with SMTP id u14mr620316ill.111.1639860784719;
        Sat, 18 Dec 2021 12:53:04 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a12sm7082127iow.6.2021.12.18.12.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Dec 2021 12:53:04 -0800 (PST)
Message-ID: <a38a9877-4b01-22b3-ac62-768265db0d5a@gmail.com>
Date:   Sat, 18 Dec 2021 13:53:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [iproute2-next v2 4/4] vdpa: Enable user to set mtu of the vdpa
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, mst@redhat.com,
        jasowang@redhat.com
References: <20211217080827.266799-1-parav@nvidia.com>
 <20211217080827.266799-5-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211217080827.266799-5-parav@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/21 1:08 AM, Parav Pandit wrote:
> @@ -204,6 +217,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>  	if (opts->present & VDPA_OPT_VDEV_MAC)
>  		mnl_attr_put(nlh, VDPA_ATTR_DEV_NET_CFG_MACADDR,
>  			     sizeof(opts->mac), opts->mac);
> +	if (opts->present & VDPA_OPT_VDEV_MTU)
> +		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);

Why limit the MTU to a u16? Eric for example is working on "Big TCP"
where IPv6 can work with Jumbograms where mtu can be > 64k.

https://datatracker.ietf.org/doc/html/rfc2675

