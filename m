Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499A218F996
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCWQXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:23:19 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:36663 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgCWQXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 12:23:19 -0400
Received: by mail-qv1-f67.google.com with SMTP id z13so7503317qvw.3
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 09:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=83wTzwPdsIpcTAKeXt5oH4H5u4ukd+PG3JtpSwuzVhI=;
        b=anyYSfOVILqSsoEOu8fZehocnY8IZ8yLnCNtvLbNW/0gzxI1XW59lIJ38TBbM6ba8N
         umxsmYYfonPknQQFsaTkPDPVdmhZDBuXqksedA9V5TK33vQnGSZ0+JON783iqwN2oAeA
         24Tdd1+mDgJ9oyZvA7zc1vA2EuqNFsVSiyamprdioggRXKUhiv+fSbuluKYi7RmBd0Gi
         tFiRUTKt1xbycyJns1l/87hRMyBzecIVucdWbO9VexYTy5+uMf2KbGypNhOiguPpktE1
         KLOHB2DKZ1W+lZfCY+sUWHYqMfbtgcygQ24sBsiuGgKqokEZr1SsRP0Q3SAnMyvoJWWb
         B+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=83wTzwPdsIpcTAKeXt5oH4H5u4ukd+PG3JtpSwuzVhI=;
        b=T13RmB7cqz5XrwKrlEIjCe6zpEonPQtXTj8km2gdFSIZ3BAANw6xyuPb+1yppbPdrW
         HUIYPHJb8mA/ixmPy/1fUJUWBfYSLcWxeS7dUrtBTx5c/Xv18m6vNmQI+1eVwfTBy255
         hqCYOZkEaWdJPAAkshzAEyn0tUX5eZJVeFax3CGHA8tySw1nT5ZFnjJzgvuW6OfDvy8l
         bWLEdJcsub4GSNwM4KkwVVMhey+1/5GB2dPNVvpVw7H5FcMqifWtgPPWjyKgHpqAwAbe
         NyELbqJz34SL9eDK783Bs8Uyn5oNx/yCm77w+/6PjHj6d4qy0hxcsmp0ReQy4Zsh1jXQ
         bLHQ==
X-Gm-Message-State: ANhLgQ19RJkcWfTXM9/MVIB8q21N7O772WocpKw0TQaTaLYkdLEpC4lT
        L9Tu4nW0vhjFOjKDVM47hehDWcbQ
X-Google-Smtp-Source: ADFU+vvBvdog/9ahg1fbzuLYtL0QG96Z//u3uXsnhVJuw/knscb/QpdjJHb7KifN1D9Ob7LLb4W4gQ==
X-Received: by 2002:a0c:a998:: with SMTP id a24mr21248399qvb.141.1584980597470;
        Mon, 23 Mar 2020 09:23:17 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:ec36:91c:efc1:e971? ([2601:282:803:7700:ec36:91c:efc1:e971])
        by smtp.googlemail.com with ESMTPSA id d19sm11487489qkc.14.2020.03.23.09.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 09:23:16 -0700 (PDT)
Subject: Re: VRF: All router multicast entry(FF02:2) not added to VRF Dev but
 added on VLAN Dev
To:     Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     netdev@vger.kernel.org
References: <CADiZnkQiZSEpk5CWtNWk35+Cg=zHfpSpTe3kAhuvKvVrGjFCpw@mail.gmail.com>
 <ea4a8fbe-70c9-ead6-62b0-0be90959ccd8@gmail.com>
 <CADiZnkQusFraECtHx_PYf_NDM9fn29dZkFV1-US5TL+3J5-wSg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e43259f6-fa2a-f181-da6d-9a338ee4d0cf@gmail.com>
Date:   Mon, 23 Mar 2020 10:23:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CADiZnkQusFraECtHx_PYf_NDM9fn29dZkFV1-US5TL+3J5-wSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/20 12:00 AM, Sukumar Gopalakrishnan wrote:
> As per the kernel version 4.14.170, skb->dev is changing to vrf_dev even
> if need_strict is TRUE except few types of ndisc packets..
> 
> static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
>                                    struct sk_buff *skb)
> {
>         int orig_iif = skb->skb_iif;
>         bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
>         bool is_ndisc = ipv6_ndisc_frame(skb);
> 
>         /* loopback, multicast & non-ND link-local traffic; do not push
> through
>          * packet taps again. Reset pkt_type for upper layers to process skb
>          */
>         if (skb->pkt_type == PACKET_LOOPBACK || (need_strict &&
> !is_ndisc)) {
>                 skb->dev = vrf_dev;
>                 skb->skb_iif = vrf_dev->ifindex;
>                 IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
>                 if (skb->pkt_type == PACKET_LOOPBACK)
>                         skb->pkt_type = PACKET_HOST;
>                 goto out;
>         }
> 

This 4.14 patch needs to be reverted:

commit 2271c9500434af2a26b2c9eadeb3c0b075409fb5
Author: Mike Manning <mmanning@vyatta.att-mail.com>
Date:   Wed Nov 7 15:36:07 2018 +0000

    vrf: mark skb for multicast or link-local as enslaved to VRF

    [ Upstream commit 6f12fa775530195a501fb090d092c637f32d0cc5 ]


The upstream commit should not have been backported.

Sasha: can you revert?
