Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA423492F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbgGaQ2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgGaQ2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 12:28:42 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D507C061574;
        Fri, 31 Jul 2020 09:28:42 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id s16so17798743ljc.8;
        Fri, 31 Jul 2020 09:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y4MseFhlx2nhgq6EPSD71hPsyiEzpOkQhRSSfYzPhlQ=;
        b=M8pMfJnodX797AVp7pTbgKNqFl7Gqzq74G9fO+q8Ibc8Bmbx25u5EEoJ7XzgLk3zSG
         hSVNlx6mhxK9panH1aINnF+KLohTyPK76KGNMnJ9e1XD+zp3sxV+76aw46kGLa+UU36D
         gSl54usVu+Kvn9HH2aq9mWDQ2gPDqBs4bJEmNi7Z6ZWVGO1f73snZaSeEglLgmPFOn/5
         pPMsPwWaMn4QFvDtFdB2YHPaQoE5JA4gobw4KXC0xbbXtxrAJIO4ktjtGlVrhxXGxRPp
         2gFP1JOP3cMpZy6CWjErAas6j2SRpbvLVUhV/vlO5ScXwlgnk1vG8aRU10CkVrR2K6+6
         wGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y4MseFhlx2nhgq6EPSD71hPsyiEzpOkQhRSSfYzPhlQ=;
        b=riZMsS5inPaCMTVxQTlI3K3DEonK6b0XTGctXeFg1j6wN1V291CvKOaCxzUwbEh77C
         yvgYJI32jgXrVEMYdaqu0dPjCqZbkPp7TL/8pO0haaP0Ueyc9AtDqXipWy8dyFJgsHwL
         I2oHh31MmEFReQDqhoCGalu/A4+HrkLjJwgPyK3pXeNvLW4bnJGpfO2cv/wWRQpUMc71
         AZtr3LpLa2D/huB26FBQ5ceKrFYRR8KYEV++Ap6GJjXcPySCx3vrzGTfYRMhgGlFFau/
         +kqRUXaGZtqKkem3jZI4oiWoMaZ4fIZuDXEfu4Onyvv+yy2K5HmOL4DVURKL3llHfLTb
         og3w==
X-Gm-Message-State: AOAM531x4+P+3Ywur/xaWx1uwCHGLbxxVdbaenRkzKW0+uaHXNJEV1Xn
        Dt3AFsf43tSt6zE4YoSkvMeXxAgu
X-Google-Smtp-Source: ABdhPJyuUTqWAx0Lxz5haBaJ67uWt3NzOUHW4DZCC4Z1qvtLUsqCzjZXpdFZ4IxYuyO8fMIeaj0YHw==
X-Received: by 2002:a2e:8542:: with SMTP id u2mr2153185ljj.154.1596212920391;
        Fri, 31 Jul 2020 09:28:40 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:225:dc3:11c8:9b9e:ad39:92d0])
        by smtp.gmail.com with ESMTPSA id s2sm1753100ljg.84.2020.07.31.09.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 09:28:39 -0700 (PDT)
Subject: Re: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
To:     "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
 <ce81e95d-b3b0-7f1c-8f97-8bdcb23d5a8e@gmail.com>
 <OSAPR01MB3844C77766155CAB10BE296CDF4E0@OSAPR01MB3844.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <32d3b998-322b-7c0a-b14a-41ca66dc601a@gmail.com>
Date:   Fri, 31 Jul 2020 19:28:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <OSAPR01MB3844C77766155CAB10BE296CDF4E0@OSAPR01MB3844.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/31/20 1:18 PM, ashiduka@fujitsu.com wrote:

> I understand that the commit log needs to be corrected.

   The subject also could be more concise...

> (Shimoda-san's point is also correct)
> 
> If there is anything else that needs to be corrected, please point it out.

   OK, I'll try to post a proper patch review...

>>    That seems a common pattern, inlluding the Renesas sh_eth
>> driver...
> 
> Yes.

    Not at all so common as I thought! Only 4 drivers use mdio-bitbang, 2 of them are
for the Renesas SoCs...

> If I can get an R-Car Gen2 board, I will also fix sh_eth driver.

    Do yuo have R-Car V3H at hand, by chance? It does have a GEther controler used for
booting up... 

>>    No, the driver's remove() method calls ravb_mdio_release() and
>> that one calls
>> free_mdio_bitbang() that calls module_put(); the actual reason lies
>> somewehre deeper than this...
> 
> No.
> Running rmmod calls delete_module() in kernel/module.c before ravb_mdio_release() is called.
> delete_module()
>    -> try_stop_module()
>      -> try_release_module_ref()
> In try_release_module_ref(), check refcnt and if it is counted up, ravb_mdio_release() is not
> called and rmmod is terminated.

   Yes, after some rummaging in the module support code, I have to agree here. I was
just surprised with you finding such a critical bug so late in the drivers' life cycle.
Well, due to usually using NFS the EtherAVB (and Ether too) driver is probably alwaysbuilt in-kernel...

> Thanks & Best Regards,
> Yuusuke Ashizuka <ashiduka@fujitsu.com>

   Trim your messages after your goodbye. That original message stuff typically isn't
tolerated in the Linux mailing lists, nearly the same as top-posting...

[...]

MBR, Sergei
