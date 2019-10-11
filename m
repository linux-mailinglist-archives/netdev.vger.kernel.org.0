Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 266EED4959
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 22:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfJKUf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 16:35:27 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:40530 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729254AbfJKUf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 16:35:27 -0400
Received: by mail-pg1-f170.google.com with SMTP id d26so6428284pgl.7
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 13:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xhGvqVnVFHouUexm2NOIyGhCTm+WEcvmBThj0VH1A6w=;
        b=q0DzmMy94VVHOyEbWlskhRUbxJWVLccpw88chIRGkuqfHs6hJ0ZwYnfBULoGJ8qKjC
         K6a+ijMbKnFfU2XqRjAi+UZs10ay+1KaEpmNP+nJpV2n52Ij7xgwdd5WzJf4/HGvYvMy
         LHtFwtaoh8m5GtZn6UavX6ZLyhebHVBqnYa5Ua4fPR7U/3BKm1SbLz9D6L2XDrZSESGB
         tRP42NkdzaaExqCae9dP4DMqFRBjUYcr22NM2sk0wI6Md6TRHZXlhLkydKLr4z5E6bbt
         nCnKja2lF39PsI+5BDm6tZOZHnMjrucVTgDAPobTjv510/XO7Q05FUjoGhZewOcS6gdV
         7SNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xhGvqVnVFHouUexm2NOIyGhCTm+WEcvmBThj0VH1A6w=;
        b=NoryeMcT9I2O5+grk8Xf1D1FPRMs5Ego9zAuerOVtGn9sJY6pCZBJ3l9/a14ZKB4pX
         WzEEKff9SfkcYzJvaItPL0pWSk0FL42Z9c8V0eULM6bjfSOiaBM/WCifAC9w6Q+4ZOmu
         Cg0AfxBkp8+cP9JSt6LTxkFLLlMuyMrogMTybiLMNFS0aIE85ZrFkL2VmUb5/jN8SOV9
         +YHaAweL+gyxDyw4xlx8t0uyR28UsPToj7QrzFGkZU9xQsX8zSAMubAkmenZyU8MMhXY
         9o3LEdyUYrwKhm69v1a0yyQvSvounKIW0a9ZV0IbqI9S3Z3+Dv3//cbMcaM1AawGBgbp
         5vQQ==
X-Gm-Message-State: APjAAAWG3hZPveVtmUBfTe2v4xEWAvVznNARJa1yrH3gPpvjBytmKJOU
        1cn2Xcr0nfInX+G9GZ89QwRgEXYJ
X-Google-Smtp-Source: APXvYqzMWN38DgG/iAAh7yV4DSNykfXwdqGCtgFR8jJIKx4llgJ4RYKbSrcTIK5L70Wv+QjPuPMR7Q==
X-Received: by 2002:aa7:8249:: with SMTP id e9mr18425989pfn.19.1570826125974;
        Fri, 11 Oct 2019 13:35:25 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d0e9:88fb:a643:fda7])
        by smtp.googlemail.com with ESMTPSA id r185sm11127519pfr.68.2019.10.11.13.35.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 13:35:24 -0700 (PDT)
Subject: Re: IPv6 addr and route is gone after adding port to vrf (5.2.0+)
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <c55619f8-c565-d611-0261-c64fa7590274@candelatech.com>
 <2a53ff58-9d5d-ac22-dd23-b4225682c944@gmail.com>
 <ca625841-6de8-addb-9b85-8da90715868c@candelatech.com>
 <e3f2990e-d3d0-e615-8230-dcfe76451c15@gmail.com>
 <3cd9b1a7-bf87-8bd2-84f4-503f300e847b@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b236a2b6-a959-34cf-4d15-142a7b594ab0@gmail.com>
Date:   Fri, 11 Oct 2019 14:35:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3cd9b1a7-bf87-8bd2-84f4-503f300e847b@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/19 7:57 AM, Ben Greear wrote:
>> The down-up cycling is done on purpose - to clear out neigh entries and
>> routes associated with the device under the old VRF. All entries must be
>> created with the device in the new VRF.
> 
> I believe I found another thing to be aware of relating to this.
> 
> My logic has been to do supplicant, then do DHCP, and only when DHCP
> responds do I set up the networking for the wifi station.
> 
> It is at this time that I would be creating a VRF (or using routing rules
> if not using VRF).
> 
> But, when I add the station to the newly created vrf, then it bounces it,
> and that causes supplicant to have to re-associate  (I think, lots of
> moving
> pieces, so I could be missing something).
> 
> Any chance you could just clear the neighbor entries and routes w/out
> bouncing
> the interface?

yes, it is annoying. I have been meaning to fix that, but never found
the motivation to do it. If you have the time, it would be worth
avoiding the overhead.
