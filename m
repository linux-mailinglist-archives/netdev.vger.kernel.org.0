Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A639A127F81
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLTPjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:39:37 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38466 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfLTPjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:39:37 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so9859696wrh.5
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LYMGOZ9IcnpN2Ty/nxAY0xge4LlrabJ7ZcXq1xwJ7/Q=;
        b=l9grPN7I3JDS7IjPspt+wRYqSsfF7ED6LWviwWdpq7sEX4iUJHC7rYgs77KyMmmMoO
         kdG7ZDuYEUbYISI855g0LkVJZBz7tJyDzrNnt0m7uAjNFJtPuhzrOLX6fmM3kt7Kq1p9
         bi3N+5mvVTjR4EBiGQS9RFOXFJFQFZWhfg3n5jxSFKWg/A85fqBVCxNve3J5G8yEQpHj
         Z8yXPjFfaWUJb9l+gRucu7ZAs5xQZbzo+77U3P9ls7AB5Y3BnJ7UAuvPRwSTi2/W54yo
         mamYswqv4ICMDP9EvJfJC8RDg/4ay1VYrgE97Nb7j9F5Jm/CRjjrRpjNx/1I8qkUGe2b
         Kn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LYMGOZ9IcnpN2Ty/nxAY0xge4LlrabJ7ZcXq1xwJ7/Q=;
        b=TG1+nRt+eF8jbKmqlwHMkfCe1mn4bta3eOv1JMicaKfhaNWaCTxd7/GvK4BIgMhuWg
         U9o/JiKb+flhWIiwBKXsdgLtXGV+ztR8njJB8ZkmFEw4ivXgSJCwYxbA71NNf5kCY1H3
         Jl46zgGef36kYBmj/fZC62ZQ1UaTXlA1dJdbSKyhtsmme9W/JBrl74g7K6fQ/agfennJ
         2rm2wKeHxi2yVUaXp7WkXHYmcW0brDKwtiish/j4NdoT4Bq5h+jf5cR7JX7d76JxxXQA
         MVWpA8BvBXFnzYJkbCYf5ESvkP4fBvLNGETS87A7OKrHlrpWRt5C83rPPDiEKe7eeeuM
         iw7A==
X-Gm-Message-State: APjAAAVcw6L7vCkJ5iTkgNSaIyDkksixQou9caS5y26Qzze7/jnshNjs
        aLjtGicIURYSm2V2aSoF8Zk=
X-Google-Smtp-Source: APXvYqyc2BrZeHf1Koj4iiyM+2XLzFH1IBEG6pDzvFZxxbMjEOiw+5DoXVW6EmnFU20dWObu2Q1Otg==
X-Received: by 2002:adf:f2d0:: with SMTP id d16mr15410946wrp.110.1576856375630;
        Fri, 20 Dec 2019 07:39:35 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id p17sm10426738wmk.30.2019.12.20.07.39.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:39:35 -0800 (PST)
Subject: Re: [PATCH net-next v5 03/11] tcp: Define IPPROTO_MPTCP
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-4-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <69535a97-c505-235d-923c-266e7b3806b3@gmail.com>
Date:   Fri, 20 Dec 2019 07:39:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-4-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> To open a MPTCP socket with socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP),
> IPPROTO_MPTCP needs a value that differs from IPPROTO_TCP. The existing
> IPPROTO numbers mostly map directly to IANA-specified protocol numbers.
> MPTCP does not have a protocol number allocated because MPTCP packets
> use the TCP protocol number. Use private number not used OTA.
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>


