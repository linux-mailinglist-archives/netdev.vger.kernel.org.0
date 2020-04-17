Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4552A1AE2D4
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 18:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgDQQ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 12:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbgDQQ4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 12:56:12 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2264C061A0C;
        Fri, 17 Apr 2020 09:56:11 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j2so3830725wrs.9;
        Fri, 17 Apr 2020 09:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5vRyt3gyMvMWOByiQup7/iuoQyfsqpdRhoS1efdjEY4=;
        b=r96iYaAJUFqutvLlNPFb8i3j1V2Dc4shFIQjqagN+c4HoNWeaVzgEOSlDtF/nXoxKL
         4rl8ksUKanZyBWaTMkATLdET25r9HIQPScCqXELA3cNyylFog/fLtdWR2J2aD+Aot1YA
         uwzDq6E2MD1Fe/5FgD0dGmraCG6JeLOj7/OyHK2DIfWJbfzGImluPYqoqPSWmebwHv5Q
         iKppF+24I3/OXUS/3ulHsPzPByHZ9+gmoz9J4zWOJqfyl9mNR9vlRfthl3wJm6mGw3VN
         JMVkTgidHeBShG/JYVSsBUIJtXjX5RM3PMY0iQQDebm+PE6pl5ItFx7y8X87P4CVLeEr
         MIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=5vRyt3gyMvMWOByiQup7/iuoQyfsqpdRhoS1efdjEY4=;
        b=UE0I9H/HsnLjhv1Vu0WW6Ys7SNeADfwGSA6wGXrR7IuHCyMIpMfFOO7g3rhNR+upmR
         ssgL64O8NzndwJ3lAPg+zn0u5KhYEXGVUNNSuwwj8uBMCEIDKBmbumTatPSfrFtk+fVv
         nnOfLIlzUn3+RwKaf6Wusd+h9W+zvhgRkKGjjKMbkO2V9EW0KhIp1FcONxnff8frapV3
         nbIaRc9wbX/su9ygOFFG2/QfjfzTeFxCUej3+S4/8mS/W2jMOOP9nQf2xrgrFjl8c2SM
         gsxwdrUJBhGPKgrdu0sN/3NlVma0/QwtCDyH1fjOa1oNprgHw9N/vXCD626gZM6TeTim
         Cwzg==
X-Gm-Message-State: AGi0PuZLfVxcCNXKuTNS0iUnatQiv+kbYeL3uTorhgfFVdVSgx3TAW1t
        FThbmYa8jytGVcmlVPG993d36HSF6ZbkYw==
X-Google-Smtp-Source: APiQypIwZ/jq8AtZYyR5t/lj17pbtyhqWpW7mYXgNj9fweYAkXGNJPa4XJpjF5ga1tQ25cPm02FudA==
X-Received: by 2002:a5d:4106:: with SMTP id l6mr4809878wrp.111.1587142570430;
        Fri, 17 Apr 2020 09:56:10 -0700 (PDT)
Received: from [10.227.177.177] ([216.113.160.71])
        by smtp.gmail.com with ESMTPSA id y7sm33634702wrq.54.2020.04.17.09.56.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Apr 2020 09:56:09 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.14\))
Subject: Re: Long delay on estimation_timer causes packet latency
From:   yunhong-cgl jiang <xintian1976@gmail.com>
In-Reply-To: <alpine.LFD.2.21.2004171029240.3962@ja.home.ssi.bg>
Date:   Fri, 17 Apr 2020 09:56:06 -0700
Cc:     horms@verge.net.au, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, Yunhong Jiang <yunhjiang@ebay.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F48099A3-ECB3-46AF-8330-B829ED2ADA3F@gmail.com>
References: <D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com>
 <alpine.LFD.2.21.2004171029240.3962@ja.home.ssi.bg>
To:     Julian Anastasov <ja@ssi.bg>
X-Mailer: Apple Mail (2.3445.104.14)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reply.

Yes, our patch changes the est_list to a RCU list. Will do more testing =
and send out the patch.

Thanks
=E2=80=94Yunhong


> On Apr 17, 2020, at 12:47 AM, Julian Anastasov <ja@ssi.bg> wrote:
>=20
>=20
> 	Hello,
>=20
> On Thu, 16 Apr 2020, yunhong-cgl jiang wrote:
>=20
>> Hi, Simon & Julian,
>> 	We noticed that on our kubernetes node utilizing IPVS, the =
estimation_timer() takes very long (>200sm as shown below). Such long =
delay on timer softirq causes long packet latency. =20
>>=20
>>          <idle>-0     [007] dNH. 25652945.670814: softirq_raise: =
vec=3D1 [action=3DTIMER]
>> .....
>>          <idle>-0     [007] .Ns. 25652945.992273: softirq_exit: vec=3D1=
 [action=3DTIMER]
>>=20
>> 	The long latency is caused by the big service number (>50k) and =
large CPU number (>80 CPUs),
>>=20
>> 	We tried to move the timer function into a kernel thread so that =
it will not block the system and seems solves our problem. Is this the =
right direction? If yes, we will do more testing and send out the RFC =
patch. If not, can you give us some suggestion?
>=20
> 	Using kernel thread is a good idea. For this to work, we can
> also remove the est_lock and to use RCU for est_list.
> The writers ip_vs_start_estimator() and ip_vs_stop_estimator() already
> run under common mutex __ip_vs_mutex, so they not need any
> synchronization. We need _bh lock usage in estimation_timer().
> Let me know if you need any help with the patch.
>=20
> Regards
>=20
> --
> Julian Anastasov <ja@ssi.bg>

