Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7278C1B92CA
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 20:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgDZS3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 14:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726152AbgDZS3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 14:29:42 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E73C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 11:29:41 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id t3so15942236qkg.1
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 11:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+X0x1vfrRfLPXyaugP84L3oF/hAtwef4Qd3h+JFlnZY=;
        b=kRDK/p+IPjfBDK0UX38kfzfBmqiL97G/g2wrchg9GKVVVYL38fGOJmKGHGzWTYjsI2
         R8Z8Z+1tnasEgBARss1NXGewrvFMt1cfP9zCN/G/ShOdHdKwciwEKrFkL7pH+rvMXQkM
         II6fy/sLeYSAOGOLHV/dvi0T++/4CT7Cy/SYjgOLWeRbwnaMQwAcgbTsY3BjUELIqnZI
         JmWwVNh4ceZxtZN+6Zyi1I7hhoUZJGpwaXIALKpDT1pUKXdYkBrcb+x5Dsye3DEGXDDk
         3phe0NWzjoJenfV8eMfV7A8q3UHx57Q9cfG9E9XBW8Onx/CU27dUN7IAo3+WiHJu/HOY
         Lx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+X0x1vfrRfLPXyaugP84L3oF/hAtwef4Qd3h+JFlnZY=;
        b=NEYzglXhZDVhwDY4uPONgH+dXgxD0xU1zedP7bnLa+CKPRb6Rueazo7nA7vML742Ft
         Lb1fHl19jOxM7wNbyDvKjwLT7Pj+Doby/bUykkkS3zHstuIOsEiRdq1MnFfVGN6rBr/8
         /9w3AXoL6O5Cwh2d1fy5fheTxro0kM1lDl20grQ2J95Kyb1yblc+785LfzTBnJ8a5dMy
         cXwxLf04j1ptryiz/1o00hJyGNgCz/jO7akFq+Ed5ydXcLZ3XGadgBcT1M8qBKqjqdv8
         hQLTIH8kVYsiexlkXagbkTZoWoBdFz+6QLthwj8GoC+MwyUqcB3G9D5uUiiK9JiOhaJg
         Yn7w==
X-Gm-Message-State: AGi0PuY/oaiygz17x1E1Qj+F2RertPO8P6XVKVSiPqvuQnsCD/tSHOwg
        xlsPc6DWXv+d4ein2BjShjyxwTQf
X-Google-Smtp-Source: APiQypJIOKcczK9LonOdet1n+SwbfdCNO1dUUdSQA+pPCGuIXO0R3Qo/7tqyCbrIwwL7lpJIbXjBpw==
X-Received: by 2002:a05:620a:1095:: with SMTP id g21mr18431705qkk.476.1587925780668;
        Sun, 26 Apr 2020 11:29:40 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id k5sm3183313qkj.53.2020.04.26.11.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 11:29:40 -0700 (PDT)
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
From:   David Ahern <dsahern@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan>
 <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan>
 <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
 <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com>
 <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
 <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com>
 <20200217130255.06644553@hermes.lan>
 <CADvbK_c4=FesEqfjLxtCf712e3_1aLJYv9ebkomWYs+J=vcLpg@mail.gmail.com>
 <CADvbK_fYTaCYgyiMog4RohJxYqp=B+HAj1H8aVKuEp6gPCPNXA@mail.gmail.com>
 <edcf3540-da91-d7af-12ff-8ca7d708bd3a@gmail.com>
Message-ID: <fbd384a0-2f7e-3e87-0e8a-3291e1f15aa5@gmail.com>
Date:   Sun, 26 Apr 2020 12:29:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <edcf3540-da91-d7af-12ff-8ca7d708bd3a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/20 4:28 PM, David Ahern wrote:
> On 4/19/20 2:39 AM, Xin Long wrote:
>> This patchset is in "deferred" status for a long time.
>> What should we do about this one?
>> should I improve something then repost or the lastest one will be fine.
> 
> I am fine with this set as is; Stephen had some concerns.
> 

Please re-send the patches.
