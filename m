Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE02A4C95
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgKCRTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgKCRTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:19:06 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A402C0613D1;
        Tue,  3 Nov 2020 09:19:06 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id x7so16831301ili.5;
        Tue, 03 Nov 2020 09:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z2/zn2+pKQjtLu+/4cLIEyKyFw0qPm880nSte7A3OGw=;
        b=BRCF/t7g/0IQFuAyjBZGk9vik739T5O8CA9kcGcI99UHPju9NG0P4unuM15wVsDiea
         pi3N0sF4NGcQ54VPr7nHh1C4FzVoCHpm+L0rNKfJJ5HSuZan6l6fLbgfLPDLD80b/1UF
         GKe2pImXx+OLHMyFhpN91WqLbAahz7J8dXE43Xv9MgZnnJX/7MLyjTUSBWdEBovZ8xRD
         yDVPPaBwbwSBVtfqDnjU9mVq5nrOKRa0/ni5AG43dLXM+GNHhsODsgic2XdKzSeBY+pd
         SA5Yf/w6e1vTIt6/X5G/0tCHZ0RYocan3Zi65JdzQq9Me/TFcRVwnLycK+2QtSQ6A0NJ
         TEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z2/zn2+pKQjtLu+/4cLIEyKyFw0qPm880nSte7A3OGw=;
        b=Q37BVwLuiUMkIk8iIzn9aNHGUcYCsDx64KzPs2mcotl/ZWe878OsXnfTo5+a+kY4Da
         /EgEideYa7mtzQrpi70q5aDpHFyGKu3WnTmBhx86eQW+DoIkE31gGK/sq04/rnlpCObH
         ZxzbiGEeM9DfX6+mYR/U6/Ygtzps6BpObKW8uE/GNZtmrFlpq0JCN11B72hbt6v+uExT
         XmrCYwLQrI8X80mIYMLvyfibck7GTiFNFlzZwixb+iJpvSynqpOopwGM6TIY+7/TbkAw
         1thIkqK9bGZ9LuuiMaOMiwBu45c/jv7CfxS/5gJ78OxyaME6VeZdhDOvHGK93LEtuD39
         YnuQ==
X-Gm-Message-State: AOAM530Ezidlxa/RLyhkdR2Y85ZXY/5LqqBwvDhl0AoLEUqHgdBXhZ/n
        tFl/V6xIAXdLTPYl3jYZ/Rc=
X-Google-Smtp-Source: ABdhPJyckSQKtQzfPVK6qw6ixlM5KZMA98JSfC8O8hj7y0YkO+miCnWmLpXVDsd0osh/GeUJLgvJbw==
X-Received: by 2002:a05:6e02:c12:: with SMTP id d18mr14706221ile.136.1604423945796;
        Tue, 03 Nov 2020 09:19:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:def:1f9b:2059:ffac])
        by smtp.googlemail.com with ESMTPSA id s127sm13380320ilc.66.2020.11.03.09.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 09:19:05 -0800 (PST)
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
 <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
 <20201103054854.GH2408@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <92b16ab9-d2cf-53ed-0681-ac482c4b68f5@gmail.com>
Date:   Tue, 3 Nov 2020 10:19:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201103054854.GH2408@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/20 10:48 PM, Hangbin Liu wrote:
> 
> The iproute2_* functions need access static struct bpf_elf_ctx __ctx;
> We need move the struct bpf_elf_ctx to another header file if add the
> iproute2_* functions to compat file. Do you still want this?
> 

ok, leave it in legacy for now.
