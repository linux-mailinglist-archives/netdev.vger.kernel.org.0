Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BEA20E49
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 19:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfEPRx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 13:53:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46315 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEPRx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 13:53:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id t187so1903496pgb.13
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 10:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GowTIZhp3cx6OoNrF5AWJqCGO8YiFz0dODGT2x2ydBI=;
        b=TemCRYe6X//3SqqdlBEoST3v2XMP+Ays+wWyUPiNSTffDYJOJbGoM+iUcXm/gdO1+a
         8MueDVyigVr2+shK5A47O4EwatVwOhf++ehUsPL+0qE8YVCOnUqDKcwnq6R3hHZgmPzR
         hMpatx6JOLz7GJo1RRosrpCY6IlzNtFCXgOL8TjR7E9ChjMrN8LfJ+4T4ky3q/40HTUz
         cQ0+3AYks73CZ9TXMZYfGfKH1VlFj9wmq1PA4FZ6Dd7KkSu4+apEhQGRP25+DJtwJSM0
         8hZWU913/00L68z6cVdOJ+GLuMtQvNKJ7YaYoCip48CWek3BfU6wnfv7pPdZmdMaXZNt
         OpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GowTIZhp3cx6OoNrF5AWJqCGO8YiFz0dODGT2x2ydBI=;
        b=QY6spCu0or2wysiUsCBANl24TIYjbvqyAsUYdgMGic6uqUaDyB/JNy5tRiaS7V+X5b
         kHrDkP2Liu3FZwgmnW/Dxg3qZujxeRVAiLP2455W7SZK/TMtO9k2ESvhfdCWQSG8HRWi
         aaxgtTrpaxD2fKZBanCB19sNe3AegjamdO5z52JAnwnWnrNA9bvOz8DrADW0oRWeDwxX
         0IOU187bnhu0y7V76ijuMSeVeFugeTFDdyj/iPk26LCh6oMAK0Kx3XI16mRduWT+QzO6
         RE6MWHRhsv5MoNGMKb+Rspa9kndpEKBj5geKMR05FWf4BZKIPtMI0KwJ3NQJ/EnctUBH
         nWwQ==
X-Gm-Message-State: APjAAAXcsxXDOlFIiGKoxWu3aM5xdNgYwyJ7yu/EsiK/9I1m8W9r2+PA
        uI646vScELb16yGkfyBuUztwvAqV
X-Google-Smtp-Source: APXvYqxsZNzJRCd9jekiKlLoTaES9b1Z5ncb7+tbvAwGukwW/Jk6PmwKmriiKNEeuS/tqo8vTGx3nA==
X-Received: by 2002:a63:db10:: with SMTP id e16mr10402064pgg.142.1558029238424;
        Thu, 16 May 2019 10:53:58 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:9983:b39:b7ee:6ed6? ([2601:282:800:fd80:9983:b39:b7ee:6ed6])
        by smtp.googlemail.com with ESMTPSA id e123sm6846637pgc.29.2019.05.16.10.53.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 10:53:57 -0700 (PDT)
Subject: Re: [PATCH net] selftests: pmtu.sh: Remove quotes around commands in
 setup_xfrm
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190516174131.19473-1-dsahern@kernel.org>
 <20190516195140.158e602f@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <235d1405-dddd-8fac-64d9-dadec78e4570@gmail.com>
Date:   Thu, 16 May 2019 11:53:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190516195140.158e602f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/19 11:51 AM, Stefano Brivio wrote:
> On Thu, 16 May 2019 10:41:31 -0700
> David Ahern <dsahern@kernel.org> wrote:
> 
>> From: David Ahern <dsahern@gmail.com>
>>
>> The first command in setup_xfrm is failing resulting in the test getting
>> skipped:
>>
>> + ip netns exec ns-B ip -6 xfrm state add src fd00:1::a dst fd00:1::b spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
>> + out=RTNETLINK answers: Function not implemented
> 
> Thanks for fixing this, I ran into this issue right today and I was
> about to send a patch too. For the record, the quotes went all the way
> into xfrm_alg_name_match():
> 
> 	name: 'rfc4106(gcm(aes))'
> 	entry->name: rfc4106(gcm(aes))
> 
> My solution was to remove the single quotes around 'rfc4106(gcm(aes))',
> but I just checked yours and it also works on bash and dash, so I don't
> really have a preference.
> 

None of the other commands have the "" with run_cmd. Not sure why I did
not remove the quotes from the xfrm commands.

