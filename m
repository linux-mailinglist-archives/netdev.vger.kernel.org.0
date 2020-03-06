Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DF417B311
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 01:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgCFAoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 19:44:04 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:44844 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgCFAoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 19:44:03 -0500
Received: by mail-qv1-f68.google.com with SMTP id b13so194753qvt.11
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 16:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=imXsc6dkhEW+KR98DqcX+t/5GXe2FkFkhHgIfCRHVQA=;
        b=Wno0ZK8h3Td6ymMqOv+CeBNJ0hWFORsO/gBsSq1Kwp/rMwdWmP8jFrUD8GiTLGp5Eo
         zDlhWDbxCX7gUZhR5Q8pznytKg1EEh/ZElB2opk0HdB+ygdf0aq4en32l4VgQgNV4Lah
         55Y/afna9URRRGgEa4V+wyshMOB/NtltZx8LUA5Fhad5+DRTV7NlJp86cCy23ca+r11w
         WZNluefryleFQoXWLDrOOOzPbhXzbF7RzWiyT9WBn41hGS/4Gta4KVMkQ83/6IL2c5P0
         3qMIZvg6msgGTDOnLijQidcdofqbrFR28mUDYt9Crv2aXi5WM9ezxPzVLLER1RIhHuMA
         owbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=imXsc6dkhEW+KR98DqcX+t/5GXe2FkFkhHgIfCRHVQA=;
        b=N7jedrTYy5ujkyCXUNNIi6cnSnYpMliA9en1ul1bV4GoZCHOafI3fCcloqSF92JoDo
         0Y8DlmUvzjwS2Bfx093R1XX5HeVbL3/CDWynASo9bL4Vwy/XEZpA/+rRRW+kR0xnwlOX
         F+YPF/VM70ozuqRhYwilrPYLMIb5Wug/dvLvXe99y6qvIDYERMjBh2KAz8/bC6YQL06O
         NgmC83FAau/TISj/gKw0HMmXCwF0K7X1i5PeoF8TtC8c0hxzejv4NjndSESFLQiKFczw
         CojEkFow06Hpt46lCm4Ob/+M5lXIcip8hmAJEEhfMKE5ux94Gf7eCA8hsnkcs3P7mq7G
         RFVA==
X-Gm-Message-State: ANhLgQ3vO+tndH+16o1SysZVSHJ3MVuMXM3qndNrbgsk+c8UqnlEpmdq
        FUrmTmBQ/K4qmrtf3CuzrNo=
X-Google-Smtp-Source: ADFU+vu8KfqLgtVRE9DBza+jm2aDnBaPhLICkFREW4MIG9O8KFFPI/cUMOkEEM5dST/TZgInnEfFmA==
X-Received: by 2002:ad4:4d0c:: with SMTP id l12mr892494qvl.156.1583455441354;
        Thu, 05 Mar 2020 16:44:01 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:31:abf7:1857:4c39? ([2601:282:803:7700:31:abf7:1857:4c39])
        by smtp.googlemail.com with ESMTPSA id a27sm3693180qto.38.2020.03.05.16.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 16:44:00 -0800 (PST)
Subject: Re: [PATCH net-next iproute2 1/2] Update devlink kernel header
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com
References: <20200304040626.26320-1-parav@mellanox.com>
 <20200304040626.26320-2-parav@mellanox.com>
 <bfef88f7-c888-04b0-7d7d-dc1bb184d168@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3281568c-72d3-2c02-adc3-4e3008cdf4ec@gmail.com>
Date:   Thu, 5 Mar 2020 17:43:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <bfef88f7-c888-04b0-7d7d-dc1bb184d168@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20 5:42 PM, Jacob Keller wrote:
> This hunk doesn't seem relevant to the patch and isn't mentioned in the
> subject or description.

it was a sync of the header file. I drop those changes and do full uapi
sync for iproute2 and then apply patches.
