Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4125F53B618
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 11:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbiFBJdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 05:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiFBJdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 05:33:44 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985D4DFB5
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 02:33:38 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v19so5501902edd.4
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 02:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jLhgLLgTKtoWPjtFp8qSJCOCQYPPUCR4lznJBFvpJ40=;
        b=U2/PO1uNjGw4COGMRK/7YnRCnLhzHnfNDU3fAZ5Gx+P/GW9LrdqG3I45ITG643pzdb
         JG96C8RFIxHaJo6jdq6DH8J0mqrH0Bz1LFAyLJSsLa4UaZpclulO0L4GHi+89g9+1pnR
         HDM6h3Y5186RpYH4+PvFGvDR2Ik+oyncwi5oGmQCSvo+gPTdzOt12QXk6cniH/TCtech
         Vq3liKmSG0Xman0T2LN3WT0Wj/eUgaio4p3CEkzLOQrTkoGzCA/fMFr6AeOL1HJpIUZ2
         C0wbKaR6CbkPBGYPA6Dz6XgoxKgg/nkvNXlWjX0lgXr+zdmUXLKioQVm/Tf/NW942v7j
         a/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jLhgLLgTKtoWPjtFp8qSJCOCQYPPUCR4lznJBFvpJ40=;
        b=0H6WSsj3QmGGvMherDiCLaAaeEgk9Jg710y5hbUkB3fUsaSShozjEcE20rKjali+sH
         UCQzP60AlQtzorG8vw3p6FYFW+dgWH6EkYGcXonMUc8QKLuCOiVqSVIO3goPfoHjPUAu
         q2g3QXgw1Ktpq4px5R2012JqZQUXjGRjhxANpX9vh+u8xixEbQil3YZjpeLbJvhbFM8V
         Twbj2swMpI7BQfcg9TqoPc8Bs5mTHqBsdbRuo4SbWATrTM6aUBbxiH3IqIz1uq6QP63t
         awMPq0nNc61x2zqVinDIIc54aGI2PdQhl7WU8pzBaBC0xF1KQcfMHsPey7nlLRa1rA7B
         iYcA==
X-Gm-Message-State: AOAM530WBk03023zeMGf60g/czH4h7Vjb2lnuzqwgPxFFlbJo0lTMGSc
        qpJQAu2BL8Og/xyhA6js7GhRKQ==
X-Google-Smtp-Source: ABdhPJywohivzrOJFdGS5Hg985CLuq974adXOQGB2Rff7HbgU7ROkd7WYTRbTxBJZQJ/cUCLzUml2w==
X-Received: by 2002:aa7:c34d:0:b0:42d:ce57:5df2 with SMTP id j13-20020aa7c34d000000b0042dce575df2mr4213121edr.315.1654162416951;
        Thu, 02 Jun 2022 02:33:36 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id lk24-20020a170906cb1800b006fa84a0af2asm1596415ejb.16.2022.06.02.02.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 02:33:36 -0700 (PDT)
Message-ID: <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org>
Date:   Thu, 2 Jun 2022 12:33:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder> <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder> <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder> <86y1yfzap3.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <86y1yfzap3.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/06/2022 12:17, Hans Schultz wrote:
> On tis, maj 31, 2022 at 17:23, Ido Schimmel <idosch@nvidia.com> wrote:
>> On Tue, May 31, 2022 at 11:34:21AM +0200, Hans Schultz wrote:
>>>> Just to give you another data point about how this works in other
>>>> devices, I can say that at least in Spectrum this works a bit
>>>> differently. Packets that ingress via a locked port and incur an FDB
>>>> miss are trapped to the CPU where they should be injected into the Rx
>>>> path so that the bridge will create the 'locked' FDB entry and notify it
>>>> to user space. The packets are obviously rated limited as the CPU cannot
>>>> handle billions of packets per second, unlike the ASIC. The limit is not
>>>> per bridge port (or even per bridge), but instead global to the entire
>>>> device.
>>>
>>> Btw, will the bridge not create a SWITCHDEV_FDB_ADD_TO_DEVICE event
>>> towards the switchcore in the scheme you mention and thus add an entry
>>> that opens up for the specified mac address?
>>
>> It will, but the driver needs to ignore FDB entries that are notified
>> with locked flag. I see that you extended 'struct
>> switchdev_notifier_fdb_info' with the locked flag, but it's not
>> initialized in br_switchdev_fdb_populate(). Can you add it in the next
>> version?
> 
> An issue with sending the flag to the driver is that port_fdb_add() is
> suddenly getting more and more arguments and getting messy in my
> opinion, but maybe that's just how it is...
> 
> Another issue is that
> bridge fdb add MAC dev DEV master static
> seems to add the entry with the SELF flag set, which I don't think is
> what we would want it to do or?

I don't see such thing (hacked iproute2 to print the flags before cmd):
$ bridge fdb add 00:11:22:33:44:55 dev vnet110 master static
flags 0x4

0x4 = NTF_MASTER only

> Also the replace command is not really supported properly as it is. I
> have made a fix for that which looks something like this:
> 
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 6cbb27e3b976..f43aa204f375 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -917,6 +917,9 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>                 if (flags & NLM_F_EXCL)
>                         return -EEXIST;
>  
> +               if (flags & NLM_F_REPLACE)
> +                       modified = true;
> +
>                 if (READ_ONCE(fdb->dst) != source) {
>                         WRITE_ONCE(fdb->dst, source);
>                         modified = true;
> 
> The argument for always sending notifications to the driver in the case
> of replace is that a replace command will refresh the entries timeout if
> the entry is the same. Any thoughts on this?

I don't think so. It always updates its "used" timer, not its "updated" timer which is the one
for expire. A replace that doesn't actually change anything on the entry shouldn't generate
a notification.
