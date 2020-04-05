Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9783B19EC8C
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgDEQ0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 12:26:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45914 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgDEQ0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 12:26:53 -0400
Received: by mail-io1-f67.google.com with SMTP id y14so13069199iol.12;
        Sun, 05 Apr 2020 09:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qzPKx60Pj8Uww/sN5UN+Yh108GxV30oLDYA5ZvLaw4o=;
        b=cr3eMjSy5xezMeWVo1yY3VaPnaWrbm+A+wVnPj1jut57vU9SQ/w/bsw+qcEyO9mHjO
         Nr+V0Jh6Ah82E3ywyTPOgivMIfo5cglSRgtpMCf5fiEPRYuk1qx0tC0ZZDcGPha0otez
         gDoa8bLYcjWkkVGsoGkREfxKTQWlvBzWij7rnILgnr+v5RBVvZoGO0i07EIEC2YYZRLa
         qcW5ubFyPU7IWnBMFocD6rzCqLvAUTq44t+fKX/NbMAKlPoCkceQb6JQTFCQLQ46BlXx
         asXkdNQTO/wRxuCyW/LUpZ5A8vMPspXrjaywn4LpQxLsSDja6ML7FFDKGwSitNI5ieVy
         F5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qzPKx60Pj8Uww/sN5UN+Yh108GxV30oLDYA5ZvLaw4o=;
        b=gnQzIAQSTFER/+WS5nASagEc7NPcTNaPoy09CPHzbPo7zS6G0gq9S/yBBAoDsnDZMq
         NH0XhhpF3vhwxRMXTAZpPR4PrEWMOYtTI8pURPmeLaEx46qgliDQMekFoN3qVIUF9xdy
         7cUscYpi/lMfiBLvkZJ5uqRBCZSmHxZQge9FGB01rdsr8tREf41Sfa9mjXQI36eXm/Xh
         oShHQzuIrvDxxB0HJ1NVmXmlHC8a5C9DyK/lXAU5HHh0J/Hj33Mx2k9KE5z1z19GNqT7
         68B3kKm1N/rKDGEn0IJ66G4ilxUoknwdPJr3U8+88GjFfy0haMoQhx7meLbgcGJ1e4vf
         0o9w==
X-Gm-Message-State: AGi0PubJEknlGBsqTk0f1czu+nk9eeIygJFB/q6j68x/Cjwn+H+SpX55
        xKS2Ehbfwrd/UP0kalcDMp2CCrKR
X-Google-Smtp-Source: APiQypK0Kl2pUml53VmbpXW499rDMSVgaOIPAVH7hN8HUhsemX6YY0kRWWRA2Lv8lGcn0/KvBnHy7w==
X-Received: by 2002:a6b:ee10:: with SMTP id i16mr15936272ioh.114.1586104011897;
        Sun, 05 Apr 2020 09:26:51 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:60e1:98ca:913:d555? ([2601:282:803:7700:60e1:98ca:913:d555])
        by smtp.googlemail.com with ESMTPSA id 10sm5087601ilb.45.2020.04.05.09.26.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 09:26:51 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 0/8] bpf_link observability APIs
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200404000948.3980903-1-andriin@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0849eba7-18c3-e5d5-f4d6-b76dcb882906@gmail.com>
Date:   Sun, 5 Apr 2020 10:26:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200404000948.3980903-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/20 6:09 PM, Andrii Nakryiko wrote:
> This patch series adds various observability APIs to bpf_link:
>   - each bpf_link now gets ID, similar to bpf_map and bpf_prog, by which
>     user-space can iterate over all existing bpf_links and create limited FD
>     from ID;
>   - allows to get extra object information with bpf_link general and
>     type-specific information;
>   - makes LINK_UPDATE operation allowed only for writable bpf_links and allows
>     to pin bpf_link as read-only file;
>   - implements `bpf link show` command which lists all active bpf_links in the
>     system;
>   - implements `bpf link pin` allowing to pin bpf_link by ID or from other
>     pinned path.
> 
> This RFC series is missing selftests and only limited amount of manual testing
> was performed. But kernel implementation is hopefully in a good shape and
> won't change much (unless some big issues are identified with the current
> approach). It would be great to get feedback on approach and implementation,
> before I invest more time in writing tests.
> 

The word 'ownership' was used over and over in describing the benefits
of bpf_link meaning a process owns a program at a specific attach point.
How does this set allow me to discover the pid of the process
controlling a specific bpf_link?
