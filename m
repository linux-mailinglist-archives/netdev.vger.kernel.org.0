Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD283D9BE9
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhG2CpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhG2CpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 22:45:03 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0FFC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 19:44:59 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 68-20020a9d0f4a0000b02904b1f1d7c5f4so4288938ott.9
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 19:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gw0vrxfm7AKhOFFHOmE/VmqZdaZ3JyA/vCiPkT/hOyE=;
        b=XnGDNHBogw0ASoRy2zSdExuOCKjKmUUzMfX2pugcjRwCfJ37nQe0aFuCtm88lAle8Q
         xHpITL8Dez5CRPOhLnB2OhvQ1PxhsOyy4j2aIPZrLbklnIM6bwQeD6m1exQtFCLDJL19
         CTmtAOJLyEsOALuady+RxBr0efAptlZKAqtcp6lbCBsUmjX7unb6qy03KakI70ZZPf9u
         CKMQKTLDop7qmH3jyrHy3sJ3UXC9kc2Rexxx3xOUb72/ieN3WmGeipFRf/begsqME5hY
         WH+hITKV+UPDvJV2ghgkbJr60sOFASPRpFxM0Wik6TK1OZuHfL/W6rgPB4Oz90pzOoge
         cQ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gw0vrxfm7AKhOFFHOmE/VmqZdaZ3JyA/vCiPkT/hOyE=;
        b=f2AcLeiyhwNZdcuuQIiF6zhYfXi1sgJ/Ee297i9eX88RU1cc1X8ePYWLDBbS1LjuqR
         vKnckO/cDzW4wUJJ5C+gfQ+sWf4W4cGjzX26YRp2oZ4m54+00yVDNikNSUPqPtvEehUy
         LgMb8NTjGRPivGjSY9tTUKXZpUtsYEjdmwbwfJ+w6p3C+Evwdab3CrnouqOSvjlUC5DO
         hDF1RgZRE1oFTkfO6KL5yM+itSRtUKILwsr5gcpIKjJMmx2Z2hlizxfu+6XEO2TGPDhK
         7jSQ9iJ2SUbtqBCB7o0ZFL25+88aaudstSSVmZt2XPbPwe7ItBdCejK8ddLLowJDshQF
         qorQ==
X-Gm-Message-State: AOAM530SLU6c+ZHQEuxwdX5v6Weka63NWyixPDMhxdA1mUwEtiYzj320
        sAI99v+Lj/UEFO4X0Ra78cg=
X-Google-Smtp-Source: ABdhPJzpk6Kzn/6Aa2lLB4o0tYMiYDhC2iDV3jR67WW4eXHfdpDYT3+l5IQHyH6WopM24fUTT7nL9w==
X-Received: by 2002:a05:6830:1683:: with SMTP id k3mr1995987otr.140.1627526698780;
        Wed, 28 Jul 2021 19:44:58 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id h15sm280954oov.41.2021.07.28.19.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 19:44:58 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 2/3] New IOAM6 encap type for routes
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210724172108.26524-1-justin.iurman@uliege.be>
 <20210724172108.26524-3-justin.iurman@uliege.be>
 <1187403794.27040801.1627393327692.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <81516751-ece9-2d29-023b-b0fba34eb0fe@gmail.com>
Date:   Wed, 28 Jul 2021 20:44:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1187403794.27040801.1627393327692.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 7:42 AM, Justin Iurman wrote:
>> +	trace = RTA_DATA(tb[IOAM6_IPTUNNEL_TRACE]);
>> +
>> +	print_hex(PRINT_ANY, "type", "type %#06x ", ntohl(trace->type_be32) >> 8);
> Uh oh... Should be %#08x instead, sorry for that. Should I submit a v3 to reflect it?
> 
>> +	print_uint(PRINT_ANY, "ns", "ns %u ", ntohs(trace->namespace_id));
>> +	print_uint(PRINT_ANY, "size", "size %u ", trace->remlen * 4);
>> +}
>> +

roll it into v3.

(also, please chop unrelated content in the reply; it is easy to miss
that one line comment scrolling the long message)
