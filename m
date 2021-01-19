Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743C22FAE44
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 02:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391820AbhASBLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 20:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387440AbhASBLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 20:11:43 -0500
X-Greylist: delayed 130 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jan 2021 17:11:03 PST
Received: from fox.pavlix.cz (fox.pavlix.cz [IPv6:2a01:430:17:1::ffff:1417])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 204F6C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 17:11:03 -0800 (PST)
Received: from [172.16.63.206] (unknown [217.30.64.218])
        by fox.pavlix.cz (Postfix) with ESMTPSA id 4B118E7278;
        Tue, 19 Jan 2021 02:11:02 +0100 (CET)
Subject: Re: mdio: access c22 registers via debugfs
From:   =?UTF-8?Q?Pavel_=c5=a0imerda?= <code@simerda.eu>
To:     Tobias Waldekranz <tobias@waldekranz.com>, netdev@vger.kernel.org
References: <20210116211916.8329-1-code@simerda.eu>
 <87h7ndker7.fsf@waldekranz.com>
 <204006a5-004e-03ce-6117-86f391d6aece@simerda.eu>
Message-ID: <29e3adac-00b5-f1d3-8976-3ed93f849475@simerda.eu>
Date:   Tue, 19 Jan 2021 02:11:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <204006a5-004e-03ce-6117-86f391d6aece@simerda.eu>
Content-Type: multipart/mixed;
 boundary="------------7C1D2BC5E3D1BF9EE1924DD6"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------7C1D2BC5E3D1BF9EE1924DD6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

My mdio acces script attached.

Regards,

Pavel


On 1/19/21 2:08 AM, Pavel Šimerda wrote:
> Hi Tobias,
> 
> given the reasons stated in the mailing list, I'd like to discuss the situation off-list. I would be more than happy to join your effort and provide an OpenWRT package. I understand the motivation to reject that, and I do use it partially also for the “bad purpose” and therefore I'd like to solve it as consistently as possible.
> 
> I'm working with mv88e6xxx where c45 can be coded in c22 anyway, so I didn't care to implement it in the MDIO driver. I'd like to share with you the user space script I'm using to access both mv88e6xxx and direct PHY registers.
> 
> I see you're working with mv88e6xxx as well. Can you access all of the inderect registers up to multichip+indirect+paged/c45 registers even without the mv88e6xxx driver loaded, or not? I'm using this feature to bootstrap the switch and get it onto the network when the driver doesn't work yet.
> 
> I've seen a few new patches submitted to next-next regarding mv88e6393 and the lag support. I'm also going to explore MSTP and more. I published some of my changes that might not be accepted upstream any soon, or like this one, at all:
> 
> https://github.com/switchwrt
> 
> Regards,
> 
> Pavel

--------------7C1D2BC5E3D1BF9EE1924DD6
Content-Type: text/plain; charset=UTF-8;
 name="mdio"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mdio"

