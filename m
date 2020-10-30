Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4E929FB9B
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgJ3Crv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgJ3Cru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:47:50 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D7CC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:47:50 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q25so6054985ioh.4
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 19:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UNcH9jv0qZ5GpWHGMTuSrfu1uLREKsrzFSOkV4OBgow=;
        b=diMUS0A0k6wIN2ZpMfSVi9q4kzvTqd8Me2TNz7wbLB3pRBbjeNhyF9L4bCM6EMzpi3
         32uXwRArhG2W27S1ecXrzm3gZr6hFNhZy3Q0CsAygNcNjMfOl3gqIKjbHrkE02o+y8dD
         aedXM6pxKsU33OcRufqtrz9O7lJ59v1W4YxhRq7ayS1saHQY5n3kiMornVBT4mLrPcly
         8S/E+mXDIDXGaQhcodOMdtiP+LCUaM6/02R4sf10GW0CuTXM+FmvC3CCFjn7xYg6h1Ou
         5Dbto4s2MFue0C3l4xYqoHoObJQ5T+FCCIg1d/cANVYcTf1lnp7kwGDmRsmQ03lKB+hU
         oIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UNcH9jv0qZ5GpWHGMTuSrfu1uLREKsrzFSOkV4OBgow=;
        b=PeNdd7svxheZEf0KgW7HfEJ88MgUT1x9pfz88C595DFMTp86C80Oqa2B5jZGfT6Ke+
         N+/9eI9uyJA1FaG4VFciAk32XMj5Rj68kcqU5EvOx5uq/Aq+BxGntsxVBIO6hf+UXXyu
         Xm+wEIn4qGgCCg4P3MsJftb1Brl86CUipmgn/R1fGkjmiiDuinE4CIYe488m7E6BaXNI
         4Xq0Dimpg/7Rpd2AG5uM1tBSBI4wmD4gN9iZEeNvq/or0IuTqaYlU2bNU94/+MZV5nq4
         GNVCeJ2a5bUUK4kuu2CqLpFRWeIMtjXFaStM49kKyvAeqTk1xP8F1agxPZ3x8+BKlElI
         Zhfg==
X-Gm-Message-State: AOAM530vGFpufAqEa0pcQIClKDhLqOdZoyInpCIOSn+2/fynblWSfrwL
        vbiXZNTf9HUsM9gV4Rg0mNkurvKRg2E=
X-Google-Smtp-Source: ABdhPJy3SRqFunVThouybDnQ7l4gUx+QLyd1i7XEl6saZ3LAdUvH4rsUKgmjHbatZh6BaffaYmgdew==
X-Received: by 2002:a6b:5f05:: with SMTP id t5mr282876iob.67.1604026069725;
        Thu, 29 Oct 2020 19:47:49 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:cc1b:c747:56c1:5265])
        by smtp.googlemail.com with ESMTPSA id s10sm4148487ilh.33.2020.10.29.19.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 19:47:49 -0700 (PDT)
Subject: Re: [PATCH iproute2] tc: add print options to fix json output
To:     "Sharma, Puneet" <pusharma@akamai.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201028183554.18078-1-pusharma@akamai.com>
 <20201029131718.39b87b03@hermes.local>
 <2B38A297-343E-4DD0-93E2-87F8B2AC1E26@akamai.com>
 <20201029161640.3a9c4da5@hermes.local>
 <F6349CB8-670F-4CE1-AFFB-A446D311EA42@akamai.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <278df9b9-e2f6-fe8a-e7d6-432b29a39697@gmail.com>
Date:   Thu, 29 Oct 2020 20:47:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <F6349CB8-670F-4CE1-AFFB-A446D311EA42@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/20 6:42 PM, Sharma, Puneet wrote:
> Because basic match is made of multiple keywords and parsed and handle differently
> example:
> 	$ tc filter add dev $eth_dev_name ingress priority 20000 protocol ipv4 basic match '(cmp(u8 at 9 layer network eq 6) or cmp(u8 at 9 layer network eq 17)) and ipset(sg-test-ipv4 src)' action pass
> 
> and if jsonw_string used then it will double-quote every string passed and
> 
> prints something like this:
> 	 "ematch": "("cmp(u8 at 9 layer 1 eq 6,")","OR "cmp(u8 at 9 layer 1 eq 17,")",") ","AND "ipset(sg-test-ipv4 src,")",
> 


I think you need to print that string to a temp buffer to collect the
complete expression and then just call print_string on it.
