Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3744B1803C
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 21:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfEHTHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 15:07:45 -0400
Received: from ucol19pa10.eemsg.mail.mil ([214.24.24.83]:6560 "EHLO
        UCOL19PA10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfEHTHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 15:07:45 -0400
X-Greylist: delayed 700 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2019 15:07:44 EDT
X-EEMSG-check-017: 674334619|UCOL19PA10_EEMSG_MP8.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,447,1549929600"; 
   d="scan'208";a="674334619"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UCOL19PA10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 08 May 2019 18:55:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1557341748; x=1588877748;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=wrg8Qy9ljSwJc1kKM05KE9KYiDXqyqGFTY5aiRA8EFU=;
  b=nhTrye2Yaa/t4ZV4TEuFS7WXwgSnBbNYeHbhdIgHt6quNJs7l50IJJXt
   aMCWZWTc29WBdvrR2AllIENMK4ptAYjp8IX+O3pl5cSh01fAUMR9UsFqy
   1EIM1eWgvQt8aIXqbGpyxZPuI8BRXC34Ojckopk/EIYuYvjEiJLiZF2F7
   WCYpxyNJXHc5VSLiJ/OMGGV0dwX2YL4zYyoWG5l23+kw9ivzWksrPx5AR
   VTxF7PQ16tXhpERHRP1XwXa4fuYeW2hizYhk1MArGVA3df7Q55R4XhfyH
   Y94rxZj5DbRxu+pEjg5Nz0atwhjube1BxnHxrkcCFoSAosc+YATRhp87H
   A==;
X-IronPort-AV: E=Sophos;i="5.60,447,1549929600"; 
   d="scan'208";a="23349391"
IronPort-PHdr: =?us-ascii?q?9a23=3APESTqB+8PgZ9h/9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B+0uISIJqq85mqBkHD//Il1AaPAdyCraIfwLON6ujJYi8p2d65qncMcZhBBV?=
 =?us-ascii?q?cuqP49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx?=
 =?us-ascii?q?7xKRR6JvjvGo7Vks+7y/2+94fcbglVmTaxe7B/IRu5oQnMuMQanJZpJ7osxB?=
 =?us-ascii?q?fOvnZGYfldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2?=
 =?us-ascii?q?Yu5M32rhbDVheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RS?=
 =?us-ascii?q?iu4qF2QxLzliwJKyA2/33WisxojaJUvhShpwBkw4XJZI2ZLedycr/Bcd8fQ2?=
 =?us-ascii?q?dOUNxRVyhcCY2iaYUBAfcKMeJBo4Tzo1YCqB2zDhSuCuzy0D9FnmL407M00+?=
 =?us-ascii?q?ohEg/I0gIvEN0Mv3vIo9v4L7sSXOOvwaXU0TnOYfFb1DHg44bIaBAhpvSMUK?=
 =?us-ascii?q?ptf8rN10YvDwPFgUuWqYf4Ij2V0/4Cs2yf7+V+VeOklmkqqxpsrTi03coslo?=
 =?us-ascii?q?nIiZ4VylDD7yl5xp01KseiRE50Zt6kDoJduieHPIV1WsMvW3xktSk1x7EcuZ?=
 =?us-ascii?q?O3YTIGxIooyhLBcfCLbo6F6Q/5WumLOzd3nndldaq6hxa17Eev1PXxVtKx0F?=
 =?us-ascii?q?ZWtipFlcTMtmwV2xzT9MeHTvx981+92TmVzQDT6/xEIVsumarHK58u3r4wlp?=
 =?us-ascii?q?0JvUTFAiD2g1n5gLWTdkUl/uik8+XnYrP4qZ+AL4J4lw7zP6s0lsG/HOg0KB?=
 =?us-ascii?q?YCUmeF9eimybHv5Uj5T69Ljv0ynKnZqpfaJcEDq66iHgBVyZ0u6wq/Dji60N?=
 =?us-ascii?q?QYmmMLLFReeB2dlYTpNFbOIO7gAfeln1usiCtrx+zBPrD5B5XCNGLDn6v/cr?=
 =?us-ascii?q?Z57E5Q0g4zws5e55JIDLEOPujzV1T+tNzdFBA5Mgi0z/z7B9V604MUQXiPDb?=
 =?us-ascii?q?OBMKPOrV+I4foiI/GWa4AOpjn9Lfkl6uX0jXAnhFAdfbOm3YcNZH+kGfRmJl?=
 =?us-ascii?q?2TYWDwjdcZDWcKog0+QfTyiFKYTD5TY22/X7om6TEmDIKqFILDRoeqgLybwi?=
 =?us-ascii?q?i3BIFZZmdDClqUC3fna52EW+sQaCKVOsJhiSILVbygS48nyBGvuxT3y6RoLu?=
 =?us-ascii?q?XK4C0Ur5Hj28Zv5+3Vix4y8SZ4D8OH02GCV2t0hH8HRycq3KBjpkxw0lGD3r?=
 =?us-ascii?q?Zkg/NFC9NT+ehEUhk1NZHC1ex2EdPyVRzbftePVlmmRs+qATYrTtI+29UOeV?=
 =?us-ascii?q?pyG82+jhDf2CqnG6MVmKGVC5wv7K3d337xKt1ny3nYyaYhj0MpQtdVOWK6ga?=
 =?us-ascii?q?5/8hDZB5TVnEWBi6aqaaMc0TbX9GeC0WWOvFtXUBRtXqrdQX8QfkvWos745k?=
 =?us-ascii?q?PEUbCuEq8qPRBdyc6DLKtKdsPmjU9ARPj9JNTSeX6+m2C1BUXA+rTZSYPwcG?=
 =?us-ascii?q?gZ223nCUMNiQwUtVKLNBQ4Cz3p92fXFjdjEVWpZ07t7e9zslu0S0Y1y0eBaE?=
 =?us-ascii?q?g3hJSv/RtAvuCRU/Me2Po/vS4lrzhlVAKm08n+F8uLpw0ner5VJ9w6/gEUhi?=
 =?us-ascii?q?riqwVhM8n4fOhZjVkEflEy5hi/2g=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2A3AACwJdNc/wHyM5BkHAEBAQQBAQcEAQGBUQcBAQsBg?=
 =?us-ascii?q?WYqgToBMiiEEIgci0IBBAaBNYlMjwaBewkBNAEChD8CgggjNAkOAQMBAQEEA?=
 =?us-ascii?q?QEBAQMBAWwogjopAYJnAQUjBAsBBUEQCQIYAgImAgJXBg0GAgEBgl8/gXcUk?=
 =?us-ascii?q?WybZXwzhUeDHYFGgQsnAYtNF3iBB4ERJ4JrPmmGZYJYBIsXnCsJgguCBpBDB?=
 =?us-ascii?q?huVVy2IaJRRhSs4gVYrCAIYCCEPgyeCGxeOOyMDMIEGAQGQCAEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 08 May 2019 18:55:46 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x48ItiI8030368;
        Wed, 8 May 2019 14:55:44 -0400
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Paul Moore <paul@paul-moore.com>,
        selinux@vger.kernel.org, netdev@vger.kernel.org,
        Tom Deseyn <tdeseyn@redhat.com>,
        Richard Haines <richard_c_haines@btinternet.com>
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
 <36e13dc4-be40-d1f6-0be5-32cd4fc38f6e@tycho.nsa.gov>
 <83b4adb4-9d8f-848f-d1cc-a4a1f30cee51@tycho.nsa.gov>
 <20190508182737.GK10916@localhost.localdomain>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <0957f30f-07b8-5e2f-ac71-615f511a5eea@tycho.nsa.gov>
Date:   Wed, 8 May 2019 14:51:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508182737.GK10916@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/19 2:27 PM, Marcelo Ricardo Leitner wrote:
> On Wed, May 08, 2019 at 02:13:17PM -0400, Stephen Smalley wrote:
>> On 5/8/19 2:12 PM, Stephen Smalley wrote:
>>> On 5/8/19 9:32 AM, Paolo Abeni wrote:
>>>> calling connect(AF_UNSPEC) on an already connected TCP socket is an
>>>> established way to disconnect() such socket. After commit 68741a8adab9
>>>> ("selinux: Fix ltp test connect-syscall failure") it no longer works
>>>> and, in the above scenario connect() fails with EAFNOSUPPORT.
>>>>
>>>> Fix the above falling back to the generic/old code when the address
>>>> family
>>>> is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
>>>> specific constraints.
>>>>
>>>> Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
>>>> Reported-by: Tom Deseyn <tdeseyn@redhat.com>
>>>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>>>> ---
>>>>    security/selinux/hooks.c | 8 ++++----
>>>>    1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>>>> index c61787b15f27..d82b87c16b0a 100644
>>>> --- a/security/selinux/hooks.c
>>>> +++ b/security/selinux/hooks.c
>>>> @@ -4649,7 +4649,7 @@ static int
>>>> selinux_socket_connect_helper(struct socket *sock,
>>>>            struct lsm_network_audit net = {0,};
>>>>            struct sockaddr_in *addr4 = NULL;
>>>>            struct sockaddr_in6 *addr6 = NULL;
>>>> -        unsigned short snum;
>>>> +        unsigned short snum = 0;
>>>>            u32 sid, perm;
>>>>            /* sctp_connectx(3) calls via selinux_sctp_bind_connect()
>>>> @@ -4674,12 +4674,12 @@ static int
>>>> selinux_socket_connect_helper(struct socket *sock,
>>>>                break;
>>>>            default:
>>>>                /* Note that SCTP services expect -EINVAL, whereas
>>>> -             * others expect -EAFNOSUPPORT.
>>>> +             * others must handle this at the protocol level:
>>>> +             * connect(AF_UNSPEC) on a connected socket is
>>>> +             * a documented way disconnect the socket.
>>>>                 */
>>>>                if (sksec->sclass == SECCLASS_SCTP_SOCKET)
>>>>                    return -EINVAL;
>>>> -            else
>>>> -                return -EAFNOSUPPORT;
>>>
>>> I think we need to return 0 here.  Otherwise, we'll fall through with an
>>> uninitialized snum, triggering a random/bogus permission check.
>>
>> Sorry, I see that you initialize snum above.  Nonetheless, I think the
>> correct behavior here is to skip the check since this is a disconnect, not a
>> connect.
> 
> Skipping the check would make it less controllable. So should it
> somehow re-use shutdown() stuff? It gets very confusing, and after
> all, it still is, in essence, a connect() syscall.

The function checks CONNECT permission on entry, before reaching this 
point.  This logic is only in preparation for a further check 
(NAME_CONNECT) on the port.  In this case, there is no further check to 
perform and we can just return.

> 
>>
>>>
>>>>            }
>>>>            err = sel_netport_sid(sk->sk_protocol, snum, &sid);
>>>>
>>>
>>

