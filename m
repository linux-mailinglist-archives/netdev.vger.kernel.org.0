Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F00EBE03
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 07:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfKAGi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 02:38:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32775 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKAGi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 02:38:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id s1so8710597wro.0
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 23:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q8xxggueWc9SK8fO9sy3bGuMW1+BCaPWGBD1aFLNHtY=;
        b=F3ia3X6MXBb03XQBIXR/fP9jRX9cF+BAP7q9KJvSceSqLKXwlaheeWP044TV5rRiTn
         Olx4jU2TUhUCGC6vtz7TU+HWbiSM/uSpaA3NGovuOXjBeeyGAFWbdp0H0l59SKGz3s+m
         xG75GL+LoYKzCCFBVkSMBI4nNBehqOyHenDi7hmkqBwPjMUCobTmIhoBEutKbDGmtEfM
         /JGAvR91IE6W0zgMGZrs1DijbBl1E7dXQR1lWfNtw71ohWvZxg6oqTq3OoUiAG/9BweP
         PUa372Hwqi/FRMnOYPCqW48SKaLKtK1WaukrHpuYKQLSgE2slMLuiS3LzgLXS+/UOabJ
         yNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q8xxggueWc9SK8fO9sy3bGuMW1+BCaPWGBD1aFLNHtY=;
        b=kOELqdDPGESZD0JWO3HvTVm0xD+DqaudVz1VVaqFLivaRBXe25THThYdYx+Z8I8diT
         oKmB/vXmpIdQaeVmC8HzU5z7pS8+pgy0y+UEoOlbKFgWbsL6yO+JS5sin/XRM1RfVFvv
         RiMgc3H7PZVODHMi7Ubfiq5mQC486NnfUZlKxKvw4OFv1gdwR0pKhTnvTsXecd2zYtr4
         ooVEi4swH/GzCO0UmgRoyUcKD0ekY5G0qT7l08jV6FGle32eUVWCcQQvoJOUX5GEvLWA
         yl6iVVAcjdB1TvQHAESSB5y8CsxHWw2BpTUyognYLLq8Nsl2F8W3q7dfHkJak4AVUJFz
         Lczg==
X-Gm-Message-State: APjAAAVu9TODRqVG7sTgbNgSnikfWTEq0tHXlBs9KeQlmE0lvNx60GN5
        /141At0i1eboTSizU1w6+eK5Obix5Q4=
X-Google-Smtp-Source: APXvYqzGtGp/2u2warx9lzTK7cuyPK1dJJagFF8+ziq2k/OwA8bxzIUbHg0uj1o+1qgSe5qK/2q5lQ==
X-Received: by 2002:adf:ab41:: with SMTP id r1mr9872230wrc.281.1572590337081;
        Thu, 31 Oct 2019 23:38:57 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p18sm7609681wmi.42.2019.10.31.23.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 23:38:56 -0700 (PDT)
Date:   Fri, 1 Nov 2019 07:38:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [oss-drivers] Re: [PATCH bpf-next] Revert "selftests: bpf: Don't
 try to read files without read permission"
Message-ID: <20191101063855.GC3209@nanopsycho.orion>
References: <20191101005127.1355-1-jakub.kicinski@netronome.com>
 <CAADnVQKZbgqs3DJOsV4dtOY-ZXG8oQ7kWmJrJ_dS842qDrwABw@mail.gmail.com>
 <20191031182835.0451d472@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031182835.0451d472@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 01, 2019 at 02:28:35AM CET, jakub.kicinski@netronome.com wrote:
>On Thu, 31 Oct 2019 17:56:46 -0700, Alexei Starovoitov wrote:
>> On Thu, Oct 31, 2019 at 5:51 PM Jakub Kicinski
>> <jakub.kicinski@netronome.com> wrote:
>> >
>> > This reverts commit 5bc60de50dfe ("selftests: bpf: Don't try to read
>> > files without read permission").
>> >
>> > Quoted commit does not work at all, and was never tested.
>> > Script requires root permissions (and tests for them)
>> > and os.access() will always return true for root.
>> >
>> > The correct fix is needed in the bpf tree, so let's just
>> > revert and save ourselves the merge conflict.
>> >
>> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>  
>> 
>> Acked-by: Alexei Starovoitov <ast@kernel.org>
>> Since original commit is broken may be apply directly to net-next ?
>> I'm fine whichever way.
>
>I'm 3 fixes down to get test_offloads.py to work again. One for
>cls_bpf, one for the test itself and one for net/core/dev.c logic.
>Should I target all those at net?
>
>Are you and Daniel running test_offloads.py?  It looks like it lots of
>things slipped in since I last run it :(
>
>> I would wait for Jiri to reply first though.
>
>Not sure what he can contribute at this point but sure :/

I'm okay with Jakub taking care of the fix. Thanks!
