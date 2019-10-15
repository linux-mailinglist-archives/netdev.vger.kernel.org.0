Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04CCD6D70
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 05:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfJODBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 23:01:55 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:41860 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfJODBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 23:01:55 -0400
Received: by mail-vs1-f65.google.com with SMTP id l2so12127021vsr.8
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 20:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pkTiLWi806vFW+mAo2j2H2h/Fp/DfPd6WWAKMfdAAMw=;
        b=AHRc6Tc+o61hFN7HkohKMGkG68CB2nDANyc0FC7LppGhPBDp/bhLhpFtpWsDumZY+q
         nUyp7AZ700gagwUkblabr1ShKZwTEBeh0AyA1KcekdNTLAGuA1mnKQI4rHFh0IyD0ads
         kOuP65diMwVo5GSRgxEH6AecXk3NRY7Mh4gx5hm+MTpu4hRKkHbyiAC19Ljhng8gmASE
         B57e4Zkv7psrynvwbiRWm9tx+qy9WNhTl8r7BJiwVVoxaK94O+7xE3xSHVkdDQSQrzjP
         uP9JqltUe+XUQSCZnD8XAZAPpYO9v3GVj0r8SeFwU47a1nBF+OiMhwo0hqdaZe8y5b9v
         w1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pkTiLWi806vFW+mAo2j2H2h/Fp/DfPd6WWAKMfdAAMw=;
        b=Gq8pDHs/4QkLzmmlPJWgwa/Kim/dShFUkcwtWqfu4esHAJj/jfclHuNBDRFonQC7t6
         oGB1m2+dLetsSBWtS1Qs5pXrjfkAyCiXmhmmpl+tBGvukIe7Y3Oz5PuYGcCZUjY62qlC
         xUAeL8tJd4CpHsGOr9k17m6tKiLg6PhpbGUu6+dvdKBwcXN62BTGvw1XhOCfcC6/vKyQ
         Ul0Kev5urhdk/0r8AGjW/X9NuXR8/detpJX4weEIHRDLOfNF/Id2KzoiomMolTr7BNUk
         Syh0HBhwitJGe3oJYrwmMhHejM579V1I3gblgrwHfMiTibolyxhFO7lLMMoldfcdOhQ/
         NX4A==
X-Gm-Message-State: APjAAAVayv+yBJyhR8B2ID3KxAOcFkAa+Uhr98vK2o4SpRmeh7Am1z0Z
        He/dxGZiUJ7eFsz8QVdOlWGh+nmv
X-Google-Smtp-Source: APXvYqyFwmjHF0npSe3PXcMGXfxyQC7RoYl/d/SiaIRNFpOFnvQPLTJ8PL5GlPZOafbgIF+zArh56w==
X-Received: by 2002:a67:fb44:: with SMTP id e4mr18801535vsr.112.1571108512758;
        Mon, 14 Oct 2019 20:01:52 -0700 (PDT)
Received: from dahern-DO-MB.local ([199.231.175.194])
        by smtp.googlemail.com with ESMTPSA id d1sm6020343vsm.8.2019.10.14.20.01.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 20:01:51 -0700 (PDT)
Subject: Re: [PATCH] ss: allow dumping kTLS info
To:     Davide Caratti <dcaratti@redhat.com>,
        Andrea Claudi <aclaudi@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org
References: <2531403b243c1c60afc175c164a02096ffcf89a5.1570442363.git.dcaratti@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c65838d4-9ace-7881-1603-4660a338bd78@gmail.com>
Date:   Mon, 14 Oct 2019 23:01:50 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2531403b243c1c60afc175c164a02096ffcf89a5.1570442363.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/19 4:16 AM, Davide Caratti wrote:
> now that INET_DIAG_INFO requests can dump TCP ULP information, extend 'ss'
> to allow diagnosing kTLS when it is attached to a TCP socket. While at it,
> import kTLS uAPI definitions from the latest net-next tree.
> 
> CC: Andrea Claudi <aclaudi@redhat.com>
> Co-developed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/uapi/linux/tls.h | 127 +++++++++++++++++++++++++++++++++++++++
>  misc/ss.c                |  89 +++++++++++++++++++++++++++
>  2 files changed, 216 insertions(+)
>  create mode 100644 include/uapi/linux/tls.h
> 

applied to iproute2-next

