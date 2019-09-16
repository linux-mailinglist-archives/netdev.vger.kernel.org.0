Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A899B32BE
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 02:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfIPAFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 20:05:05 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:40595 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfIPAFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 20:05:05 -0400
Received: by mail-io1-f52.google.com with SMTP id h144so74614672iof.7
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 17:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kQxCNXvkhACNROtk5/epWSVtL4BM4aPIejGS7SZu0Cc=;
        b=od8QNwC7vAEu2fCuHWA1exP2GRaDg41ivC+qYQZQK6obm7n8+7jeOKR972ABnjaveM
         q4Fbjh2YT/N/KsJlQb+++cweSzg7Qed54icab3vIfkZB/D/XDe601iOs96XgRhge4D2S
         18tZvFx/vY0bQfGVngS5YWQLoiH0eqz1BwxYP5OaZZTPNvqzADjS3A4SONjwqGRLLW97
         sg9nXqw7ixtgXyWFfjfcnKyIiZUI0L1Q8euIfDmGy0qx6f2isMDBZDPhWsIAzS6dB3DD
         tKCEh7UJ7qSF0t9NCLQtRhZSBzFB7XQ38O22DybRj/oCSM3T/uadf95Xz9xxV4Fscp/t
         Xi/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kQxCNXvkhACNROtk5/epWSVtL4BM4aPIejGS7SZu0Cc=;
        b=BlngDi/WKKTAMeKOXEeIAc8kaR1XtNkvD/nla9pq153v5KPajTLUa1TpYZYf9v+mas
         0AT8qQVSm74QOi+Xm6JmXjw4o6zibzQzN7xLw79Fw++01JmOLfOC6JHbqPhqK/nRxcjs
         GKwcQYKxNwt9Jq/rO3OLpJcXM3ob/oxjfwS1cg6EEWkHd412xkVez9k0m7xd7USnyTA4
         l11sHwanmfXaQwg2Y6D2Va8gfG8TaePsNiXf/y+grJfLxi6CrqdES2A/ADkLrJrMzWQ+
         tzT4nDAPw8VEBG5wGce/6b18NUQ0r8vMeaHKpBxATMzgfGp+CGTasIJkxdA2z+rtgm1F
         eORw==
X-Gm-Message-State: APjAAAW5BmFiD+dFRXGVe4uq618yuuDdFZvdsUTWC8juO2MNev+epXmN
        NXgb5a95elQd22o0z1DUC8k=
X-Google-Smtp-Source: APXvYqwOvATJV1eM22jm0FHNN3l+y6EkP3chqt3rUTg8RE63/jaUgoiPQiZoR4KzCHZhvslcXduXkg==
X-Received: by 2002:a02:3094:: with SMTP id q142mr12067966jaq.135.1568592304934;
        Sun, 15 Sep 2019 17:05:04 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:b012:b2bf:173a:b7c3? ([2601:282:800:fd80:b012:b2bf:173a:b7c3])
        by smtp.googlemail.com with ESMTPSA id y17sm28016208ioa.52.2019.09.15.17.05.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 17:05:04 -0700 (PDT)
Subject: Re: rt_uses_gateway was removed?
To:     Julian Anastasov <ja@ssi.bg>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>
References: <alpine.LFD.2.21.1909151104060.2546@ja.home.ssi.bg>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ba2cb731-1be1-d63a-1458-a2193a99d97a@gmail.com>
Date:   Sun, 15 Sep 2019 18:05:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.21.1909151104060.2546@ja.home.ssi.bg>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/19 3:08 AM, Julian Anastasov wrote:
> 	Now I see commit 1550c171935d wrongly changes that to
> "If rt_gw_family is set it implies rt_uses_gateway.".
> As result, we set rt_gw_family while rt_uses_gateway was 0
> for above cases. Think about it in this way: there should be
> a reason why we used rt_uses_gateway flag instead a simple
> "rt_gateway != 0" check, right?
> 
> 	Replacing rt->rt_gateway checks with rt_gw_family
> checks is right but rt_uses_gateway checks should be put
> back because they indicates the route has more hops to
> target.
> 
> 	As the problem is related to some FNHW and non-cached
> routes, redirects, etc the easiest way to see the problem is with
> 'ip route get LOCAL_IP oif eth0' where extra 'via GW' line is
> shown.

Hi Julian:

Thanks for the detailed report. Yes, I misunderstood the subtle point of
rt_uses_gateway. I will look at a fix this week.

David
