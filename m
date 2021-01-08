Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A142EF2E0
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbhAHNJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:09:44 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4559 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbhAHNJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 08:09:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff8596f0001>; Fri, 08 Jan 2021 05:09:03 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 8 Jan 2021 13:09:01
 +0000
References: <20210107071334.473916-1-roid@nvidia.com>
 <20210107082604.5bf57184@hermes.local>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2 v2 1/1] build: Fix link errors on some systems
In-Reply-To: <20210107082604.5bf57184@hermes.local>
Message-ID: <875z478tjq.fsf@nvidia.com>
Date:   Fri, 8 Jan 2021 14:08:57 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610111343; bh=FBw7jte3+cIU1B1TwTiFfME4Z2kAfDEpUbyWC0q7j2k=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Message-ID:
         Date:MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=SIGttND0NMFVLlLzN7w84U3MM6yjIRV7gTlgFhlFIOwoUU9xLRwsRtOXmIKIRffQb
         RDmFINg+ifsnyGPx7bq9aUs1kPj4pXXtPKWTCcEiF0RPjy+CiGU7wfPf20Zqe5pm12
         DpwNhec/aP0Q00ggC2gHACCfF45jhtn63HSR8OJQz9+2puognBrktVTxITd1hNU7SR
         8dZ0neQUsuhdINJ5HZZD/Deh/Lkv+ICZKP/d5YJaDlu1F8284vGu5RLt9QptSD9RZp
         1TaA7IyzK4IH55XC3WHt6dKXM9RfZVarVS1j7suwhwiLOWBnOCKnWAMyLIrWzJ73RB
         AkT+Afaki/3AQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Thu,  7 Jan 2021 09:13:34 +0200
> Roi Dayan <roid@nvidia.com> wrote:
>
>> +#define _IS_JSON_CONTEXT(type) ((type & PRINT_JSON || type & PRINT_ANY) && is_json_context())
>> +#define _IS_FP_CONTEXT(type) (!is_json_context() && (type & PRINT_FP || type & PRINT_ANY))
>
> You could fold the comparisons? and why are the two options doing comparison in different order?
>
> #define _IS_JSON_CONTEXT(type) (is_json_context() && (type & (PRINT_JSON | PRINT_ANY))
> #define _IS_FP_CONTEXT(type)   (!is_json_context() && (type & (PRINT_FP || PRINT_ANY))

(s/||/|/)