IyEvYmluL3NoCgpJRlM9LAoKaWYgWyAteiAiJE1ESU9fQ09OVFJPTCIgXTsgdGhlbgoJTURJ
T19DT05UUk9MPS9zeXMva2VybmVsL2RlYnVnL21kaW8vZjAwMjgwMDAuZXRoZXJuZXQvY29u
dHJvbApmaQoKdmVyYm9zZT0KcGh5X2NoaXBhZGRyPQpwaHlfcGFnZT0KcGh5X2FkZHJlc3M9
CnBoeV9kZXZpY2U9CnBoeV9vZmZzZXQ9CnBoeV9iaXRzPQpwaHlfdmFsdWU9Cgp3aGlsZSBb
ICQjICE9IDAgXTsgZG8KCWNhc2UgJDEgaW4KCS12fC0tdmVyYm9zZSkKCQl2ZXJib3NlPTEK
CQk7OwoJLW58LS1uby13cml0ZSkKCQlub193cml0ZT0xCgkJOzsKCS1MfC0tbGluaykKCQlN
RElPX0NPTlRST0w9L3N5cy9rZXJuZWwvZGVidWcvbWRpby9mODAyYzAwMC5ldGhlcm5ldC9j
b250cm9sCgkJOzsKCS1TfC0tc3dpdGNoKQoJCU1ESU9fQ09OVFJPTD0vc3lzL2tlcm5lbC9k
ZWJ1Zy9tZGlvL2YwMDI4MDAwLmV0aGVybmV0L2NvbnRyb2wKCQk7OwoJLVB8LS1waHkpCgkJ
TURJT19DT05UUk9MPSQoZWNobyAvc3lzL2tlcm5lbC9kZWJ1Zy9tZGlvLyFhaGIhYXBiIWV0
aGVybmV0QGYwMDI4MDAwIXN3aXRjaDBAKiFtZGlvL2NvbnRyb2wpCgkJOzsKCS1tfC0tbXVs
dGljaGlwKQoJCXNoaWZ0CgkJcGh5X2NoaXBhZGRyPSQxCgkJOzsKCS1wfC0tcGFnZSkKCQlz
aGlmdAoJCXBoeV9wYWdlPSQxCgkJOzsKCS1hfC0tYWRkcmVzcykKCQlzaGlmdAoJCXBoeV9h
ZGRyZXNzZXM9JDEKCQk7OwoJLWR8LS1kZXZpY2UpCgkJc2hpZnQKCQlwaHlfZGV2aWNlPSQx
CgkJOzsKCS1vfC0tb2Zmc2V0KQoJCXNoaWZ0CgkJcGh5X29mZnNldD0kMQoJCTs7CgktYnwt
LWJpdHMpCgkJc2hpZnQKCQlwaHlfYml0cz0kMQoJCTs7Cgktd3wtLXdyaXRlKQoJCXNoaWZ0
CgkJcGh5X3ZhbHVlPSQxCgkJOzsKCWVzYWMKCXNoaWZ0CmRvbmUKCnBhcnNlX2JpdHMoKSB7
CgliaXRfc3RvcD0kezElOip9CgliaXRfc3RhcnQ9JHsxIyo6fQoJYml0X3N0b3A9JCgoYml0
X3N0b3AgKyAxKSkKfQoKX2dldF9iaXRzKCkgewoJbG9jYWwgYml0X3N0YXJ0IGJpdF9zdG9w
CglwYXJzZV9iaXRzICIkMSIKCXZhbHVlPSIkMiIKCglwcmludGYgIjB4JS4wNHhcbiIgIiQo
KCAodmFsdWUgJiAoKDE8PGJpdF9zdG9wKSAtIDEpKSA+PiBiaXRfc3RhcnQgKSkiCn0KCl9z
ZXRfYml0cygpIHsKCWxvY2FsIG9yaWdpbmFsPSIkMSIKCWxvY2FsIGJpdF9zdGFydCBiaXRf
c3RvcAoJcGFyc2VfYml0cyAiJDIiCglsb2NhbCB2YWx1ZT0iJDMiCgoJbG9jYWwgbWFzaz0i
JCgoICgxPDxiaXRfc3RvcCkgLSAoMTw8Yml0X3N0YXJ0KSApKSIKCXByaW50ZiAiMHglLjA0
eFxuIiAiJCgoIChvcmlnaW5hbCAmIH5tYXNrKSB8ICgodmFsdWUgPDwgYml0X3N0YXJ0KSAm
IG1hc2spICkpIgp9CgpkaXJlY3RfY21kKCkgewoJZWNobyAtbiAiJDEiID4mMwp9CgpkaXJl
Y3RfcmVhZCgpIHsKCWRpcmVjdF9jbWQgJChwcmludGYgIiUuMng6JS4yeFxuIiAiJDEiICIk
MiIpCgllY2hvICIweCQoaGVhZCAtbiAxIDwmMykiCn0KCmRpcmVjdF93cml0ZSgpIHsKCWRp
cmVjdF9jbWQgJChwcmludGYgIiUuMng6JS4yeDolLjR4XG4iICIkMSIgIiQyIiAiJDMiKQp9
CgppbmRpcmVjdF93YWl0KCkgewoJcmV0PSQoZGlyZWN0X3JlYWQgIiRwaHlfY2hpcGFkZHIi
IDB4MDApCgl3aGlsZSBbICQoKCByZXQgJiAweDgwMDAgKSkgIT0gMCBdOyBkbwoJCXNsZWVw
IDEKCQlyZXQ9JChkaXJlY3RfcmVhZCAiJHBoeV9jaGlwYWRkciIgMHgwMCkKCWRvbmUKfQoK
aW5kaXJlY3RfcmVhZCgpIHsKCWFkZHJlc3M9IiQxIgoJb2Zmc2V0PSIkMiIKCWNtZD0kKHBy
aW50ZiAiMHglLjR4IiAiJCgoIDB4OTgwMCB8ICgoYWRkcmVzcyAmIDB4MWYpIDw8IDUpIHwg
KG9mZnNldCAmIDB4MWYpICkpIikKCWluZGlyZWN0X3dhaXQKCWRpcmVjdF93cml0ZSAiJHBo
eV9jaGlwYWRkciIgMHgwMCAiJGNtZCIKCWluZGlyZWN0X3dhaXQKCWRpcmVjdF9yZWFkICIk
cGh5X2NoaXBhZGRyIiAweDAxCn0KCmluZGlyZWN0X3dyaXRlKCkgewoJYWRkcmVzcz0iJDEi
CglvZmZzZXQ9IiQyIgoJZGF0YT0iJDMiCgljbWQ9JChwcmludGYgIjB4JS40eCIgIiQoKCAw
eDk0MDAgfCAoKGFkZHJlc3MgJiAweDFmKSA8PCA1KSB8IChvZmZzZXQgJiAweDFmKSApKSIp
CglpbmRpcmVjdF93YWl0CglkaXJlY3Rfd3JpdGUgIiRwaHlfY2hpcGFkZHIiIDB4MDEgIiRk
YXRhIgoJZGlyZWN0X3dyaXRlICIkcGh5X2NoaXBhZGRyIiAweDAwICIkY21kIgoJaW5kaXJl
Y3Rfd2FpdAp9CgptZGlvX3JlYWQoKSB7Cglsb2NhbCBhZGRyZXNzPSIkMSIKCWxvY2FsIG9m
ZnNldD0iJDIiCglsb2NhbCBiaXRzPSIkMyIKCVsgIiR2ZXJib3NlIiA9IDEgXSAmJiBwcmlu
dGYgInJlYWQ6IDB4JS4yeDoweCUuMnhcbiIgIiRhZGRyZXNzIiAiJG9mZnNldCIgPiYyCglp
ZiBbIC1uICIkcGh5X2NoaXBhZGRyIiBdOyB0aGVuCgkJdmFsdWU9JChpbmRpcmVjdF9yZWFk
ICIkYWRkcmVzcyIgIiRvZmZzZXQiKQoJZWxzZQoJCXZhbHVlPSQoZGlyZWN0X3JlYWQgIiRh
ZGRyZXNzIiAiJG9mZnNldCIpCglmaQoJWyAkPyA9IDAgXSB8fCBlY2hvICJSZWFkIGVycm9y
OiBhZGRyZXNzPSQxIG9mZnNldD0kMiIgPiYyCgoJaWYgWyAteiAiJGJpdHMiIF07IHRoZW4K
CQllY2hvICR2YWx1ZQoJZWxzZQoJCV9nZXRfYml0cyAiJGJpdHMiICIkdmFsdWUiCglmaQp9
CgptZGlvX3dyaXRlKCkgewoJbG9jYWwgYWRkcmVzcz0iJDEiCglsb2NhbCBvZmZzZXQ9IiQy
IgoJbG9jYWwgYml0cz0iJDMiCglsb2NhbCB2YWx1ZT0iJDQiCgoJaWYgWyAtbiAiJGJpdHMi
IF07IHRoZW4KCQlvcmlnaW5hbD0iJChtZGlvX3JlYWQgIiRhZGRyZXNzIiAiJG9mZnNldCIp
IgoJCXZhbHVlPSIkKF9zZXRfYml0cyAiJG9yaWdpbmFsIiAiJGJpdHMiICIkdmFsdWUiKSIK
CWZpCgoJWyAtbiAiJHZlcmJvc2UiIC1hIC1uICIkbm9fd3JpdGUiIF0gJiYgcHJpbnRmICJu
byAiCglbIC1uICIkdmVyYm9zZSIgXSAmJiBwcmludGYgIndyaXRlOiAweCUuMng6MHglLjJ4
ID0gJS40eFxuIiAiJGFkZHJlc3MiICIkb2Zmc2V0IiAiJHZhbHVlIiA+JjIKCWlmIFsgLXog
IiRub193cml0ZSIgXTsgdGhlbgoJCWlmIFsgLW4gIiRwaHlfY2hpcGFkZHIiIF07IHRoZW4K
CQkJaW5kaXJlY3Rfd3JpdGUgIiRhZGRyZXNzIiAiJG9mZnNldCIgIiR2YWx1ZSIKCQllbHNl
CgkJCWRpcmVjdF93cml0ZSAiJGFkZHJlc3MiICIkb2Zmc2V0IiAiJHZhbHVlIgoJCWZpCgkJ
WyAkPyA9IDAgXSB8fCBlY2hvICJXcml0ZSBlcnJvcjogYWRkcmVzcz0kMSBvZmZzZXQ9JDIg
dmFsdWU9JDMiID4mMgoJZmkKfQoKIyBUT0RPOiBSZW1lbWJlciBhbmQgcmVzZXQgb3JpZ2lu
YWwgcGFnZSByYXRoZXIgdGhhbiAweDAwMDEuCm1kaW9fcGFnZV9zZXQoKSB7CglpZiBbIC1u
ICIkcGh5X3BhZ2UiIF07IHRoZW4KCQlwaHlfb3JpZ19wYWdlPSIkKG1kaW9fcmVhZCAiJDEi
IDB4MTYpIgoJCW1kaW9fd3JpdGUgIiQxIiAweDE2ICIkcGh5X3BhZ2UiCglmaQp9CgptZGlv
X3BhZ2VfcmVzZXQoKSB7CglbIC1uICIkcGh5X3BhZ2UiIF0gJiYgbWRpb193cml0ZSAiJDEi
IDB4MTYgIiQocGh5X29yaWdfcGFnZSkiCn0KCnVzYWdlKCkgewoJZWNobyAiR2V0IGMyMiBy
ZWdpc3RlcjoiCgllY2hvICIgIG1kaW8gLS1waHkgLS1hZGRyZXNzIDAgLS1vZmZzZXQgMHgw
MCIKCWVjaG8gIiAgbWRpbyAtUCAtYSAwIC1vIDB4MDAiCgllY2hvICJTZXQgYzIyIHJlZ2lz
dGVyOiIKCWVjaG8gIiAgbWRpbyAtLXBoeSAtLWFkZHJlc3MgMCAtLW9mZnNldCAweDAwIC0t
d3JpdGUgMHg4MDAwIgoJZWNobyAiICBtZGlvIC1QIC1hIDAgLW8gMHgwMCAtdyAweDgwMDAi
CgllY2hvICJOb3RlOiBSZWFkIHRoZSBzb3VyY2UuIgoJZXhpdCAxCn0KCmV4ZWMgMzw+IiRN
RElPX0NPTlRST0wiClsgLW4gIiRwaHlfYWRkcmVzc2VzIiAtYSAtbiAiJHBoeV9vZmZzZXQi
IF0gfHwgdXNhZ2UKCmZvciBwaHlfYWRkcmVzcyBpbiAkcGh5X2FkZHJlc3NlczsgZG8KCVsg
LW4gIiRwaHlfZGV2aWNlIiBdICYmIHBoeV9vZmZzZXQ9JCgoIHBoeV9vZmZzZXQgfCBwaHlf
ZGV2aWNlIDw8IDE2IHwgMHg0MDAwMDAwMCApKQoKCW1kaW9fcGFnZV9zZXQgIiRwaHlfYWRk
cmVzcyIKCWlmIFsgLW4gIiRwaHlfdmFsdWUiIF07IHRoZW4KCQltZGlvX3dyaXRlICIkcGh5
X2FkZHJlc3MiICIkcGh5X29mZnNldCIgIiRwaHlfYml0cyIgIiRwaHlfdmFsdWUiCgllbHNl
CgkJbWRpb19yZWFkICIkcGh5X2FkZHJlc3MiICIkcGh5X29mZnNldCIgIiRwaHlfYml0cyIK
CWZpCgltZGlvX3BhZ2VfcmVzZXQgIiRwaHlfYWRkcmVzcyIKZG9uZQo=
--------------7C1D2BC5E3D1BF9EE1924DD6--
