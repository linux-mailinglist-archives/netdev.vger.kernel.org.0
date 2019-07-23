Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4355370DEB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 02:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfGWALZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 20:11:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42852 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfGWALY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 20:11:24 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so19863209plb.9
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 17:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=je5Wda50nxKy7rvoE0el+VsOOOL0l92/WHoGwPBgaOs=;
        b=Qml6qS8HxRaAQbVHsAobCn4olkSbsGxCh/hCvktx6cz/v1zVK0JyPra0t0aOSKk2HY
         wGlTRgucdOVeH0E9o+E8z94lVi4RidME67v4xHAepGIrlNg7Xs62xlvkUQGBwm6KnLS6
         4SlxXmq8249GHzDsytIRKLYtR5O7/G+ORtsaEBeSp81mvIB9bONFg5F5YOWoVBfMYiqW
         KLsek9aHzVNZDWar/cjDvvKGKPgsMRBHeKWNe6kEM+gxTgiTuNnlLFFwwKob1rRqIFZk
         WyAxiYksVaM8RyTtAhZZsWAKLzPxuLDFJxnuFGNR7teUUTIvQBwAN2PvugDgp/auMukF
         J1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=je5Wda50nxKy7rvoE0el+VsOOOL0l92/WHoGwPBgaOs=;
        b=aizHaIrDHmUy3ue/nNMhX4yYgSS5e2fGm/KgY6gMYOBOaLkpXVOetPvqXiV9mdP1ZZ
         o1lpwllnVBQHo4Ed6Ib+t8MmasodkrmjnNMBvBusYMP14tJZWb7rRbaSaLPvJF2wjjhN
         Jbwj8KkGeP9tsMZwvhefiFO/eko5Wl8w1QseoWTnFOBw6KmLe9slFyiedC3alYud3RK4
         VOydc1f5miSmAbNABgjsAdK6wgKbOYAVndN1wQsRWLDW4ETKGokow9kjsUoo2ivdiaqA
         jNr1XX0lPZDM+qlTjnhOpHdwVb0r6cy6KHdiY4UA6a7EsgylhQ6Umbf2OO0foSOtsG8d
         AQ3Q==
X-Gm-Message-State: APjAAAUjJogVzwjUeXf+pVl3xx2Y8qgjD0GTIHOZZBGTg40onTp2tFD2
        caBquaZdgVUZBPFQMq78imEgz0s+qac=
X-Google-Smtp-Source: APXvYqxK605yknRSSCE9VuQk+2DYo52WjlKCdfZC1Ujk8qLd5HIga013gxLHpZ/bHL7JJfbJU+UF1Q==
X-Received: by 2002:a17:902:145:: with SMTP id 63mr80235325plb.55.1563840684141;
        Mon, 22 Jul 2019 17:11:24 -0700 (PDT)
Received: from [172.27.227.204] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id o14sm82113532pfh.153.2019.07.22.17.11.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 17:11:23 -0700 (PDT)
Subject: Re: [PATCH iproute2] etf: make printing of variable JSON friendly
To:     "Patel, Vedang" <vedang.patel@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>
References: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
 <a7c60706-562a-429d-400f-af2ad1606ba3@gmail.com>
 <98A741A5-EAC0-408F-84C2-34E4714A2097@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0e5fc2fe-dc83-b876-40ac-3b6f3f47bb29@gmail.com>
Date:   Mon, 22 Jul 2019 17:11:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <98A741A5-EAC0-408F-84C2-34E4714A2097@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/19 1:11 PM, Patel, Vedang wrote:
> 
> 
>> On Jul 22, 2019, at 11:21 AM, David Ahern <dsahern@gmail.com> wrote:
>>
>> On 7/19/19 3:40 PM, Vedang Patel wrote:
>>> In iproute2 txtime-assist series, it was pointed out that print_bool()
>>> should be used to print binary values. This is to make it JSON friendly.
>>>
>>> So, make the corresponding changes in ETF.
>>>
>>> Fixes: 8ccd49383cdc ("etf: Add skip_sock_check")
>>> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
>>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
>>> ---
>>> tc/q_etf.c | 12 ++++++------
>>> 1 file changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/tc/q_etf.c b/tc/q_etf.c
>>> index c2090589bc64..307c50eed48b 100644
>>> --- a/tc/q_etf.c
>>> +++ b/tc/q_etf.c
>>> @@ -176,12 +176,12 @@ static int etf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>>> 		     get_clock_name(qopt->clockid));
>>>
>>> 	print_uint(PRINT_ANY, "delta", "delta %d ", qopt->delta);
>>> -	print_string(PRINT_ANY, "offload", "offload %s ",
>>> -				(qopt->flags & TC_ETF_OFFLOAD_ON) ? "on" : "off");
>>> -	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s ",
>>> -				(qopt->flags & TC_ETF_DEADLINE_MODE_ON) ? "on" : "off");
>>> -	print_string(PRINT_ANY, "skip_sock_check", "skip_sock_check %s",
>>> -				(qopt->flags & TC_ETF_SKIP_SOCK_CHECK) ? "on" : "off");
>>> +	if (qopt->flags & TC_ETF_OFFLOAD_ON)
>>> +		print_bool(PRINT_ANY, "offload", "offload ", true);
>>> +	if (qopt->flags & TC_ETF_DEADLINE_MODE_ON)
>>> +		print_bool(PRINT_ANY, "deadline_mode", "deadline_mode ", true);
>>> +	if (qopt->flags & TC_ETF_SKIP_SOCK_CHECK)
>>> +		print_bool(PRINT_ANY, "skip_sock_check", "skip_sock_check", true);
>>>
>>> 	return 0;
>>> }
>>>
>>
>> This changes existing output for TC_ETF_OFFLOAD_ON and
>> TC_ETF_DEADLINE_MODE_ON which were added a year ago.
> Yes, this is a good point. I missed that. 
> 
> Another idea is to use is_json_context() and call print_bool() there. But, that will still change values corresponding to the json output for the above flags from “on”/“off” to “true”/“false”. I am not sure if this is a big issue. 
> 
> My suggestion is to keep the code as is. what do you think?
> 

I think we need automated checkers for new code. ;-)

The first 2 should not change for backward compatibility - unless there
is agreement that this feature is too new and long term it is better to
print as above.

Then the new one should follow context of the other 2 - consistency IMHO
takes precedence.

