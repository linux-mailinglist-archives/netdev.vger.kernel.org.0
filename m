Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9F46D4E
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 02:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFOAuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 20:50:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38696 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOAuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 20:50:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id a186so2367891pfa.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 17:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SB1Q8SSF7pRRlD0QHTZOwgGKuAOUFbsoH8tPIOrB4JI=;
        b=ASgwXRfG3saKC9qjY5HSG3RViq4Nn2FSv324iTL3dQt24nHMWDX38faIWxzm/PIlgr
         2p/gmO4VGHAI4fvvPp5nKVy5q0TsZsnWPJ7FSBJ0EJFI5MEsvS6IGQDYWftIyk2DssDr
         9ovueM+DeiqyuNUU8j0QNEt7CJEdYcwDHa56aN91iOT047I3ZGCcwVWBiVLkVtwuAI5S
         joNJYJCJfS/ue/O/BJ4u4M/Odz40OsPRr8iYLbPEpaGmqIfZ2Xwd02Gx31z0StIGBFKS
         Um/hRZwjx2kIGgi8jX/1K9Lf4swzYl31MGV/TfmaAPED/STLQBGiuSjY5wTDuIyyz9E1
         qgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SB1Q8SSF7pRRlD0QHTZOwgGKuAOUFbsoH8tPIOrB4JI=;
        b=HE5XsiBSrK1oA9BOti1EMFNEhsPhBdBJVp5enoIbjTvam0Ps3mADjRiZ54F5EZgTw8
         6S3NyFl4WrLpJfqZb6svqemnFZu/DFCoQP0bbh4RYihA5muw9RPUHQ4YjbCqearHNx6G
         lzDuwXVckx3U7D1krSVtbLXjsEYlx3SmQ/GZCdPElb7SnW9a7asceCbFmUtvB1VsIBJ0
         eRvq9MnzdsN8MHV073kTu20DWdxpWy+gOAgBOwcbHl92tyvYvDGd+SgQl8Hnfw5QD1F+
         xOOdo8mSpI2rGFZ2kjLn2ysRzGLko+R6mzQSrwDygIzh3raqC/5I+8jnQg8PTRPT4omv
         Ju1Q==
X-Gm-Message-State: APjAAAV+0L5N9a9aP2u9aZWzLvTBc6Kce8WQxgp6sC6u/+zECgEjDkqK
        /DkeV2YMYdB+hMc4M2WgWUU=
X-Google-Smtp-Source: APXvYqzHCkoJkjcWRYDLIz70uz1diaDrmBBGNJwY0If61ebNMlpnwxjsCWqaHdg7/0CTgh/2BP0wHQ==
X-Received: by 2002:a62:3447:: with SMTP id b68mr44566146pfa.67.1560559807804;
        Fri, 14 Jun 2019 17:50:07 -0700 (PDT)
Received: from [172.27.227.153] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id p23sm3499652pjo.4.2019.06.14.17.50.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 17:50:07 -0700 (PDT)
Subject: Re: [PATCH net next 2/2] udp: Remove unused variable/function
 (exact_dif)
To:     Tim Beale <timbeale@catalyst.net.nz>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
References: <1560487287-198694-1-git-send-email-timbeale@catalyst.net.nz>
 <1560487287-198694-2-git-send-email-timbeale@catalyst.net.nz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33e1055d-2a33-59b8-9a44-277c79882f3e@gmail.com>
Date:   Fri, 14 Jun 2019 18:50:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1560487287-198694-2-git-send-email-timbeale@catalyst.net.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/19 10:41 PM, Tim Beale wrote:
> This was originally passed through to the VRF logic in compute_score().
> But that logic has now been replaced by udp_sk_bound_dev_eq() and so
> this code is no longer used or needed.
> 
> Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>
> ---
>  net/ipv4/udp.c | 12 ------------
>  net/ipv6/udp.c | 11 -----------
>  2 files changed, 23 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
