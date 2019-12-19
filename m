Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C8C125EB2
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLSKPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:15:40 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42687 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfLSKPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:15:40 -0500
Received: by mail-lf1-f67.google.com with SMTP id y19so3923150lfl.9;
        Thu, 19 Dec 2019 02:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Rj2q3wD6aajz3PdA1FLrek6nU5zhW+vEBFUB4MYLIYs=;
        b=VYe/tjzPHNpyq9kN24qr+0wfOwumba6bmciRVLa+9L5NEuwXAUQgygIBNEwsMvxx2A
         5Sg/FAQKikTm1I6zgD3Pfq46QC69Fc4LaxF9XYMgsjj5m5DWD41kn7ShaJs9Hp/a0BfW
         8+MYUQ9/VfDCVH6sY0bhMFCQPTPvGw8IrrwXoyYxUesoqKWMpmZh/ltZjqVVR2arkFwe
         0yisTx5w/UZcNm/Zj4SWqhfR/xQVoWtjbLyBBi/iTAkAB5rxnbCp+QwSphWccc79DSi4
         AMgYBzY/A3xL/PWG24tLgjNzZn2hBJPqCs3WfUMJ1XApJqo090kvepcXm2XyV0t9mqWB
         r5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Rj2q3wD6aajz3PdA1FLrek6nU5zhW+vEBFUB4MYLIYs=;
        b=POuZyLbRHk4Hu5hZesNlsNL9sys7iZCrhOdvF7cuSBlSNqwHJlyi9Q6aeS39Vyd4hw
         k1+2DW2J8OmHLpQfx8nymj5pD/MWs9Xx3eYwgA0Svrudiwnu5bUmCsE2Sp9h8sw8lEKf
         yCRrLvOlAPBqj45bK+djTD1N9pzL85VNhH9XEXeWbHhOGSO5FTg2iF09B7HOl1wveo1P
         69oUsR8Rref3dQRC0C3Z+RR7J9ewrnw8/z9vpL8Cx9/KDxDO6lndVwpmHkPAmEwFMmr6
         GiwUROFfN/WC4iRHpcOolsoHjqSLAZ/3WT/SXJBXTw9sG5b1lU5A5ik7xd1eJKqamaJz
         +RFA==
X-Gm-Message-State: APjAAAXZuztYZgI188mo1xSv0YvPaNqBcs9d854QOkkVJbzkKBF6+Ulv
        da5MukE3q3d0pSpgM4IZdeNMBoQDqsyDgw==
X-Google-Smtp-Source: APXvYqya/tgd7VQnmbu9lTExcsRK48yqlOicy53+7Ka2wVmIDOYpJUSfB1plClM8Ws9/ZUmRYzQX1A==
X-Received: by 2002:ac2:4834:: with SMTP id 20mr4443150lft.166.1576750537756;
        Thu, 19 Dec 2019 02:15:37 -0800 (PST)
Received: from [192.168.43.60] ([176.227.99.155])
        by smtp.gmail.com with ESMTPSA id g24sm2384473lfb.85.2019.12.19.02.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 02:15:36 -0800 (PST)
Subject: Re: [PATCH] Revert "iwlwifi: mvm: fix scan config command size"
From:   Mehmet Akif Tasova <makiftasova@gmail.com>
To:     Roman Gilg <subdiff@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Tova Mussai <tova.mussai@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191213203512.8250-1-makiftasova@gmail.com>
 <CAJcyoyusgtw0++KsEHK-t=EFGx2v9GKv7+BSViUCaB3nyDr2Jw@mail.gmail.com>
 <CAP=YcKGLDx_coFsY7ej6BkdBJT+FELGSOMM6YM_r7jgqEsvChw@mail.gmail.com>
Message-ID: <8b895e5a-745b-a9f1-2bc8-8a1fac61129f@gmail.com>
Date:   Thu, 19 Dec 2019 13:15:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAP=YcKGLDx_coFsY7ej6BkdBJT+FELGSOMM6YM_r7jgqEsvChw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Because I used gmail mobile app to response and the app decided that 
always using HTML is a valid choice for every one, my previous mail 
rejected by mailing lists.

Because of that I am (re)sending this mail. You can find contents of my 
previous mail below.

Regards,
Mehmet Akif.

> Hi Roman,
>
> Unfortunately I don't have XPS 13 and tested the patch on Dell Vostro 
> 5481 and this patch is the result of bisection on Vostro.
>
> At first, the Archlinux bug report I shared looked similar thus that 
> bug report contains lots of dmesg outputs from different users. But 
> yes probably there is 2 distinct issue which should be solved separately.
>
> I will update commit message accordingly as soon as possible.
>
> Regards,
> Mehmet Akif
>
>
> On Wed, Dec 18, 2019, 22:12 Roman Gilg <subdiff@gmail.com 
> <mailto:subdiff@gmail.com>> wrote:
>
>     On Fri, Dec 13, 2019 at 9:36 PM Mehmet Akif Tasova
>     <makiftasova@gmail.com <mailto:makiftasova@gmail.com>> wrote:
>     >
>     > Since Linux 5.4.1 released, iwlwifi could not initialize
>     Intel(R) Dual Band
>     > Wireless AC 9462 firmware, failing with following error in dmesg:
>     >
>     > iwlwifi 0000:00:14.3: FW error in SYNC CMD SCAN_CFG_CMD
>     >
>     > whole dmesg output of error can be found at:
>     > https://gist.github.com/makiftasova/354e46439338f4ab3fba0b77ad5c19ec
>     >
>     > also bug report from ArchLinux bug tracker (contains more info):
>     > https://bugs.archlinux.org/task/64703
>
>     Since this bug report is about the Dell XPS 13 2-in1: I tested your
>     revert with this device, but the issue persists at least on this
>     device. So these might be two different issues, one for your device
>     and another one for the XPS.
>
>     > Reverting commit 06eb547c4ae4 ("iwlwifi: mvm: fix scan config
>     command
>     > size") seems to fix this issue  until proper solution is found.
>     >
>     > This reverts commit 06eb547c4ae4382e70d556ba213d13c95ca1801b.
>     >
>     > Signed-off-by: Mehmet Akif Tasova <makiftasova@gmail.com
>     <mailto:makiftasova@gmail.com>>
>     > ---
>     >  drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
>     >  1 file changed, 1 insertion(+), 1 deletion(-)
>     >
>     > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
>     b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
>     > index a046ac9fa852..a5af8f4128b1 100644
>     > --- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
>     > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
>     > @@ -1213,7 +1213,7 @@ static int
>     iwl_mvm_legacy_config_scan(struct iwl_mvm *mvm)
>     >                 cmd_size = sizeof(struct iwl_scan_config_v2);
>     >         else
>     >                 cmd_size = sizeof(struct iwl_scan_config_v1);
>     > -       cmd_size += num_channels;
>     > +       cmd_size += mvm->fw->ucode_capa.n_scan_channels;
>     >
>     >         cfg = kzalloc(cmd_size, GFP_KERNEL);
>     >         if (!cfg)
>     > --
>     > 2.24.1
>     >
>
