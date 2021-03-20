Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D61B342E99
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 18:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhCTRXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 13:23:14 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.23]:29110 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTRWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 13:22:50 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1616260965; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=mJ1J7bHfKd8ZHI+jaOxZbajLCrtW9HydZPSmpsyk7EqVYCZq3Bgg+k/6814T2I2wWG
    lVWWV+2MRXsmr0h4hlj3w6WmU/ibtRaUVYpfe2gjIrkpR4AczOvCHtI3ygEMFTUpOvFJ
    MuBfEVvM224TAQ8y1zBu/A4oobD1RrYlY2tca1TiGdtbki03ozaXrJZYQ8pptu8W6pkq
    iwqOvk00L1YuHyFdppFy61PDKiqMUaPrFlvXicvEb7ex/ssoUtyi6GqWfxCOx3L+ohxN
    BlxcOZT8shNQKGscGJQGzh5nX+7LcMg0YjFrsyi0D27QuBQXxNkXc5sq7LfpAUZ4Zqiw
    qBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1616260965;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:To:Subject:Cc:Date:From:
    Subject:Sender;
    bh=kInF0aJiu6As9CRYFHW515769wQhik2yVRadipSAUnY=;
    b=VoqLJOAytvXV31cHbBPCLwHxofHEAwJZvGN+Iam2FpFHmNeG26QM6eo4nYLucJEOSS
    CTZ6A/5JI5s0LsOCO8Yq/SuCl5hb8PRZUWzloatcDjRSYqhlfBLuYmR63xyNT5I1YK9Z
    H/kYblnTFt6NKA6PtuCSnTO75dwy7bdWmVfFdpj9BbBtHGeKu0fB1B8im71j01hQ+Kxi
    ZBsbh48/lD4MuESPTaHJgFK2SmuEkeeTLIMRc7z+KMRA4yVqL4K0Vw4e0YcHYFeOOmd/
    Ep6Kxai/KB1Z0dB6tyxemAdLkTqq6lB3xkTNvApO3SFb4lNERoiuaaqJlVSrz88zGKfB
    IKMw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1616260965;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:To:Subject:Cc:Date:From:
    Subject:Sender;
    bh=kInF0aJiu6As9CRYFHW515769wQhik2yVRadipSAUnY=;
    b=eGxOxJku5Tj5prK+POXSTs1AmIcnKcuRw1ra13JIJxR0hJpT+Ozz/2k6EmtF1x+qLr
    zPCI0dXOo/lJN/54dbvdW+Ui+fk2mQ+BnFTl0dvBIeyFPGGaT0NJu5Edf/3vvXZfjRLC
    W6UDWmw20Tp3xOXCeDs2q7MVHqdztcQj6tC8u+1CmIr2ukjaESlVvGI6P+bu09PFpBaS
    OW0WFo7sOCV3RKFiZDY2GdJ59vqCP1SZWUsYjyT9CKUsMny1L/u3MZ9MO4XEgg5mvA/E
    YxtwR8zk9r2VYETGg+fGChpeD0Iq5JhMwlSzrPA7c2qYfinUCmwYTBODlurROC+drQH3
    aMHg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJXsh/mCA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
    by smtp.strato.de (RZmta 47.21.0 DYNA|AUTH)
    with ESMTPSA id R01debx2KHMj8MD
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 20 Mar 2021 18:22:45 +0100 (CET)
Subject: Re: Fwd: netdevice.7 SIOCGIFFLAGS/SIOCSIFFLAGS
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <CAAMKmof+Y+qrro7Ohd9FSw1bf+-tLMPzaTba-tVniAMY0zwTOQ@mail.gmail.com>
 <b0a534b3-9bdf-868e-1f28-8e32d31013a2@gmail.com>
 <AM0PR05MB4642B7A28497C98DDE5338B0EC689@AM0PR05MB4642.eurprd05.prod.outlook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <d7888897-ea02-f96a-6ad6-0c006465ca04@hartkopp.net>
Date:   Sat, 20 Mar 2021 18:22:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB4642B7A28497C98DDE5338B0EC689@AM0PR05MB4642.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alejandro,

