Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A1535062
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 21:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfFDTlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 15:41:24 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41708 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDTlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 15:41:23 -0400
Received: by mail-pl1-f196.google.com with SMTP id s24so8601093plr.8
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 12:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mAmcsZuYupzvuRQzMA/abgEymLpTDJKZLeBYEbJ1sok=;
        b=LaXnKdURyBWvWQBhUeQEpsfBt3JmJfoTYIsBxdWC2L7nxe3t/ubmxpO5qTfvPmP1od
         YzU09h1vuXgZ4SSYcpcSz1uIZRRFHnzAtGlCTqnX2DDRPUjDt9Kgv6CencTGSx6W0qKl
         iuv9Iwg/k3/pn5l7T2/luKzoemvl04aUd2pUj51dlN30gXt8q3wTRUDvFOd1lCoWNln8
         owiMNBauyM+HKctWmno5tOZd/wTnmxA1FdQdSomUJ+6RdojNlZxZQaBpFBIDTa++A4xW
         QIQq8m9GZ46pcrqonv4EIafBIt/gKGMTOGwcQqozdbreOEB9Ku3nR3wNN1ZZOCNXnXiM
         rCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mAmcsZuYupzvuRQzMA/abgEymLpTDJKZLeBYEbJ1sok=;
        b=hrY4noUoNRbJHVkmy8cp3L+wneGJQzP3gzRGy3EFdkzJb2zalJ0UCUWWN0Z+vOf9tQ
         cB4RbOcn4uA5wfMRR5XFxBOrZ2qwZHylXpOOAAyB/E35HS7oKF9FoLEVO26gwFabQEbs
         LkuyuIdO+Ak7z9RmkrWbCbyltLTg2mL+C+oUSLPj3soTZi+c+N6cGTFj3m7JPqEc4gYU
         yUDKS+Kp16g3Ps0cq07tGu3xI4iaPohRDg4ZlEglwg6LJIiPqZyoAFGBVclAJ7QvbbFy
         iTRe/f8a/ZnLtNyjBMAmCztrXSfl1A1LUFbX0+rFJvXXsMh0XNZ0ThjM/hVX1JwIe0vD
         BreA==
X-Gm-Message-State: APjAAAUV+AtaCOWlreDIuz2YKzwjVzYrRGd/OgrSdPE10ibyB92/wHjA
        XzPyoWN0jpLrnCwA8AzmPACXOmdkXDA=
X-Google-Smtp-Source: APXvYqzzkZr5BWDAh9CX0xVefcarMNWiZXPJ36iVqWJHlEL7YLdL3BxU9pb47rNbnLug9ppwMJIB1g==
X-Received: by 2002:a17:902:8210:: with SMTP id x16mr38263553pln.306.1559677283157;
        Tue, 04 Jun 2019 12:41:23 -0700 (PDT)
Received: from [172.20.52.202] ([2620:10d:c090:200::1:a068])
        by smtp.gmail.com with ESMTPSA id x1sm15780257pgq.13.2019.06.04.12.41.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 12:41:22 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Jiri Olsa" <jolsa@redhat.com>
Subject: Re: [PATCH net-next 2/2] devmap: Allow map lookups from eBPF
Date:   Tue, 04 Jun 2019 12:41:20 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <A5CA54A9-34A0-4583-84E8-0530BAEE215B@gmail.com>
In-Reply-To: <20190604183559.10db09d2@carbon>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
 <155966185078.9084.7775851923786129736.stgit@alrua-x1>
 <20190604183559.10db09d2@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4 Jun 2019, at 9:35, Jesper Dangaard Brouer wrote:

> On Tue, 04 Jun 2019 17:24:10 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> We don't currently allow lookups into a devmap from eBPF, because the map
>> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
>> modifiable from eBPF.
>>
>> However, being able to do lookups in devmaps is useful to know (e.g.)
>> whether forwarding to a specific interface is enabled. Currently, programs
>> work around this by keeping a shadow map of another type which indicates
>> whether a map index is valid.
>>
>> To allow lookups, simply copy the ifindex into a scratch variable and
>> return a pointer to this. If an eBPF program does modify it, this doesn't
>> matter since it will be overridden on the next lookup anyway. While this
>> does add a write to every lookup, the overhead of this is negligible
>> because the cache line is hot when both the write and the subsequent
>> read happens.
>
> When we choose the return value, here the ifindex, then this basically
> becomes UABI, right?
>
> Can we somehow use BTF to help us to make this extensible?
>
> As Toke mention in the cover letter, we really want to know if the
> chosen egress have actually enabled/allocated resources for XDP
> transmitting, but as we currently don't have in-kernel way to query
> thus (thus, we cannot expose such info).

Would it be better to add a helper like bpf_map_element_present(), which
just returns a boolean value indicating whether the entry is NULL or not?

This would solve this problem (and my xskmap problem).
-- 
Jonathan
