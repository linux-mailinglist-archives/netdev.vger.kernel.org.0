Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3131F52A0
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgFJKuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 06:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgFJKuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 06:50:37 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654F3C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 03:50:37 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id q19so2020048eja.7
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 03:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k6/5rE4mSIev2YPjBrb+P1utIrfLFuYAT+rxCLbAtVE=;
        b=EY3o2sGwckGDEGd1LQeTptK1uPXlGL1kha/yPB7PaEIecGXg1EI53uycH6EyRwl4JV
         6PFWx03So0U6/MLmTPrJ5fp/CLpsE0F3T/2AVfXleTyyI7ouqaiunniAtTV0daYGH1rw
         paMcuFIJ+A6OwCn6FKqGWvLovu2ivAKOdQ7QoyGUT8ysT3OX6PO2QC9Ta7TEj2HGuMrN
         wumWu0WdvAWOuypWwaObt6nPYu2TYCEMwQy8AWI2Za7j+MOKjVWM7VVHUSWhSWGB07Qc
         /M0XUfr1/BfW2LZhnpDA9NiGPRbeHmXxYfegzpfEp8QJAYh1e2MMVlwJ47Tg6AuU8JPa
         zZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k6/5rE4mSIev2YPjBrb+P1utIrfLFuYAT+rxCLbAtVE=;
        b=tIyfAvRA5hXmYtgbhIGHleQgj7q5lBC60gtZmK3Ov6WaZfvdZXD6qAPOGIan7wTUmf
         krKp3Whw1D2fPfkyuxd8yfZDgs1bwpY48ltDG7+G9qU70fxyrL2L8JzkcN9HIFVan3jE
         1U41JY83fQQy+72LqukTiKk20cfXsxNKvLXbg7j8tEspcg5VGLPqdkq8DBWoUSmt+KF6
         xh/YNAzRtLQO0CkLGIKprZHESDZdpqYp/y9/EZrjq23z5RPe7sLKEM+rw7QHI8Q2BADW
         /yNhpPtLvnM9gK0PfOPiQxvUNfmNQOcmVWOiQxpV3iUll+1ENvDjukkQZH2zTkitEFd4
         7A3w==
X-Gm-Message-State: AOAM530TI2S/HvimlL+Y1APsv+WWIfYzK83Af1iZhu5KWjI/4vGEMp4x
        OsfFZ51hPJtsZNNQIGPM6aOjrR3y
X-Google-Smtp-Source: ABdhPJwB21GubPds/wZqw2ccjdDqqNzL+LguUxXm/25PBV9/9JYfPqoC4buEoFpThGAZBpo02uQlSw==
X-Received: by 2002:a17:906:3a0d:: with SMTP id z13mr2713999eje.122.1591786235875;
        Wed, 10 Jun 2020 03:50:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8de0:f6e2:666:9123? (p200300ea8f2357008de0f6e206669123.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8de0:f6e2:666:9123])
        by smtp.googlemail.com with ESMTPSA id ox27sm15124596ejb.101.2020.06.10.03.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 03:50:35 -0700 (PDT)
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
Date:   Wed, 10 Jun 2020 12:50:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.06.2020 11:13, Michal Kubecek wrote:
> On Wed, Jun 10, 2020 at 10:52:26AM +0200, Heiner Kallweit wrote:
>> On 10.06.2020 10:26, Heiner Kallweit wrote:
>>> Since ethtool 5.7 following happens (kernel is latest linux-next):
>>>
>>> ethtool -s enp3s0 wol g
>>> netlink error: No such file or directory
>>>
>>> With ethtool 5.6 this doesn't happen. I also checked the latest ethtool
>>> git version (5.7 + some fixes), error still occurs.
>>>
>>> Heiner
>>>
>> Bisecting points to:
>> netlink: show netlink error even without extack
> 
> Just to make sure you are hitting the same problem I'm just looking at,
> please check if
> 
> - your kernel is built with ETHTOOL_NETLINK=n

No, because I have PHYLIB=m.
Not sure what it would take to allow building ethtool netlink support
as a module. But that's just on a side note.

> - the command actually succeeds (i.e. changes the WoL modes)

Yes, it does.

> - output with of "ethtool --debug 0x12 -s enp3s0 wol g" looks like
> 
>   sending genetlink packet (32 bytes):
>       msg length 32 genl-ctrl
>       CTRL_CMD_GETFAMILY
>           CTRL_ATTR_FAMILY_NAME = "ethtool"
>   received genetlink packet (52 bytes):
>       msg length 52 error errno=-2
>   netlink error: No such file or directory
>   offending message:
>       ETHTOOL_MSG_LINKINFO_SET
>           ETHTOOL_A_LINKINFO_PORT = 101
> 

That's the exact output I get.

> If this is the case, than the commit found by bisect only revealed an
> issue which was introduced earlier by commit 76bdf9372824 ("netlink: use
> pretty printing for ethtool netlink messages"). The patch below should
> suppress the message as intended.
> 
> Michal
> 

Thanks, Heiner

> diff --git a/netlink/nlsock.c b/netlink/nlsock.c
> index 2c760b770ec5..c3f09b6ee9ab 100644
> --- a/netlink/nlsock.c
> +++ b/netlink/nlsock.c
> @@ -255,12 +255,12 @@ int nlsock_process_reply(struct nl_socket *nlsk, mnl_cb_t reply_cb, void *data)
>  
>  		nlhdr = (struct nlmsghdr *)buff;
>  		if (nlhdr->nlmsg_type == NLMSG_ERROR) {
> -			bool silent = nlsk->nlctx->suppress_nlerr;
> +			unsigned int suppress = nlsk->nlctx->suppress_nlerr;
>  			bool pretty;
>  
>  			pretty = debug_on(nlsk->nlctx->ctx->debug,
>  					  DEBUG_NL_PRETTY_MSG);
> -			return nlsock_process_ack(nlhdr, len, silent, pretty);
> +			return nlsock_process_ack(nlhdr, len, suppress, pretty);
>  		}
>  
>  		msgbuff->nlhdr = nlhdr;
> 

