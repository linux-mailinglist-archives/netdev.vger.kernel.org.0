Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B191264D37
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgIJSia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgIJSfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:35:37 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349BDC061573;
        Thu, 10 Sep 2020 11:35:37 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id u20so6663317ilk.6;
        Thu, 10 Sep 2020 11:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MZ2iDnTbyrlXItDSn80aeklI/xS62ZtYvWCMj64vOs4=;
        b=meC0VBgmuKRrGPzb8/z+FzMRdE6MjLwccji+DXA2jf7TnUmsEG1iQCe1CVuWXjxDG3
         GhFy7JFKL4lJYeaQ81e5aiUZnqhI0/64fxCmpDAnjU2apUIlFNc9ll9m+/XTxywCqQwr
         NYbZQVa2ICZVPjZwNv9ue8oj3pRA6XhzKzuw8j08FKKgphPACSdgJcocQXE/uzCN0zWQ
         apffPiBGhO2xdz0zWBAGysGOfPrcIEsLbus7gVMKw7i0yR+HwqjYvEWFYa7NCx1+cEmz
         1CzGYg/GWr8nRKrM6vUR/g/mgqdq2IPpVWZySEc7kOo6B5RnYIivkNEHrDylLeUlHFXR
         iBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZ2iDnTbyrlXItDSn80aeklI/xS62ZtYvWCMj64vOs4=;
        b=g0OSpu9jcd2oXuOSrK8AdXsPQE6+p6AHRVcoF+fe7KQA8rkN2IFFwkhETqBTIbXyan
         OLspsAL06lYVxjvIWfEKLKeXLHfJ5iUR4fGCySOzZIgKMDOWbOxk7Y4g5XXp6502G4Ms
         tTQsNYOFq15pfshpNIYkU1bghGExTxODgI1EsbA3prD0vcIzUiW+lYuDDVI5p0Qe5PHA
         aAFYFdhQ3SqMwmvBguK06B/0TLH58w0LHwbL6eUDfDSmGcdRADuruOVwAHCUJLzmF5pa
         KsqYL5v2pOL5RcVJpZEjIGqji/uPdQX6OccPT0kvCoEGRvOUNj7ao0Ht8rPCMtcWi63Z
         WC+g==
X-Gm-Message-State: AOAM530tG84CT1sD81nsq2FJf894egQ3t/woHlBwJPTUwtwF4TU4mZLz
        hy0vbvMk9GEBs4puc6Wo54Y=
X-Google-Smtp-Source: ABdhPJz2sQeqQXzg38W24a0rNF+ZVeuE4MXNImqWkGSwdYXQWfG9xQlWvrKwk5rU7jPBaInMWwiNZg==
X-Received: by 2002:a92:58cd:: with SMTP id z74mr9447040ilf.224.1599762936541;
        Thu, 10 Sep 2020 11:35:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:5dc7:bd14:9e78:3773])
        by smtp.googlemail.com with ESMTPSA id z26sm3568100ilf.60.2020.09.10.11.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 11:35:35 -0700 (PDT)
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20200907082724.1721685-3-liuhangbin@gmail.com>
 <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
 <20200910023506.GT2531@dhcp-12-153.nay.redhat.com>
 <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
 <CAADnVQ+CooPL7Zu4Y-AJZajb47QwNZJU_rH7A3GSbV8JgA4AcQ@mail.gmail.com>
 <87o8mearu5.fsf@toke.dk> <20200910195014.13ff24e4@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <47566856-75e2-8f2b-4347-f03a7cb5493b@gmail.com>
Date:   Thu, 10 Sep 2020 12:35:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910195014.13ff24e4@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/20 11:50 AM, Jesper Dangaard Brouer wrote:
> Maybe we should change the devmap-prog approach, and run this on the
> xdp_frame's (in bq_xmit_all() to be precise) .  Hangbin's patchset
> clearly shows that we need this "layer" between running the xdp_prog and
> the devmap-prog. 

I would prefer to leave it in dev_map_enqueue.

The main premise at the moment is that the program attached to the
DEVMAP entry is an ACL specific to that dev. If the program is going to
drop the packet, then no sense queueing it.

I also expect a follow on feature will be useful to allow the DEVMAP
program to do another REDIRECT (e.g., potentially after modifying). It
is not handled at the moment as it needs thought - e.g., limiting the
number of iterative redirects. If such a feature does happen, then no
sense queueing it to the current device.
