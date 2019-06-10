Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8CF3BB03
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388136AbfFJRd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:33:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39806 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387492AbfFJRd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:33:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so5705921pfe.6
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 10:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kEu0fQcc+q+s5Y+OyoTv7bN6fh0Amvo7eADC2wJffKI=;
        b=pzJxlFfpIQDTqwPv1fAB7F80OwVFh7TJg0IX7tHjlIY/thwA23zV/LJNlTt6w3M32j
         dm56hP5HlmfWlAbpeKBem7+DQ22oafLFK6a4U8xEeruHyfmJgMgUA87/hxQWVtCR4iZr
         QLV1AmP6ZLgUjm4SNGuuH90krZl54xho3BlwTT5N2UwubCao+wsy6DDwZ1uSYKk0yAwK
         ClwHQe4fBew8fQCswuwWazECXGuPpmSjU4oBVSUl/Qs25y2n5c2OV8BbUDYFhjtrpYuI
         SGQhpxogOV7u25Gbsi79ngd5WkCITsawguYJ5LmMxKppYN+XEyp4EulXLVecycDmqj5P
         Sj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kEu0fQcc+q+s5Y+OyoTv7bN6fh0Amvo7eADC2wJffKI=;
        b=PtWEReIxKZnBY1FQg8Vfsk9Ok5kxHp7LCUT4aPb15nZInaFOhFDNWQxJWoe2VtBQ6d
         oYnqYXurUrkzfq16GhIgLzwbOUmpY3BLABfZOUfelvNnyIYqysQ84ajtTxNzLpCxzNcz
         nfKLhrHGhPB0i3rJJq1e9UIP/EEHzn0zZtowqDm8YozSbz8T0oOSeQycspUB622k/GnS
         m8CS5m/GeU4c4CTQMXiXOkVtqliWVr0RKS5OLNRhWdIS01KfZiQAkCpp6ewa9LuqW5OQ
         t8SyBOH3rn5fqC5P8GYIHGLWXfnhwVThmgzTrMNjmWUSbKXy9+HphCb2sYZwKbyx+If8
         zSUQ==
X-Gm-Message-State: APjAAAU+AZJvxkmrnvUZw6Vy6r7+cIKu2l5wuvh6+2y0zV8mGoMF2oZg
        qXw5xhc6VXJxGBoRNQXbmRBXngmUmkA=
X-Google-Smtp-Source: APXvYqwfw2lXfrtlB8yQz5DqQa4IaGj4FWBsuwIuW4uCgkqorgOqU/KQl51QOxF3yJXLpgW084GqXg==
X-Received: by 2002:a17:90a:db08:: with SMTP id g8mr21709258pjv.39.1560188007406;
        Mon, 10 Jun 2019 10:33:27 -0700 (PDT)
Received: from [172.27.227.182] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id a25sm11966199pfo.112.2019.06.10.10.33.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 10:33:26 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] tc: add support for action act_ctinfo
To:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, toke@redhat.com
References: <20190603135219.180df8e6@hermes.lan>
 <20190604135208.94432-1-ldir@darbyshire-bryant.me.uk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0d3ae9d1-ec38-22b8-e7a2-fa832f305e90@gmail.com>
Date:   Mon, 10 Jun 2019 11:33:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190604135208.94432-1-ldir@darbyshire-bryant.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 7:52 AM, Kevin Darbyshire-Bryant wrote:
> ctinfo is a tc action restoring data stored in conntrack marks to
> various fields.  At present it has two independent modes of operation,
> restoration of DSCP into IPv4/v6 diffserv and restoration of conntrack
> marks into packet skb marks.
> 
> It understands a number of parameters specific to this action in
> additional to the usual action syntax.  Each operating mode is
> independent of the other so all options are optional, however not
> specifying at least one mode is a bit pointless.
> 
> Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE]
> 		  [CONTROL] [index <INDEX>]
> 
> DSCP mode
> 
> dscp enables copying of a DSCP stored in the conntrack mark into the
> ipv4/v6 diffserv field.  The mask is a 32bit field and specifies where
> in the conntrack mark the DSCP value is located.  It must be 6
> contiguous bits long. eg. 0xfc000000 would restore the DSCP from the
> upper 6 bits of the conntrack mark.
> 
> The DSCP copying may be optionally controlled by a statemask.  The
> statemask is a 32bit field, usually with a single bit set and must not
> overlap the dscp mask.  The DSCP restore operation will only take place
> if the corresponding bit/s in conntrack mark ANDed with the statemask
> yield a non zero result.
> 
> eg. dscp 0xfc000000 0x01000000 would retrieve the DSCP from the top 6
> bits, whilst using bit 25 as a flag to do so.  Bit 26 is unused in this
> example.
> 
> CPMARK mode
> 
> cpmark enables copying of the conntrack mark to the packet skb mark.  In
> this mode it is completely equivalent to the existing act_connmark
> action.  Additional functionality is provided by the optional mask
> parameter, whereby the stored conntrack mark is logically ANDed with the
> cpmark mask before being stored into skb mark.  This allows shared usage
> of the conntrack mark between applications.
> 
> eg. cpmark 0x00ffffff would restore only the lower 24 bits of the
> conntrack mark, thus may be useful in the event that the upper 8 bits
> are used by the DSCP function.
> 
> Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE]
> 		  [CONTROL] [index <INDEX>]
> where :
> 	dscp MASK is the bitmask to restore DSCP
> 	     STATEMASK is the bitmask to determine conditional restoring
> 	cpmark MASK mask applied to restored packet mark
> 	ZONE is the conntrack zone
> 	CONTROL := reclassify | pipe | drop | continue | ok |
> 		   goto chain <CHAIN_INDEX>
> 
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> v2 - added a man page which has been a learning experience.
>      took opportunity to fix typos in commit message.
> 
>  include/uapi/linux/pkt_cls.h          |   1 +
>  include/uapi/linux/tc_act/tc_ctinfo.h |  34 ++++
>  man/man8/tc-ctinfo.8                  | 170 ++++++++++++++++
>  tc/Makefile                           |   1 +
>  tc/m_ctinfo.c                         | 268 ++++++++++++++++++++++++++
>  5 files changed, 474 insertions(+)
>  create mode 100644 include/uapi/linux/tc_act/tc_ctinfo.h
>  create mode 100644 man/man8/tc-ctinfo.8
>  create mode 100644 tc/m_ctinfo.c
> 

Dropped the uapi bits; those are applied separately and fixed a few
lines that had spaces at the end.

applied to iproute2-next. Thanks



