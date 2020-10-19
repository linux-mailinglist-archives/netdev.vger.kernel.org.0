Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00975292B99
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 18:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgJSQgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 12:36:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730186AbgJSQgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 12:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603125412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJ9s8xaYxYBkmCjGVLRdfk2kyqkECbsbWamfUa+vQoA=;
        b=SSOjrtEBeg7TPCZgn6ZkS227kAG7NoIVaiVjP6w+7zIc/hlHzgldT1oaHvFIcqCeOOSggb
        IW1u04tWPVnUp1U6OkmLSzJe0KuopAaktSl/xU4WzLiV/ysE/wmFG6lQX0FYskOeE7Vnkj
        nmknvR3PiR6drkZcUyoCybyxvCSS3dI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-Ud6mv7aGN1u8fCcnc3IE3g-1; Mon, 19 Oct 2020 12:36:50 -0400
X-MC-Unique: Ud6mv7aGN1u8fCcnc3IE3g-1
Received: by mail-qk1-f197.google.com with SMTP id d5so30954qkg.16
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 09:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RJ9s8xaYxYBkmCjGVLRdfk2kyqkECbsbWamfUa+vQoA=;
        b=ZH09oONrtetwWh5PPl2N/B4rWNYvUJ8HKUKHXt0tJc3X1etikqSW3N6i8UgiCbvxZ1
         4jr6cGlcYAgKz+CKxg5jPh8TYZBafeNyulNGwONg0+gmbNAMYgASlZ0+UmNATFVuZExi
         zjXUfFls6qaLYnZDFR20HegLnQWdl38d86xoDTwVUHVis0nMW11B1kh5yRC+wkU+zqqt
         zK1l+UsISFfPv3SF2Mo0sHLBwTG+DZCmfolfBfAutVZABOuyrtFQcaSc8wtRSanvyLU2
         uUOvzvUtHseXQp+336dCvPzNZhNyrSOKef6YFdqgy+S6SSz2WiLPV8IIEo6PJNN+GeZ/
         wU1w==
X-Gm-Message-State: AOAM532B7JhYNTJqd1nlqwBR++dtBxxGG24ZP7XpfIbBWhrIyIBt5b9g
        B3jdlvML+qZ/uTyR933eQz+SxCaay41bEdYoDBJpQoTFHo5khM4DBrI+OALoNbWEfBRiXTrQve1
        a/MZRc4bTsr5HtKw9
X-Received: by 2002:a37:648d:: with SMTP id y135mr385717qkb.115.1603125410129;
        Mon, 19 Oct 2020 09:36:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsvts5SeTR8WovKOLGInNhGSr3+dLgLMhsproUZSM6Q195eZXi9N1XbqSQsptRTh4xrVpRQA==
X-Received: by 2002:a37:648d:: with SMTP id y135mr385688qkb.115.1603125409803;
        Mon, 19 Oct 2020 09:36:49 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id v39sm154809qtk.81.2020.10.19.09.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 09:36:49 -0700 (PDT)
Subject: Re: [PATCH] wireless: remove unneeded break
To:     Joe Perches <joe@perches.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Christian Lamparter <chunkeey@gmail.com>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, ath9k-devel@qca.qualcomm.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        chunkeey@googlemail.com, pkshih@realtek.com, sara.sharon@intel.com,
        tova.mussai@intel.com, nathan.errera@intel.com,
        lior2.cohen@intel.com, john@phrozen.org, shaul.triebitz@intel.com,
        shahar.s.matityahu@intel.com, Larry.Finger@lwfinger.net,
        zhengbin13@huawei.com, christophe.jaillet@wanadoo.fr,
        yanaijie@huawei.com, saurav.girepunje@gmail.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20201019150507.20574-1-trix@redhat.com>
 <b31478ea-979a-1c9c-65db-32325233a715@gmail.com>
 <859112e91c3d221dc599e381dbaecb90dd6467a1.camel@perches.com>
 <fb38b96a-b666-1a6d-211d-b79278a8d878@embeddedor.com>
 <5964d734e81c198421bb7f6516dabcad37c1740d.camel@perches.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <1c358ade-abdf-e4f2-2207-9f4887e90f05@redhat.com>
