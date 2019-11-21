Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04EE105A93
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKUTrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:47:07 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45954 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfKUTrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:47:06 -0500
Received: by mail-qt1-f193.google.com with SMTP id 30so5014018qtz.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 11:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1wrZnmz4pWQby46tFwFeUMbdVaMTLA4eaqr+Zqe1q/Q=;
        b=Y7kGxZGWDY0TtFAamaeKOw/IYXYW4L+db6U1ag7YFEkEnsZ5lvzX/xgapgXmC4+JlU
         HifKDcFYyhCx9aj4V2DYYvOPVFHOLvKtDIzdY8KGbUlTtcbJtU4W8+bWPzu8elVDoaHB
         MD1NE9QrQ6LXc6usnJjwLd97DCSHnaF7DTtybbXQa6v+8+UiAlUML3X2/sqs0+TfqdAi
         bTlDk7gon+tnfLz/pGB3Rb+vheXIcPqqIEfn/EJgV6fKT6TWngMhCKjGI8dzAwS4OLGO
         UoqbTq0JTYTcgmL5dJVncjFpsjaEdu/aUiphdbViWn+SEkpiVCB9fPPHYp8YhRWCdBIU
         8Z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wrZnmz4pWQby46tFwFeUMbdVaMTLA4eaqr+Zqe1q/Q=;
        b=ppAU5PN02r5Gz6QEB8/dbzRuEHh0qkIRrd7zsUDregj/lUwSgk6IFON2R9pdCciMI0
         z0JvaRfYbc2ggtUkNRg5eTVfljf+zDrijwlunVajnAFV5XA1z/7ZioN8lWbJ+1aaaINg
         u1aa9osvK9MF/6vrwyyClfrl+4M9vW7SU738EcKexICF7Gt6oxphGS2s7TXmA0rsr5N/
         kZBAFQEaKkijKs7INQkSY9kclCbiOLZAdmZpN1UKqaosMII8qO2nEIWzVE5gZCcm4/ko
         MLm+DH1ZpYBuU+g0QAvdRLGS3vbxOu9KR3fwhrWp0/Ks9EQqhdE/3yDKg7/0+2/ridDm
         hvWQ==
X-Gm-Message-State: APjAAAX5TD3bdyz61N6zERFqhHtvG4FBIGnCYqqzzT4sh0XcffmMZj0B
        uc52SCIXsRSuwpzCNs68TUA=
X-Google-Smtp-Source: APXvYqzfA8Z1KLashA7uNh3vYrWL2XQATutTcKNBX2MbmLCoge928vMJSjuUhV2pxlM0XQVFIz1NCA==
X-Received: by 2002:ac8:18af:: with SMTP id s44mr10303707qtj.1.1574365624382;
        Thu, 21 Nov 2019 11:47:04 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id x39sm2126661qth.92.2019.11.21.11.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 11:47:03 -0800 (PST)
Subject: Re: [PATCH net-next] net: remove the unnecessary strict_start_type in
 some policies
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
References: <bcd455a3339a42f32dd2970d5495740ea1ee142d.1574330918.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1e546f81-559a-b03d-5acf-b935fcea0268@gmail.com>
Date:   Thu, 21 Nov 2019 12:47:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bcd455a3339a42f32dd2970d5495740ea1ee142d.1574330918.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 3:08 AM, Xin Long wrote:
> ct_policy and mpls_policy are parsed with nla_parse_nested(), which
> does NL_VALIDATE_STRICT validation, strict_start_type is not needed
> to set as it is actually trying to make some attributes parsed with
> NL_VALIDATE_STRICT.
> 
> This patch is to remove it, and do the same on rtm_nh_policy which
> is parsed by nlmsg_parse().
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/nexthop.c   | 1 -
>  net/sched/act_ct.c   | 1 -
>  net/sched/act_mpls.c | 1 -
>  3 files changed, 3 deletions(-)
> 
>

Reviewed-by: David Ahern <dsahern@gmail.com>
