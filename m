Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF918E4B6
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 22:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCUVQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 17:16:37 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:45993 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgCUVQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 17:16:37 -0400
Received: by mail-pg1-f175.google.com with SMTP id m15so4964273pgv.12
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 14:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XKcQSf1hoAFX8iteht4zPGl0Ti66rLNRB4UVdyGX90g=;
        b=mj02O4F+r2GlL9015T8HWPTx624/6DnfhZbgL0EKUvAIPlPtLl+LFa5nmeF3zsM4Nd
         AgeVqrQBO8ksx0gDGJj9vfOoKnsSUwr9QG/9HcZilE0CnFkKrPN1SjSTjKgsB+awCAGE
         eGYJ/V/xp0Ej67mWAcj9UP+lrBYJUY+hPoMXzwps+3RaJG8aIgAwlDEtdcvImowmmynY
         2UbBO4QJFkr4NRn0JkhTEdIaYcV79BdTs84h2cceIvaUCE1RG5y5Ox0xoucGaZjXcq5W
         /lbNp/89GbTmFbvF4XxOJqbRWcZuF5uSlZqHnAf8/RSltOzKOhgWkp7y/Ow8p9ImzPvp
         kSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XKcQSf1hoAFX8iteht4zPGl0Ti66rLNRB4UVdyGX90g=;
        b=VbjrnlpvwUKK2SYeyANGO2qZTuYT8acpOjVVBrD3eNiB4ZvNTW2ajlfQ5baIHVU6AP
         Hx7fThnWmkmPqRc/sXdzKmZRC5v+g6aF+5CYTMSteUp4U4pzIagi1wLVN0kxFlEj+F5V
         QJw1Hb8fP8/zAbLzjoNvQ+MkNR1PRzLKdQkNOi5xXLGlIBzwPoJRaV9y//VFEfzZtFjm
         fvNEwnanCO0ZGd1AtEV4nSNtfu6g6NRYuXiN4NDHznHwkQKD8eVuhtOXwL0kbqazk3db
         0Mm3ZHyVXPtXE/RKk1lZ/AOl1mfdn0gTu6gPktxnOKQMiCaErsXVkuLbr7ScfIcTUOah
         KpBA==
X-Gm-Message-State: ANhLgQ2ii6ykM9hcM8FiCS2ofEwn5RISBLbykHGfNtKuN5vqqpQFGFBO
        un//8ZOkh7GeHA8BhCyGlSqRAnCt
X-Google-Smtp-Source: ADFU+vtLgl4JCoMdY67TQJ7lLXuNkvOfyPT9HriJjfn+zGek3fYUSDLRxiGNrRefqGO7fJKbjyslUQ==
X-Received: by 2002:a62:4ec4:: with SMTP id c187mr17352951pfb.223.1584825396309;
        Sat, 21 Mar 2020 14:16:36 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:302d:aaca:ddda:19a4? ([2601:282:803:7700:302d:aaca:ddda:19a4])
        by smtp.googlemail.com with ESMTPSA id r186sm9420127pfc.181.2020.03.21.14.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 14:16:35 -0700 (PDT)
Subject: Re: VRF: All router multicast entry(FF02:2) not added to VRF Dev but
 added on VLAN Dev
To:     Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        netdev@vger.kernel.org
References: <CADiZnkQiZSEpk5CWtNWk35+Cg=zHfpSpTe3kAhuvKvVrGjFCpw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ea4a8fbe-70c9-ead6-62b0-0be90959ccd8@gmail.com>
Date:   Sat, 21 Mar 2020 15:16:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CADiZnkQiZSEpk5CWtNWk35+Cg=zHfpSpTe3kAhuvKvVrGjFCpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 2:33 AM, Sukumar Gopalakrishnan wrote:
> Hi David,
> 
> 
> Kernel Version : 4.14.170
> 
> 
> Initiating ping to All Router address(FF02::2) with DIP as FF02:2. (
> decoded packet attached).
> 
>  
> 
> when the packet reaches
> 
> vrf_ip6_rcv
> 
>   ipv6_ndisc_frame() returns FALSE since the ICMPV6 TYPE is 128 ( echo
> request)

But need_strict is true since it is a mcast address, so the device
change should not happen. As I recall this is one of those fundamental
use cases (ping to ff02::*) that has worked since day 1 for VRF.

> 
>   Changing ingress VLAN dev to VRF DEV on skb->dev.
> 
>      
> 

