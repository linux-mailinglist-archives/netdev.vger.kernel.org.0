Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AD54BF093
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiBVDuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:50:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiBVDug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:50:36 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E92C24BEE
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:50:12 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d187so10652462pfa.10
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SgZYi5ygjn+an2kRHWA3w8E7U3o99rZUkcHcn5mvXxo=;
        b=SxTNQrNhQ8iBFjIm4vUyMGnvUmxwjOmJGMpwTxFuurD08veE0HgUPqtW9OMWVTZRAT
         kuOKfDRYAQBrJ6al7zXTd9N+L2oEtHCExtrg+9VRkxtZBwv3AMfecz61FKyURfkcsIY0
         o4aPiWeVM6MSFhwDj6Xho3gfwiI2v1YDdrfR0WPaY9u9UCuHI6I1uAg6SiNwOWhcpTON
         IrPo5MdSAmTz3ynVSB5sDytKo83m1P3SzrA6pJKyBaSftxmGAlKArW7oVD5KurBmiVim
         f7WDtLZxF+YcadXLEz5UTZ3zk50+tHIoEHzpLUSNoE4YoW+54rx5CvmR40t7Jz1k/go+
         dRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SgZYi5ygjn+an2kRHWA3w8E7U3o99rZUkcHcn5mvXxo=;
        b=Qtlb1LmR2Y54z0KR8zBbpn3Hn3SNRoYXWavqNNy72gBbqW61MqN+aRGg0qMR0dDlxA
         e6iGpBLA2qcmvKbEIswS2wd7qyLndK19uhE4Q2iDzn85vLBuTJrE+9jM6Fv7iQ+xX3Lj
         TQSiYVsU/8sr8mWjCEfUxpWGw/x+f60rFHPs6sL+YAotVaONmLKoHqQzPRDFwNYtXwsm
         7lpRee7vadinFx4uh0qceOCavgT2H+IScVss0Ykd7Ink4PwT9MNV/h0US6gdwT6tNkVK
         v9IkzlGK9f0cpq/HzJgflB+bStTJRayBTBZXftndDLU5VSz6BWM50p/xEf8merrRPMfZ
         +ocw==
X-Gm-Message-State: AOAM530N2qWrZJ4CcXgPfvPTjRg5vllg88Y9inqahsBmFbgtJDcrI9GF
        HFBg26oOh45JxVBUIodbxLg=
X-Google-Smtp-Source: ABdhPJyI4Dut0XwqkJ3ekknTMc6MCflXymW8a6IKRRSMEHCnME4hCMH1syOqu8SOz76mcygyOwVSYw==
X-Received: by 2002:a62:1d42:0:b0:4c7:f78d:6f62 with SMTP id d63-20020a621d42000000b004c7f78d6f62mr22692019pfd.33.1645501811997;
        Mon, 21 Feb 2022 19:50:11 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f3sm14655437pfe.137.2022.02.21.19.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:50:11 -0800 (PST)
Message-ID: <f3cf1c96-f1ec-7403-ae5c-c52667a232f0@gmail.com>
Date:   Mon, 21 Feb 2022 19:50:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 07/11] net: switchdev: remove lag_mod_cb from
 switchdev_handle_fdb_event_to_device
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
 <20220221212337.2034956-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2022 1:23 PM, Vladimir Oltean wrote:
> When the switchdev_handle_fdb_event_to_device() event replication helper
> was created, my original thought was that FDB events on LAG interfaces
> should most likely be special-cased, not just replicated towards all
> switchdev ports beneath that LAG. So this replication helper currently
> does not recurse through switchdev lower interfaces of LAG bridge ports,
> but rather calls the lag_mod_cb() if that was provided.
> 
> No switchdev driver uses this helper for FDB events on LAG interfaces
> yet, so that was an assumption which was yet to be tested. It is
> certainly usable for that purpose, as my RFC series shows:
> 
> https://patchwork.kernel.org/project/netdevbpf/cover/20220210125201.2859463-1-vladimir.oltean@nxp.com/
> 
> however this approach is slightly convoluted because:
> 
> - the switchdev driver gets a "dev" that isn't its own net device, but
>    rather the LAG net device. It must call switchdev_lower_dev_find(dev)
>    in order to get a handle of any of its own net devices (the ones that
>    pass check_cb).
> 
> - in order for FDB entries on LAG ports to be correctly refcounted per
>    the number of switchdev ports beneath that LAG, we haven't escaped the
>    need to iterate through the LAG's lower interfaces. Except that is now
>    the responsibility of the switchdev driver, because the replication
>    helper just stopped half-way.
> 
> So, even though yes, FDB events on LAG bridge ports must be
> special-cased, in the end it's simpler to let switchdev_handle_fdb_*
> just iterate through the LAG port's switchdev lowers, and let the
> switchdev driver figure out that those physical ports are under a LAG.
> 
> The switchdev_handle_fdb_event_to_device() helper takes a
> "foreign_dev_check" callback so it can figure out whether @dev can
> autonomously forward to @foreign_dev. DSA fills this method properly:
> if the LAG is offloaded by another port in the same tree as @dev, then
> it isn't foreign. If it is a software LAG, it is foreign - forwarding
> happens in software.
> 
> Whether an interface is foreign or not decides whether the replication
> helper will go through the LAG's switchdev lowers or not. Since the
> lan966x doesn't properly fill this out, FDB events on software LAG
> uppers will get called. By changing lan966x_foreign_dev_check(), we can
> suppress them.
> 
> Whereas DSA will now start receiving FDB events for its offloaded LAG
> uppers, so we need to return -EOPNOTSUPP, since we currently don't do
> the right thing for them.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
