Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86613F3484
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfKGQS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:18:56 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:32962 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKGQS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:18:56 -0500
Received: by mail-il1-f194.google.com with SMTP id m5so2343236ilq.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bzYEK43x7D4/zvYsievbRXF50knVwYjKS7ntWTPBVms=;
        b=TjNFbNcInUNpoVo+gocv1TPgReCrGFLF6xpG7gFQsG9wPo4bgN02oFtGS2ANKV6KG3
         DIy15dn5zHfrxZvRqrvG05rxkIuhffZLOkIwkeS7lL1cASCeRMWThn2v9P8tkFPi/FDE
         8ghYax+nJJ6uE41IIfWidH9Uv5B7Etmte7ucAaYrDv1dnDl3HOe3IzIT1qWqJ6R1zcyH
         0lsJrHclA3VHpA60RrmLx0Ey+Wra9SbnnxiKxPq90FY8oRSdkpOAAAciR8u0H6yGe6QV
         TBQLJ1iR7w/EiIzmBCIrqvr7MG3kRXkZWBI7QkdYfdo5mt0MI/hwHTrONaoh9X+KDMYP
         0FZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bzYEK43x7D4/zvYsievbRXF50knVwYjKS7ntWTPBVms=;
        b=SatId57bKPBExAwH3tkKjd+epDgyf7eskz5MY/WfWW8E9rWc9lcSjkKrSuNSi59vjJ
         08EM3qR07lJW/YJiG7YOJXkiINc6I9pE0jdjBgQqRo474p6UikOq22BISu0o3vivyjxx
         Tfg6l+uyPQG9JE2fCnhMHH9Dnsa9dCXiNNzhkIE/aXjFSVDnxnrOveJHWvbGoHCk3xJt
         eyj45gMPx5f6KOTeP4ER3L5tSKsvpnAXsjouCfGpckoajldpYlNZBuHlEZryyPN/9yNR
         MyNOePpnzaL0t+u/LnlvDeUkUzUty9HmhaXhuxde9S5GSkprNkKIYbjtMSzxfqgKR3iF
         eeLQ==
X-Gm-Message-State: APjAAAWv9kBCwVwqSO5qQvPe4z3giRcPf+5LmvrzciXkO7vGA10sCOcm
        2UJgZB2FgTMlHMub+r8w/y0uHQFh
X-Google-Smtp-Source: APXvYqyAD+QhUZmNVRi8ULWVEr0iGQy8yeckng5rGMFC90PcqqB9ECAJEjIhZv4v8asERLNxYW9JoA==
X-Received: by 2002:a92:c888:: with SMTP id w8mr5268798ilo.153.1573143534727;
        Thu, 07 Nov 2019 08:18:54 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:48b9:89c9:cd6f:19d4])
        by smtp.googlemail.com with ESMTPSA id s125sm210842ios.18.2019.11.07.08.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 08:18:53 -0800 (PST)
Subject: Re: [PATCH net-next 0/5] lwtunnel: add ip and ip6 options setting and
 dumping
To:     Xin Long <lucien.xin@gmail.com>, David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        William Tu <u9012063@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
 <20191106.211459.329583246222911896.davem@davemloft.net>
 <CADvbK_ePx7F62BR43UAFF5dmwHKJdkU6Tth06t5iirsH9_XgLg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c89c4f99-d37f-17c8-07e6-ee04351c8c36@gmail.com>
Date:   Thu, 7 Nov 2019 09:18:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CADvbK_ePx7F62BR43UAFF5dmwHKJdkU6Tth06t5iirsH9_XgLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 3:50 AM, Xin Long wrote:
> Now think about it again, nla_parse_nested() should always be used on
> new options, should I post a fix for it? since no code to access this
> from userspace yet.

please do. All new options should use strict parsing from the beginning.
And you should be able to set LWTUNNEL_IP_OPT_GENEVE_UNSPEC to
.strict_start_type = LWTUNNEL_IP_OPT_GENEVE_UNSPEC + 1 in the policy so
that new command using new option on an old kernel throws an error.
