Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E872B6767FE
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 19:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjAUSKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 13:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjAUSJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 13:09:59 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3874216
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 10:09:56 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b4so10290282edf.0
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 10:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:to:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MeNW4hmlXG9JeSOQacfxzhfo2N2mc44lCacpPpSZ32k=;
        b=fy0pAbwHhiSgQXCJ2yhzJfMZhnAOPmtlKO7SRm47S2DDhE9Z+CAReWMZw/ouQEKDHF
         AkCRstFhPODbBJvlg/DhPWfphkYpahMYIEsLH+i9NADz2X71ieePpYmHJf8U4/lLIbSu
         M5lDsbOVMY1aR0qLsIs89kyJ/MTAPoRr59BvQFP+qIUgJHmX+aJ7CkwcY05OCnQ/FcBQ
         zfET6XE225JMBUovH7KknuK9dwOdrqaFyMj1YEy3aMnyeNS/DorFcIW+0Rg+cycT2OOX
         2ibLyATkzQccg+DfrEUKpsX+Jja3TweCWM5n2bt72ulIalWHhRVLSf1jEF5nLgL8i/eQ
         P47g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:to:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MeNW4hmlXG9JeSOQacfxzhfo2N2mc44lCacpPpSZ32k=;
        b=5TXrMGTXlrdKpjMQybowMvnst4nvKYf/ydJvFNip6LnPqHg2Nl2+JAecPJkmkED+Zk
         JL+NWubFhIpx+JXnSZBIaonj7WdfzJdqh8XIM3zzL+qVJhgo6FsW9p2mG1PglCQltgzj
         tw72TCluW0DZPpAaJKUVcT0kXPqqC8AALOmRQCKoniKcQslEhwrNFHgZABCaPYuu90ED
         2hlCJf0nlbfUza/OHcVI/lOHQIrowWkNMJZIaaQ3B4teZk5Zh8vBVbzWRQn0PXdK57L0
         Ru/Uq/aeTs6LxIeifgBCOs5jI3b7c8yrvw0aRtZkgdWbwMj3RwPDc7eH9XvQiJtXEIPQ
         G2ag==
X-Gm-Message-State: AFqh2kpZGbM94a/o31KE8zBrWSbt3yr4fHlLydHa2On87uc/V0HnHMv5
        Jpi77ghAvmgGF8ubkXhsAi1G3wxLurA=
X-Google-Smtp-Source: AMrXdXvZZyCYaEyvaaBrctw88fLSmF+6ZYvc5gs+H5MGknN3DEQ+PzKfBzlLjeACT8DY74jGocnrtg==
X-Received: by 2002:a05:6402:2989:b0:461:1998:217f with SMTP id eq9-20020a056402298900b004611998217fmr18937253edb.4.1674324594423;
        Sat, 21 Jan 2023 10:09:54 -0800 (PST)
Received: from [192.168.1.13] ([88.118.3.238])
        by smtp.gmail.com with ESMTPSA id d22-20020a50fe96000000b0049c6c7670easm11251700edt.70.2023.01.21.10.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jan 2023 10:09:53 -0800 (PST)
Message-ID: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
Date:   Sat, 21 Jan 2023 20:09:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
X-Mozilla-News-Host: news://nntp.lore.kernel.org:119
Content-Language: en-US, lt
From:   =?UTF-8?Q?Mantas_Mikul=c4=97nas?= <grawity@gmail.com>
To:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: traceroute failure in kernel 6.1 and 6.2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Not sure whether this has been reported, but:

After upgrading from kernel 6.0.7 to 6.1.6 on Arch Linux, unprivileged 
ICMP traceroute using the `traceroute -I` tool stopped working – it very 
reliably fails with a "No route to host" at some point:

	myth> traceroute -I 83.171.33.188
	traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
	byte packets
	 1  _gateway (192.168.1.1)  0.819 ms
	send: No route to host
	[exited with 1]

while it still works for root:

	myth> sudo traceroute -I 83.171.33.188
	traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
	byte packets
	 1  _gateway (192.168.1.1)  0.771 ms
	 2  * * *
	 3  10.69.21.145 (10.69.21.145)  47.194 ms
	 4  82-135-179-168.static.zebra.lt (82.135.179.168)  49.124 ms
	 5  213-190-41-3.static.telecom.lt (213.190.41.3)  44.211 ms
	 6  193.219.153.25 (193.219.153.25)  77.171 ms
	 7  83.171.33.188 (83.171.33.188)  78.198 ms

According to `git bisect`, this started with:

	commit 0d24148bd276ead5708ef56a4725580555bb48a3
	Author: Eric Dumazet <edumazet@google.com>
	Date:   Tue Oct 11 14:27:29 2022 -0700
	
	    inet: ping: fix recent breakage 
 
 


It still happens with a fresh 6.2rc build, unless I revert that commit.

The /bin/traceroute is the one that calls itself "Modern traceroute for 
Linux, version 2.1.1", on Arch Linux. It seems to use socket(AF_INET, 
SOCK_DGRAM, IPPROTO_ICMP), has neither setuid nor file capabilities. 
(The problem does not occur if I run it as root.)

This version of `traceroute` sends multiple probes at once (with TTLs 
1..16); according to strace, the first approx. 8-12 probes are sent 
successfully, but eventually sendto() fails with EHOSTUNREACH. (Though 
if I run it on local tty as opposed to SSH, it fails earlier.) If I use 
-N1 to have it only send one probe at a time, the problem doesn't seem 
to occur.