Date:   Mon, 19 Oct 2020 09:36:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <5964d734e81c198421bb7f6516dabcad37c1740d.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/20 9:20 AM, Joe Perches wrote:
> On Mon, 2020-10-19 at 10:54 -0500, Gustavo A. R. Silva wrote:
>> On 10/19/20 10:21, Joe Perches wrote:
>>> On Mon, 2020-10-19 at 17:14 +0200, Christian Lamparter wrote:
>>>> On 19/10/2020 17:05, trix@redhat.com wrote:
>>>>> From: Tom Rix <trix@redhat.com>
>>>>>
>>>>> A break is not needed if it is preceded by a return or goto
>>>>>
>>>>> Signed-off-by: Tom Rix <trix@redhat.com>
>>>>> diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/n=
et/wireless/intersil/p54/eeprom.c
> []
>>>>> @@ -870,7 +870,6 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, =
void *eeprom, int len)
>>>>>   			} else {
>>>>>   				goto good_eeprom;
>>>>>   			}
>>>>> -			break;
>>>> Won't the compiler (gcc) now complain about a missing fallthrough an=
notation?
>> Clang would definitely complain about this.
> As far as I can tell, clang 10.0.0 doesn't complain.
>
> This compiles without fallthrough complaint
>
> from make V=3D1 W=3D123 CC=3Dclang drivers/net/wireless/intersil/p54/ee=
prom.o
> with -Wimplicit-fallthrough added
>
> $ clang -Wp,-MMD,drivers/net/wireless/intersil/p54/.eeprom.o.d  -nostdi=
nc -isystem /usr/local/lib/clang/10.0.0/include -I./arch/x86/include -I./=
arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arc=
h/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi =
-include ./include/linux/kconfig.h -include ./include/linux/compiler_type=
s.h -D__KERNEL__ -Qunused-arguments -DKBUILD_EXTRA_WARN1 -DKBUILD_EXTRA_W=
ARN2 -DKBUILD_EXTRA_WARN3 -Wall -Wundef -Werror=3Dstrict-prototypes -Wno-=
trigraphs -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -Werror=
=3Dimplicit-function-declaration -Werror=3Dimplicit-int -Wno-format-secur=
ity -std=3Dgnu89 -no-integrated-as -Werror=3Dunknown-warning-option -mno-=
sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64 -mno-80387 -mstack-alignm=
ent=3D8 -mtune=3Dgeneric -mno-red-zone -mcmodel=3Dkernel -DCONFIG_X86_X32=
_ABI -Wno-sign-compare -fno-asynchronous-unwind-tables -mretpoline-extern=
al-thunk -fno-delete-null-pointer-checks -Wno-address-of-packed-member -O=
2 -Wframe-larger-than=3D2048 -fstack-protector-strong -Wno-format-invalid=
-specifier -Wno-gnu -mno-global-merge -Wno-unused-const-variable -ftrivia=
l-auto-var-init=3Dpattern -pg -mfentry -DCC_USING_FENTRY -falign-function=
s=3D32 -Wdeclaration-after-statement -Wvla -Wno-pointer-sign -Wno-array-b=
ounds -fno-strict-overflow -fno-stack-check -Werror=3Ddate-time -Werror=3D=
incompatible-pointer-types -fcf-protection=3Dnone -Wextra -Wunused -Wno-u=
nused-parameter -Wmissing-declarations -Wmissing-format-attribute -Wmissi=
ng-prototypes -Wold-style-definition -Wmissing-include-dirs -Wunused-cons=
t-variable -Wno-missing-field-initializers -Wno-sign-compare -Wno-type-li=
mits -Wcast-align -Wdisabled-optimization -Wnested-externs -Wshadow -Wmis=
sing-field-initializers -Wtype-limits -Wunused-macros -Wbad-function-cast=
 -Wcast-qual -Wconversion -Wpacked -Wpadded -Wpointer-arith -Wredundant-d=
ecls -Wsign-compare -Wswitch-default     -fsanitize=3Dkernel-address -mll=
vm -asan-mapping-offset=3D0xdffffc0000000000  -mllvm -asan-globals=3D1  -=
mllvm -asan-instrumentation-with-call-threshold=3D0  -mllvm -asan-stack=3D=
0   --param asan-instrument-allocas=3D1   -fsanitize-coverage=3Dtrace-pc =
-fsanitize-coverage=3Dtrace-cmp -Wimplicit-fallthrough    -DKBUILD_MODFIL=
E=3D'"drivers/net/wireless/intersil/p54/p54common"' -DKBUILD_BASENAME=3D'=
"eeprom"' -DKBUILD_MODNAME=3D'"p54common"' -c -o drivers/net/wireless/int=
ersil/p54/eeprom.o drivers/net/wireless/intersil/p54/eeprom.c
>
I did not intend for if-else; break; changes to be in the patchset.

I will kick this out and respin the patch after i get the first pass of t=
he other changes out.

Sorry,

Tom


