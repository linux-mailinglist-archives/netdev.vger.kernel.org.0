Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99284576AD7
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiGOXwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGOXwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:52:39 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE826E8B1
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:52:39 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y141so5895053pfb.7
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=blMwX7Ob2mBYGhs2sOpfutShrHiATwYB6sG0kIUUHn4=;
        b=fYmt7Sac3oN8Lf4+SVi6iqy+Pb/vxUjWfp2GMjRpi21+7Od8i+IXxK0dnpWwf2VGdk
         jGfLWcVHMD/a5JqajDI1GIBDJjv6N++T9Ev1MWV/1nGz05UCdsLGQyCd3EB4vn+/mHTG
         2ls4WrIeYrTuQxJC95nX9EgkGkH/k8bSn7pjOd9FshPTVdRqxeVgvH1t7F8xRxz2EcUm
         c7txvFOrIkoHzXMqC5BRdxFGEEuvItIm4agBwCx6GpSDNC8XhpocAGTnsxYSdcczW2Df
         8egbTRoCsJWGAVFiFdnUjrEnMMv0A4u75PItGD9r9ps1oXc9Ouca2xTunwi4a73bg/wM
         Hk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=blMwX7Ob2mBYGhs2sOpfutShrHiATwYB6sG0kIUUHn4=;
        b=BdI7LerS6K7gd3zbV9PuuUvzvZAe9lF7gwG5P4w3QCe6/jQVNplSYp8OLnMw8dzdj1
         O3ccDwPw1c30GhwwnpJBPT/5WGS8dNuhM6o5GVPNaFE5xJPLebmZNemq2U7BtHD6c4uI
         TEK23LNGyQ4nxp0/iJGNWYxNbn6DY61HMcZUTzirOanTPO4uALso7c+n8m4zdoIh7I3Y
         b56wFeedITOk5GlKS9/2wY2LdI3vIji+s9FE0VN3oWVhSf9xk61ZPBQNRX22SnOf69Pu
         +4PvsBkvTlUjTHYaLs/U7nC+OBBLPlhqhWX6ys899m+7+m8TSOJzqJVzJMLgC3I7T4AX
         SkeQ==
X-Gm-Message-State: AJIora9IWZ+QlF16ye/AqGdTXQrSii1Oi1VawPaqT4pBXVv1IFlFKdLT
        mnpVNOYkmi3qHlxmSrhqQVM=
X-Google-Smtp-Source: AGRyM1tJQYdLauSgS30qQSy4rkJaKdrok14mw/JEDFWYoApLhxSGGtJnVI5SMcLebR6SQZsLOb50Qw==
X-Received: by 2002:a63:4a50:0:b0:411:4cbf:9770 with SMTP id j16-20020a634a50000000b004114cbf9770mr13939729pgl.247.1657929158795;
        Fri, 15 Jul 2022 16:52:38 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y22-20020aa79436000000b005289f594326sm4425555pfo.69.2022.07.15.16.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 16:52:38 -0700 (PDT)
Message-ID: <5ac36945-349c-f3ea-75e3-ce7e5ec37de8@gmail.com>
Date:   Fri, 15 Jul 2022 16:52:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by updating
 trans_start manually
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220715232641.952532-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/2022 4:26 PM, Vladimir Oltean wrote:
> Documentation/networking/bonding.rst points out that for ARP monitoring
> to work, dev_trans_start() must be able to verify the latest trans_start
> update of any slave_dev TX queue. However, with NETIF_F_LLTX,
> netdev_start_xmit() -> txq_trans_update() fails to do anything, because
> the TX queue hasn't been locked.
> 
> Fix this by manually updating the current TX queue's trans_start for
> each packet sent.
> 
> Fixes: 2b86cb829976 ("net: dsa: declare lockless TX feature for slave ports")
> Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Had seen the recent veth change but did not consider that it would be 
applicable to DSA somehow although it certainly is. Thanks!
-- 
Florian
