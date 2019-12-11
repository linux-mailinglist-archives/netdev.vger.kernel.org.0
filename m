Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC9411BA25
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbfLKRXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:23:49 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45088 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbfLKRXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:23:49 -0500
Received: by mail-qt1-f194.google.com with SMTP id p5so6911529qtq.12
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=f64X2rBvZDBNEcF2CizXPxpl55g6sEslQZw9hiEJKUs=;
        b=htqYtX1jtzQENr5XOwW5QtmXinWkiyyxXitgpc7QLi1UujzF36lEyKpRmWT+Ka+Tsi
         00GULav6zvIbPSufP9Pt/YL7pTVx98NzW4dOQ9ZUc+Uma1wI2qtBjsXY1CA1eE18suzS
         kNiKF7krJ4hwD7XOUXEBaePS+jH9lPNmHYwo4KaK6h8oQc4zrPZt0lljdLE5ACo1/ikl
         bwM2IgGFods/XgpZUWvr7wsElWpgnjPXcQISG2rswl+R3VTzx5PqNIssOY/cuAvXFkDC
         kP98gYZCmTNW/AAZGDSOOtAh/u5yQcsJxrr1X0EzEyvGEBcrYuHFRDnlXurFtmWgjPE4
         V89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f64X2rBvZDBNEcF2CizXPxpl55g6sEslQZw9hiEJKUs=;
        b=KMXfgIPLuFNjD3PmSbIzC5iE11kvt1X6RIk5rq3JinTFifYh5c+q5OVGm7FoRIVyVs
         B2GnTdIiBpURiJAdwRkVCnr+ksu+kJ0qVtOkVxO4se3r9p7NdE8MQKEMs0NsCX0sjGRO
         pK5SlvTVsTENBivmf3MVbSD2F1mv5yVCUwpdXQ9A3zvYEqIzHztIEcSs9hmdur9JReLo
         Nidn2kOVa8m1M1Huwjky3OEbOTcFXDsvN+428GovJdIbdr//VhE0FeGX2WnzS1eCK0sB
         hxdd0+S91HAkOZmqKan/13EQ6Ls5zCmgqFJD8PnjeZ3jPc2UcevvFD8p09vssGOdw8ef
         r3uQ==
X-Gm-Message-State: APjAAAVQWqPyUiw+ddjRIMZINhgafkSY45v+6eQYz/+qqEDdo/pNyApH
        xneWPux97oCJ7hupSo3hhLPDg+KlcTE=
X-Google-Smtp-Source: APXvYqwrqcxXjsQqldf5kHnp++RHt5XYiV+CjuhwUuW1TaKPSmAroT5+XZqPzPru1S68cdzZiB+Okg==
X-Received: by 2002:ac8:4509:: with SMTP id q9mr3546407qtn.214.1576085028301;
        Wed, 11 Dec 2019 09:23:48 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id i4sm851556qki.45.2019.12.11.09.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:23:47 -0800 (PST)
Subject: Re: [PATCH iproute2 net-next] add support for table name in SRv6
 End.DT* behaviors
To:     Paolo Lungaroni <paolo.lungaroni@cnit.it>, netdev@vger.kernel.org
References: <20191206181154.3740-1-paolo.lungaroni@cnit.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d8d662a5-f530-7dfa-6bcc-014ca2084092@gmail.com>
Date:   Wed, 11 Dec 2019 10:23:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191206181154.3740-1-paolo.lungaroni@cnit.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/19 11:11 AM, Paolo Lungaroni wrote:
> it allows to specify also the table name in addition to the table number in
> SRv6 End.DT* behaviors.
> 
> To add an End.DT6 behavior route specifying the table by name:
> 
>     $ ip -6 route add 2001:db8::1 encap seg6local action End.DT6 table main dev eth0
> 
> The ip route show to print output this route:
> 
>     $ ip -6 route show 2001:db8::1
>     2001:db8::1  encap seg6local action End.DT6 table main dev eth0 metric 1024 pref medium
> 
> The JSON output:
>     $ ip -6 -j -p route show 2001:db8::1
>     [ {
>             "dst": "2001:db8::1",
>             "encap": "seg6local",
>             "action": "End.DT6",
>             "table": "main",
>             "dev": "eth0",
>             "metric": 1024,
>             "flags": [ ],
>             "pref": "medium"
>         } ]
> 
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
> ---
>  ip/iproute_lwtunnel.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 

applied to iproute2-next. Thanks

