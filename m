Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E07FDFA
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 18:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388469AbfHBQA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 12:00:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36529 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387819AbfHBQA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 12:00:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id k8so33830830plt.3
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 09:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lF2z34hJmYjkNcV42qKf6sePluPVetivIIDpNcqlfZk=;
        b=GjyMmsEbJRir4zhVso4SQ/KWNrT/6qOuwKdB8oLT6f+zQb+6clOqoZhdq3j85ZXc4f
         W7ItUrNEmBkRpQUqTMn2J6xoDxqMkvTOfXnSKHaYJcz3npOFqxA1a0h/nE8gg+u/trqK
         yH9cOugz9pmf+g3FyRHY1i0exNf7sfECYN1//9rSEMriRD1z2YLEm6SFU7qU89FK1nFc
         Fuv3SoTvmr0oWyFS1aNY58oLIiOnsxb6RmhEnlfo3lsKd+Ccyf47wDjXLR2Hg8bWJuPL
         ilAW6EsBRZ+UPXOGJeEFfZ493iVQVUhtoQ5hMz3suPQKlDbucUHmPOa3UA9sWOfxMhnC
         ffjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lF2z34hJmYjkNcV42qKf6sePluPVetivIIDpNcqlfZk=;
        b=YwQp6sOQnjY1hmFhdY7HmHM2S8sN89HICRjmsUM8JDfvWOekGn2V+HBcmOhdYaU4TT
         BPSmEWglx1ZxsXr84LQxTQ34VyjaLjm18zqoPF8k48gq3p69Q5MHGKCCuk/QPbnbvJU2
         jOOf77aV+x6XmK+DPPHCFjBer/Cshk+CV3M9iyDJJSmabmJhpOewOETGb64A2K7xUCLL
         Q0vg14A5g3W9sFQnki9b/6ckVE00SMH7cvhwMoh7qgGO+oOhbXo+9M1TNiUpMxmEpazG
         h0QHOL7j26x6IS2ag0Ww1PtDdkvqzJDRIgCLqSqunqtzqUCHdzTKoZaIDNmraJcujovu
         /1IA==
X-Gm-Message-State: APjAAAXMVayM5Okmq9T2P5Y3Hl0S0/rzgHAModfPKPf/DZtXoNUPRDsA
        q7G/D6IbHk9vXlhzQZc+B9Xhev6B
X-Google-Smtp-Source: APXvYqykI3tdMyddLHRwHvH8rExCwLxugfRcGLEpdaxJxhtlaOGh/jkm3YzY4FmwlH51Mc/tClL6IA==
X-Received: by 2002:a17:902:9a95:: with SMTP id w21mr48673964plp.126.1564761655126;
        Fri, 02 Aug 2019 09:00:55 -0700 (PDT)
Received: from [172.27.227.195] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id v7sm35808968pff.87.2019.08.02.09.00.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 09:00:54 -0700 (PDT)
Subject: Re: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
 <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
 <7b95042e-e586-2ca2-2a26-f5aea5a8184b@gmail.com>
 <CAADnVQJ7GUX=EWP0RWxpe71cGx2cTMyKHsA+6RRX0P05FPMg3w@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <24f9ffa2-20ac-b3ea-1024-3aa9f13a6a57@gmail.com>
Date:   Fri, 2 Aug 2019 10:00:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQJ7GUX=EWP0RWxpe71cGx2cTMyKHsA+6RRX0P05FPMg3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 9:15 AM, Alexei Starovoitov wrote:
> On Thu, Aug 1, 2019 at 9:11 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 8/1/19 6:19 PM, Alexei Starovoitov wrote:
>>> Do you really need 'sleep 1' everywhere?
>>> It makes them so slow to run...
>>> What happens if you just remove it ? Tests will fail? Why?
>>
>> yes, the sleep 1 is needed. A server process is getting launched into
>> the background. It's status is not relevant; the client's is the key.
>> The server needs time to initialize. And, yes I tried forking and it
>> gets hung up with bash and capturing the output for verbose mode.
> 
> That means that the tests are not suitable for CI servers
> where cpus are pegged to 100% and multiple tests run in parallel.
> The test will be flaky :(
> 

once the tests exist, they can be improved - by me or anyone else that
has the time and interest.
