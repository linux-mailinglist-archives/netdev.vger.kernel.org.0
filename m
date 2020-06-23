Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AF520572F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732658AbgFWQ13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732212AbgFWQ12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:27:28 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF54C061573;
        Tue, 23 Jun 2020 09:27:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ne5so1679423pjb.5;
        Tue, 23 Jun 2020 09:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zPA26VQSEKAOa0rfhz3zW4u7FT323RiZzt+Zev3RAO4=;
        b=sMLRTHSV9EJwf6H4bWAsaQcE/FHOFhvDTfZqVhCrLt2LPWJvDbzl8dWf5IAlnTtU4P
         TeCRYtoPi/ruLjcM7FiX1BxCHbeMEHHhJg8AEDnVdJIe8bzi5nx+z7JWNGneOSKCl1nw
         G2ja7K+CbiaCBXVB6NRdrfrZV7TrIg5wJbhn4yhAbBgO7XYJfZUTgx0BzowEb29AQtpE
         ayDRy88WU4pYBX/ZE0AyOYK6DfjqbrcLuhMYeNr4xJnhj75IabHKISHAyhyUXnZ8rj+l
         OFNS468xEj24RKAPOrWVH+0nIOYBy6h5NEcNpbeb9GT5p3ADdnRyMJdVeWzElGOSy/+T
         PeXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zPA26VQSEKAOa0rfhz3zW4u7FT323RiZzt+Zev3RAO4=;
        b=r5Jr4ro+HoqWtKmwP2l4sv/Me0ajXnsd1S/1afSSRYUTTErK6/aisyR8gIMjgvdCEN
         UEmztbGFXMChCvdYWY6jctZyGtH0uAX1+OoWhsYuiIJBaN8rQ0c5Aq2vYlcgUwYQEQFx
         4n5GoaZd1yA8n+o+VQyaQjGJT0LWG/KY2lGqRzb6/5Fv+S13+1LNbpslytY+E04ImRge
         hs3uxEsFLJEJo/osBRr9QmeeihOXtE07GLkY/y9w7MGqnw9I0e3YgR0dEpO36O9t0/30
         knzdTG7PinNBSJnNkeWSk4l0Ydy3nO16821CMJzfVDcHSgUEJfqQeI2C3PL0ERGoCmlL
         bEEQ==
X-Gm-Message-State: AOAM532cLP5eOXbdip26YGKhY7iPJY6ZW+FeNPy0Z7zF5biFGpvFQ/Ni
        Pvje7N4i7L+efeMK+KWeGI0N20K6
X-Google-Smtp-Source: ABdhPJx+VmrkAc0ZE7xHDGvo224LzKBjbSzM8YoTgjTbubNQPu+8V2pcaTE7md471ebJV1k8cUa0Cw==
X-Received: by 2002:a17:90b:915:: with SMTP id bo21mr24341349pjb.52.1592929647915;
        Tue, 23 Jun 2020 09:27:27 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u25sm17182337pfm.115.2020.06.23.09.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 09:27:26 -0700 (PDT)
Subject: Re: [PATCH bpf-next v3 09/15] bpf: add bpf_skc_to_udp6_sock() helper
To:     Yonghong Song <yhs@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003636.3074473-1-yhs@fb.com>
 <d0a594f6-bd83-bb48-01ce-bb960fdf8eb3@gmail.com>
 <a721817d-7382-f3d1-9cd0-7e6564b70f8b@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <37d6021e-1f93-259e-e90a-5cda7fddcb21@gmail.com>
Date:   Tue, 23 Jun 2020 09:27:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <a721817d-7382-f3d1-9cd0-7e6564b70f8b@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 7:22 PM, Yonghong Song wrote:
> 
> 
> On 6/22/20 6:47 PM, Eric Dumazet wrote:
&
>>
>> Why is the sk_fullsock(sk) needed ?
> 
> The parameter 'sk' could be a sock_common. That is why the
> helper name bpf_skc_to_udp6_sock implies. The sock_common cannot
> access sk_protocol, hence we requires sk_fullsock(sk) here.
> Did I miss anything?

OK, if arbitrary sockets can land here, you need also to check sk_type