we added IFF_ECHO these days on suggestion of Dave Miller - and the 
IFF_LOWER_UP/IFF_DORMANT were already there at that time.

I don't know if there ioctls are still used for retrieving these flags 
as I assume this is done via netlink interface today.

At least there is enough space (in the union) in the ioctl structure for 
longer data structures:

https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/if.h#L265

https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/if.h#L247

https://elixir.bootlin.com/linux/latest/source/net/core/dev_ioctl.c#L114

If you continue discussing about this topic, please remove the 
Volkswagen mail addresses from Urs and me.

I'm still maintaining the CAN subsystem in the Linux kernel - but with a 
private mail address.

And you should better add the netdev ML to your recipients 
netdev@vger.kernel.org where all the netdev guys (including Dave Miller) 
hang out.

Best,
Oliver


> 
> ------------------------------------------------------------------------
> *Von:* Alejandro Colomar (man-pages) <alx.manpages@gmail.com>
> *Gesendet:* Freitag, März 19, 2021 9:00 PM
> *An:* Erik Flodin; mtk.manpages@gmail.com
> *Cc:* linux-man@vger.kernel.org; Stefan Rompf; David S. Miller; Fredrik 
> Arnerup; John Dykstra; David S. Miller; Hartkopp, Oliver, Dr. (EESC/3); 
> Thuermann, Urs, Dr. (K-AERD/M)
> *Betreff:* Re: netdevice.7 SIOCGIFFLAGS/SIOCSIFFLAGS
> [CC += Fredrik, John, David S., Steven, Oliver, Urs]
> 
> Hi,
> 
> On 3/17/21 3:12 PM, Erik Flodin wrote:
>> Hi,
>> 
>> The documentation for SIOCGIFFLAGS/SIOCSIFFLAGS in netdevice.7 lists
>> IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO, but those can't be set in
>> ifr_flags as it is only a short and the flags start at 1<<16.
>> 
>> See also https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c 
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c>
>> 
> 
> I don't know what's the history of that.
> I researched a bit, and while the struct member is indeed a 'short' [1],
> the flags were added to the kernel for some reason.
> I added a few people to the thread that may know better what to do.Let's
> see if they can comment.
> 
> Links to relevant commits:
> 
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c 
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=746e6ad23cd6fec2edce056e014a0eabeffa838c>>
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b00055aacdb172c05067612278ba27265fcd05ce 
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b00055aacdb172c05067612278ba27265fcd05ce>>
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cd05acfe65ed2cf2db683fa9a6adb8d35635263b 
> <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cd05acfe65ed2cf2db683fa9a6adb8d35635263b>>
> <https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=6ecda4d14604d250d385346f4fe9de707f281759 
> <https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=6ecda4d14604d250d385346f4fe9de707f281759>>
> 
> Thanks,
> 
> Alex
> 
> [1]:
> 
> .../linux$ sed -n '/struct ifreq {/,/};/p' include/uapi/linux/if.h
> struct ifreq {
> #define IFHWADDRLEN     6
>          union
>          {
>                  char    ifrn_name[IFNAMSIZ];            /* if name, 
> e.g. "en0" */
>          } ifr_ifrn;
> 
>          union {
>                  struct  sockaddr ifru_addr;
>                  struct  sockaddr ifru_dstaddr;
>                  struct  sockaddr ifru_broadaddr;
>                  struct  sockaddr ifru_netmask;
>                  struct  sockaddr ifru_hwaddr;
>                  short   ifru_flags;
>                  int     ifru_ivalue;
>                  int     ifru_mtu;
>                  struct  ifmap ifru_map;
>                  char    ifru_slave[IFNAMSIZ];   /* Just fits the size */
>                  char    ifru_newname[IFNAMSIZ];
>                  void __user *   ifru_data;
>                  struct  if_settings ifru_settings;
>          } ifr_ifru;
> };
> .../linux$ grep 'define\sifr_flags' include/uapi/linux/if.h
> #define ifr_flags       ifr_ifru.ifru_flags     /* flags                */
> .../linux$
> 
> -- 
> Alejandro Colomar
> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/ 
> <https://www.kernel.org/doc/man-pages/>
> http://www.alejandro-colomar.es/ <http://www.alejandro-colomar.es/>
