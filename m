Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6420A4DBB8B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 01:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346093AbiCQATt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 20:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiCQATs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 20:19:48 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D105C1C926;
        Wed, 16 Mar 2022 17:18:33 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id o13so1384404pgc.12;
        Wed, 16 Mar 2022 17:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JlSDTrMLCmc5n2ZJdwjUCSRTD54RzeM/4/q2sdv25jo=;
        b=c6sWo3xXkqmXwk4zqCMnEhspLRrdVlstTAEwqW5ADtJsxzmXRVvGDhHJwNbvm3L1GE
         cBePNIqauQpE2mLrOvmuh2DzSlaizlX28lqEJOuJnCB3essSkUsssjlTc5I9j+YdI+ML
         ah9cynpMusdLJTPHlaTrCjPCYdY4CKrxFigK4vTd4zcrcugtT/SqBM34cceNXtEn3Cmh
         n2qX3+Ebtdw7/Fl64N/gScs0ozHSk6Lrnvpjna19n/oGwvzO8M7wFa8UOop1wQBkqki2
         qujVIXmhyeVE09+4HeePt8Jvw2HQPA7w1UJ5QKLijFRNTqrPN3KOcFQqDIlsIa5f10Kc
         oC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JlSDTrMLCmc5n2ZJdwjUCSRTD54RzeM/4/q2sdv25jo=;
        b=yKb8uJV44bWg6zGppAyBlRKrokX9GnUl9kYjqyIW+xdMWS8NaoBC/ETsYlnblCj8mD
         hSgFlPSuQAM2GumcZzxhdLYd0xQWRgrYuoWBxorx/V9Vuo7/h1a6QcrA1ISq8jgGvJ2u
         igYEio1j+c5/ISLjOE+2YKCi4HvkTmANu1UnMeCvBefPVoo0VOW8ZHJvBYUYe/t5SuCG
         MoN3fgW8qXU5c2a+8Gr2ZZnH+cp/J368/tzDkzj7FqgFKJXhV/usLXNx8Fg3kkAEBVyx
         fpR/REyCl+ZM7Dy4jqLw/vmq0E0JyHxyNshbOZ1kJAr9qPZjXQO0k/3WicgNIo6rI+N3
         p9lQ==
X-Gm-Message-State: AOAM531E/99xtmZ63L83MLjYdbPttvpVTv0lERcCC+1aYyjwjORaGe9V
        QUfQGIGOyhML40CjbCfIvEg=
X-Google-Smtp-Source: ABdhPJzSRmsAdAJfqKM1rx3rtWQ3BwdcVcoOIx2BwAwd73G3PfuesUCuUOHS/gsZ0XuzdTE8TspiRQ==
X-Received: by 2002:a63:f0d:0:b0:381:ee45:f557 with SMTP id e13-20020a630f0d000000b00381ee45f557mr1622135pgl.436.1647476313279;
        Wed, 16 Mar 2022 17:18:33 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w21-20020a634755000000b00368f3ba336dsm3585121pgk.88.2022.03.16.17.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 17:18:32 -0700 (PDT)
Message-ID: <f9b3ecf5-c2a4-3a7a-5d19-1dbeae5acb69@gmail.com>
Date:   Wed, 16 Mar 2022 17:18:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 0/3] Extend locked port feature with FDB locked
 flag (MAC-Auth/MAB)
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
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



On 3/10/2022 6:23 AM, Hans Schultz wrote:
> This patch set extends the locked port feature for devices
> that are behind a locked port, but do not have the ability to
> authorize themselves as a supplicant using IEEE 802.1X.
> Such devices can be printers, meters or anything related to
> fixed installations. Instead of 802.1X authorization, devices
> can get access based on their MAC addresses being whitelisted.
> 
> For an authorization daemon to detect that a device is trying
> to get access through a locked port, the bridge will add the
> MAC address of the device to the FDB with a locked flag to it.
> Thus the authorization daemon can catch the FDB add event and
> check if the MAC address is in the whitelist and if so replace
> the FDB entry without the locked flag enabled, and thus open
> the port for the device.
> 
> This feature is known as MAC-Auth or MAC Authentication Bypass
> (MAB) in Cisco terminology, where the full MAB concept involves
> additional Cisco infrastructure for authorization. There is no
> real authentication process, as the MAC address of the device
> is the only input the authorization daemon, in the general
> case, has to base the decision if to unlock the port or not.
> 
> With this patch set, an implementation of the offloaded case is
> supplied for the mv88e6xxx driver. When a packet ingresses on
> a locked port, an ATU miss violation event will occur. When
> handling such ATU miss violation interrupts, the MAC address of
> the device is added to the FDB with a zero destination port
> vector (DPV) and the MAC address is communicated through the
> switchdev layer to the bridge, so that a FDB entry with the
> locked flag enabled can be added.

FWIW, we may have about a 30% - 70% split between switches that will 
signal ATU violations over a side band interrupt, like mv88e6xxx will, 
and the rest will likely signal such events via the proprietary tag format.
-- 
Florian
