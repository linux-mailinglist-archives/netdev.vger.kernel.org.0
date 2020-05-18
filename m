Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA251D8A61
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgERWCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:02:16 -0400
Received: from sonic307-16.consmr.mail.ne1.yahoo.com ([66.163.190.39]:35038
        "EHLO sonic307-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727819AbgERWCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 18:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589839333; bh=w2GNADR29FSgPiHfCduH+ZLBT4nS5ZBtv5uk2h/Vz5Y=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=Buwh9S0dbCi+tZIQqs+SF0dxlTd5yebOlUwUyGY99e7PPgoNQAElipsPMuFeUh4MMeALZ9zul3/5S6FAOoUX1OXJwMCHkLZ4OnHCd5sH6n/aKDv+8A81G7SqleD84wQ3ZG4eSJ+20wBInlyWOLTz911KdfJOE1s9ZbcPyXt7vTqZfFSVvyvGm/uzYgYpRSYNf2hYkUHG1zantRKbftXzuo3Y4TSquIctUSu0JHpaYNZTf7yTSaC+3XjO/u6XDKwyXOjFJykELUvE//0zuHb7Eks7C0774RUiboi9YKRyY4GL07XFL8MzyQj7N2dMwwIIOvpD5DlAzuLVppkxQi3DKw==
X-YMail-OSG: LTWQmxQVM1m4gPSvrOIoe.jWoyKnOdwfylVIrDlXFm9Yni5sJZ3UwfgMqPRQ5Xz
 PXZAbcAZUJPFcsnJL6kLPuse.pJr0thq09lQvz_7eIB2OPeNNNkwBIkiOX_Vwr8emUKmME5tdtIJ
 jzHlCNdt.y8juHjWRy9pICpKMJZSUldh5Db0ny9qqCm1GbnTfd61epnWlLqS6vS__hQAJ9yYuFAw
 gTzTE2104ctN4xvqIcc_RR9KmFWewIcQUn3bJFWnZuRpuYW_S2d.HfV13738VRTjp1plDE7kGL7r
 7DLpSjaQmzBVW5cxYquVN45srvYe0intAKujbO8bP8lObvNFtHGc6cKEb0TLdM0WAESmwz9zPpG9
 363FyOEF2bMKfpvqmJFKl..abSFx59ytMSJpQJZX8kmFEqE1v4aNQD3RJqNzD_TQNGTu1apIFVJE
 TWOBEV8f4._g55c07eGLYPkM8azkc2RI.YRmSr8AZPl0rYzNCp8L6Y6eMe9E7BS1nTTmS6NWDf5i
 Z1B.2uNnfpgugm3eRlTQG30YQX4iP6QjWls4ISYDZTVzsF6z3KUWC_0cO0N34QsNU6kVfGwD86it
 W9L6KFmLzDUac.WjkJVXbznzVg8atEutuFEkNZpJCQRNa66L8fXfj9d.TDV1f3mku8_NX5iskO7Y
 eHUExuWpmo6mjAffH_IJPnpB5SdHLfldsG2pVhImLxjWYe5Z94XppBJsjshHy4q_ny__cOuMFVtO
 f0u5dIuJXFPE9gVTHEFdwkULe2kv8OPkLI3VjXzHI4GKTrl2vzLwgd6FLDiMZC0BNbEJhdz_sA_e
 d1Lh2mW2A5YPsgg3zmHwd2Mh4mrF_Qv.TxPqp7aX1OM4trP32bmiPlDdGZG3cH1euDM2zTi3RGGR
 gVLU4Dc4duDs5yPS8bNlIrqW2Rdfp6OiUfFo61LTWsnldzZcAvHqkgRVIZAKZWziI38IU5T2Ru_y
 XKe5CR7vkpOnDV9J5mgdXnOTz0DXSJREP7olpXmLhp2qC1s2tfNz5yF18MWfMP9D3kk87qty0JXI
 x8OBCs.Ngr2QCX6nKt532PDUjGNBxd0OaXB4dn6._EF23NxsY0Fl1Qn_cOAtLooG_IuuQlWvutB0
 QPSRC6vGQ87l6MA3iFXh24HZ5OUe40xlCn0UkLhbNWPoPft5_.jiOMsb2909zIxJF4.Q7sMyfIK_
 CICbb8XsSva7oX1bW0pbNOwt3MWSKeApnKOp2J0AaOdgp.iDLftJW95ODxgMLrJdizp4SUnHLc3R
 EnfHcadnGEhaKt2_H7VY5MwADvEHtFgleSWrjlAt.j6PYJn5XC1DzddV5Y3MqDASKNSq6aLskM2q
 BuPdj1MZr4dqJjDD1f6riF00D6sMNeQL4neUXhKz0EZqfs3kSpLTPgoaKjYtOC26KvCNvDdxZZS1
 oVKw5b0iOHIWA_fnGotjkQhIAv6e5x_wkwOs.Mn2c7.wKpRJWCt8IVJD7
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Mon, 18 May 2020 22:02:13 +0000
Received: by smtp402.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 42800f23a3e897a736c226c69e116c36;
          Mon, 18 May 2020 22:02:10 +0000 (UTC)
Subject: Re: [PATCH] security: fix the default value of secid_to_secctx hook
To:     "Schaufler, Casey" <casey.schaufler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     James Morris <jamorris@linux.microsoft.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20200512174607.9630-1-anders.roxell@linaro.org>
 <CAADnVQK6cka9i_GGz3OcjaNiEQEZYwgCLsn-S_Bkm-OWPJZb_w@mail.gmail.com>
 <alpine.LRH.2.21.2005141243120.53197@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <CAADnVQJRsknY7+3zwXR-N4e6oC6E87Z32Msg4EXaM8iyB=R3qQ@mail.gmail.com>
 <CAADnVQ+WXa62R6A=nk1kOTbX8MqkbMEKDx=5KCdx5Th0NnFm7Q@mail.gmail.com>
 <CAK8P3a3CBtitXnzQf3gLx4mXuvDoVZiwwi33iCDNvtG-0jBSwQ@mail.gmail.com>
 <CY4PR11MB17990BA2B00B4CEB167057C9FDB80@CY4PR11MB1799.namprd11.prod.outlook.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 mQINBFzV9HABEAC/mmv3jeJyF7lR7QhILYg1+PeBLIMZv7KCzBSc/4ZZipoWdmr77Lel/RxQ
 1PrNx0UaM5r6Hj9lJmJ9eg4s/TUBSP67mTx+tsZ1RhG78/WFf9aBe8MSXxY5cu7IUwo0J/CG
 vdSqACKyYPV5eoTJmnMxalu8/oVUHyPnKF3eMGgE0mKOFBUMsb2pLS/enE4QyxhcZ26jeeS6
 3BaqDl1aTXGowM5BHyn7s9LEU38x/y2ffdqBjd3au2YOlvZ+XUkzoclSVfSR29bomZVVyhMB
 h1jTmX4Ac9QjpwsxihT8KNGvOM5CeCjQyWcW/g8LfWTzOVF9lzbx6IfEZDDoDem4+ZiPsAXC
 SWKBKil3npdbgb8MARPes2DpuhVm8yfkJEQQmuLYv8GPiJbwHQVLZGQAPBZSAc7IidD2zbf9
 XAw1/SJGe1poxOMfuSBsfKxv9ba2i8hUR+PH7gWwkMQaQ97B1yXYxVEkpG8Y4MfE5Vd3bjJU
 kvQ/tOBUCw5zwyIRC9+7zr1zYi/3hk+OG8OryZ5kpILBNCo+aePeAJ44znrySarUqS69tuXd
 a3lMPHUJJpUpIwSKQ5UuYYkWlWwENEWSefpakFAIwY4YIBkzoJ/t+XJHE1HTaJnRk6SWpeDf
 CreF3+LouP4njyeLEjVIMzaEpwROsw++BX5i5vTXJB+4UApTAQARAQABtChDYXNleSBTY2hh
 dWZsZXIgPGNhc2V5QHNjaGF1Zmxlci1jYS5jb20+iQJUBBMBCAA+FiEEC+9tH1YyUwIQzUIe
 OKUVfIxDyBEFAlzV9HACGwMFCRLMAwAFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQOKUV
 fIxDyBG6ag/6AiRl8yof47YOEVHlrmewbpnlBTaYNfJ5cZflNRKRX6t4bp1B2YV1whlDTpiL
 vNOwFkh+ZE0eI5M4x8Gw2Oiok+4Q5liA9PHTozQYF+Ia+qdL5EehfbLGoEBqklpGvG3h8JsO
 7SvONJuFDgvab/U/UriDYycJwzwKZuhVtK9EMpnTtUDyP3DY+Q8h7MWsniNBLVXnh4yBIEJg
 SSgDn3COpZoFTPGKE+rIzioo/GJe8CTa2g+ZggJiY/myWTS3quG0FMvwvNYvZ4I2g6uxSl7n
 bZVqAZgqwoTAv1HSXIAn9muwZUJL03qo25PFi2gQmX15BgJKQcV5RL0GHFHRThDS3IyadOgK
 P2j78P8SddTN73EmsG5OoyzwZAxXfck9A512BfVESqapHurRu2qvMoUkQaW/2yCeRQwGTsFj
 /rr0lnOBkyC6wCmPSKXe3dT2mnD5KnCkjn7KxLqexKt4itGjJz4/ynD/qh+gL7IPbifrQtVH
 JI7cr0fI6Tl8V6efurk5RjtELsAlSR6fKV7hClfeDEgLpigHXGyVOsynXLr59uE+g/+InVic
 jKueTq7LzFd0BiduXGO5HbGyRKw4MG5DNQvC//85EWmFUnDlD3WHz7Hicg95D+2IjD2ZVXJy
 x3LTfKWdC8bU8am1fi+d6tVEFAe/KbUfe+stXkgmfB7pxqW5Ag0EXNX0cAEQAPIEYtPebJzT
 wHpKLu1/j4jQcke06Kmu5RNuj1pEje7kX5IKzQSs+CPH0NbSNGvrA4dNGcuDUTNHgb5Be9hF
 zVqRCEvF2j7BFbrGe9jqMBWHuWheQM8RRoa2UMwQ704mRvKr4sNPh01nKT52ASbWpBPYG3/t
 WbYaqfgtRmCxBnqdOx5mBJIBh9Q38i63DjQgdNcsTx2qS7HFuFyNef5LCf3jogcbmZGxG/b7
 yF4OwmGsVc8ufvlKo5A9Wm+tnRjLr/9Mn9vl5Xa/tQDoPxz26+aWz7j1in7UFzAarcvqzsdM
 Em6S7uT+qy5jcqyuipuenDKYF/yNOVSNnsiFyQTFqCPCpFihOnuaWqfmdeUOQHCSo8fD4aRF
 emsuxqcsq0Jp2ODq73DOTsdFxX2ESXYoFt3Oy7QmIxeEgiHBzdKU2bruIB5OVaZ4zWF+jusM
 Uh+jh+44w9DZkDNjxRAA5CxPlmBIn1OOYt1tsphrHg1cH1fDLK/pDjsJZkiH8EIjhckOtGSb
 aoUUMMJ85nVhN1EbU/A3DkWCVFEA//Vu1+BckbSbJKE7Hl6WdW19BXOZ7v3jo1q6lWwcFYth
 esJfk3ZPPJXuBokrFH8kqnEQ9W2QgrjDX3et2WwZFLOoOCItWxT0/1QO4ikcef/E7HXQf/ij
 Dxf9HG2o5hOlMIAkJq/uLNMvABEBAAGJAjwEGAEIACYWIQQL720fVjJTAhDNQh44pRV8jEPI
 EQUCXNX0cAIbDAUJEswDAAAKCRA4pRV8jEPIEWkzEACKFUnpp+wIVHpckMfBqN8BE5dUbWJc
 GyQ7wXWajLtlPdw1nNw0Wrv+ob2RCT7qQlUo6GRLcvj9Fn5tR4hBvR6D3m8aR0AGHbcC62cq
 I7LjaSDP5j/em4oVL2SMgNTrXgE2w33JMGjAx9oBzkxmKUqprhJomPwmfDHMJ0t7y39Da724
 oLPTkQDpJL1kuraM9TC5NyLe1+MyIxqM/8NujoJbWeQUgGjn9uxQAil7o/xSCjrWCP3kZDID
 vd5ZaHpdl8e1mTExQoKr4EWgaMjmD/a3hZ/j3KfTVNpM2cLfD/QwTMaC2fkK8ExMsz+rUl1H
 icmcmpptCwOSgwSpPY1Zfio6HvEJp7gmDwMgozMfwQuT9oxyFTxn1X3rn1IoYQF3P8gsziY5
 qtTxy2RrgqQFm/hr8gM78RhP54UPltIE96VywviFzDZehMvuwzW//fxysIoK97Y/KBZZOQs+
 /T+Bw80Pwk/dqQ8UmIt2ffHEgwCTbkSm711BejapWCfklxkMZDp16mkxSt2qZovboVjXnfuq
 wQ1QL4o4t1hviM7LyoflsCLnQFJh6RSBhBpKQinMJl/z0A6NYDkQi6vEGMDBWX/M2vk9Jvwa
 v0cEBfY3Z5oFgkh7BUORsu1V+Hn0fR/Lqq/Pyq+nTR26WzGDkolLsDr3IH0TiAVH5ZuPxyz6
 abzjfg==
Message-ID: <9d0eb6c6-803a-ff3a-5603-9ad6d9edfc00@schaufler-ca.com>
Date:   Mon, 18 May 2020 15:02:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CY4PR11MB17990BA2B00B4CEB167057C9FDB80@CY4PR11MB1799.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.15960 hermes_yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.6)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/2020 2:43 PM, Schaufler, Casey wrote:
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
>> owner@vger.kernel.org> On Behalf Of Arnd Bergmann
>> Sent: Saturday, May 16, 2020 1:05 AM
>> To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
>> Cc: James Morris <jamorris@linux.microsoft.com>; Anders Roxell
>> <anders.roxell@linaro.org>; Alexei Starovoitov <ast@kernel.org>; Danie=
l
>> Borkmann <daniel@iogearbox.net>; LKML <linux-kernel@vger.kernel.org>;
>> Network Development <netdev@vger.kernel.org>; bpf
>> <bpf@vger.kernel.org>
>> Subject: Re: [PATCH] security: fix the default value of secid_to_secct=
x hook
> I would *really* appreciate it if discussions about the LSM infrastruct=
ure
> where done on the linux-security-module mail list. (added to CC).
>
>> On Sat, May 16, 2020 at 1:29 AM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> On Thu, May 14, 2020 at 12:47 PM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>> On Thu, May 14, 2020 at 12:43 PM James Morris
>>>> <jamorris@linux.microsoft.com> wrote:
>>>>> On Wed, 13 May 2020, Alexei Starovoitov wrote:
>>>>>
>>>>>> James,
>>>>>>
>>>>>> since you took the previous similar patch are you going to pick th=
is
>>>>>> one up as well?
>>>>>> Or we can route it via bpf tree to Linus asap.
>>>>> Routing via your tree is fine.
>>>> Perfect.
>>>> Applied to bpf tree. Thanks everyone.
>>> Looks like it was a wrong fix.
>>> It breaks audit like this:
>>> sudo auditctl -e 0
>>> [   88.400296] audit: error in audit_log_task_context
>>> [   88.400976] audit: error in audit_log_task_context
>>> [   88.401597] audit: type=3D1305 audit(1589584951.198:89): op=3Dset
>>> audit_enabled=3D0 old=3D1 auid=3D0 ses=3D1 res=3D0
>>> [   88.402691] audit: type=3D1300 audit(1589584951.198:89):
>>> arch=3Dc000003e syscall=3D44 success=3Dyes exit=3D52 a0=3D3 a1=3D7ffe=
42a37400
>>> a2=3D34 a3=3D0 items=3D0 ppid=3D2250 pid=3D2251 auid=3D0 uid=3D0 gid=3D=
0 euid=3D0 suid=3D0
>>> fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3DttyS0 se)
>>> [   88.405587] audit: type=3D1327 audit(1589584951.198:89):
>>> proctitle=3D617564697463746C002D650030
>>> Error sending enable request (Operation not supported)
>>>
>>> when CONFIG_LSM=3D has "bpf" in it.
>> Do you have more than one LSM enabled? It looks like
>> the problem with security_secid_to_secctx() is now that it
>> returns an error if any of the LSMs fail and the caller expects
>> it to succeed if at least one of them sets the secdata pointer.

security_secid_to_secctx() is not currently stackable (I'm
looking at 5.7-rc6) even for this simple case. call_int_hook()
does bail-on-fail and will try all hooks registered, looking for
a failure.

You need to replace the call_int_hook() with an explicit
hlist_for_each_entry(), as is done in security_inode_getsecurity().

>>
>> The problem earlier was that the call succeeded even though
>> no LSM had set the pointer.
>>
>> What is the behavior we actually expect from this function if
>> multiple LSM are loaded?
>>
>>        Arnd

